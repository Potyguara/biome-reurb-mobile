import 'dart:io';

import '../../mobile/presentation/device_identity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../core/widgets/loading_dialog.dart';
import '../../../data/local/database_provider.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DocumentosPage extends ConsumerStatefulWidget {
  const DocumentosPage({super.key});

  @override
  ConsumerState<DocumentosPage> createState() => _DocumentosPageState();
}

class _DocumentosPageState extends ConsumerState<DocumentosPage> {
  final _formKey = GlobalKey<FormState>();
  final _observacoesController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String? _cadastroSelecionadoId;
  String? _projetoSelecionadoId;
  String? _selagemSelecionadaId;
  String? _codigoSelo;

  String _tipoDocumento = 'fachada';

  XFile? _arquivoSelecionado;

  late Future<List<Map<String, Object?>>> _futureCadastros;
  late Future<List<Map<String, Object?>>> _futureDocumentos;

  String? _editingDocumentoId;
  String? _arquivoOriginalPath;

  bool get _isEditing => _editingDocumentoId != null;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _visualizarDocumento(Map<String, Object?> doc) async {
    final path = doc['arquivo_path']?.toString();

    if (path == null || path.trim().isEmpty) {
      await _mostrarAviso(
        titulo: 'Arquivo não encontrado',
        mensagem: 'Este documento não possui caminho de arquivo registrado.',
      );
      return;
    }

    final file = File(path);

    if (!await file.exists()) {
      await _mostrarAviso(
        titulo: 'Arquivo não encontrado',
        mensagem:
            'O arquivo não foi localizado no dispositivo.\n\nCaminho:\n$path',
      );
      return;
    }

    if (!mounted) return;

    final tipo = _labelDocumento(doc['tipo_documento']?.toString() ?? '');
    final codigoSelo = doc['codigo_selo']?.toString() ?? '';
    final responsavel = doc['nome_responsavel']?.toString() ?? '';

    await showDialog<void>(
      context: context,
      builder: (_) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: Text(tipo),
              actions: [
                IconButton(
                  tooltip: 'Fechar',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            body: Column(
              children: [
                Material(
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Selagem: $codigoSelo\n'
                        'Responsável: ${responsavel.isEmpty ? 'não informado' : responsavel}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 5,
                    child: Center(
                      child: Image.file(
                        file,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _prepararEdicaoDocumento(Map<String, Object?> documento) {
    setState(() {
      _editingDocumentoId = documento['id']?.toString();

      _projetoSelecionadoId = documento['projeto_id']?.toString();
      _selagemSelecionadaId = documento['selagem_id']?.toString();
      _cadastroSelecionadoId = documento['cadastro_social_id']?.toString();
      _codigoSelo = documento['codigo_selo']?.toString();

      _tipoDocumento = _valorPermitido(
        documento['tipo_documento']?.toString(),
        const {
          'fachada',
          'rg_frente',
          'rg_verso',
          'cpf',
          'comprovante_residencia',
          'documento_posse',
          'declaracao',
          'outro',
        },
        'fachada',
      );

      _arquivoOriginalPath = documento['arquivo_path']?.toString();
      _arquivoSelecionado = null;

      _observacoesController.text = documento['observacoes']?.toString() ?? '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Documento carregado para edição.'),
      ),
    );
  }

  String _valorPermitido(
    String? value,
    Set<String> permitidos,
    String fallback,
  ) {
    if (value != null && permitidos.contains(value)) {
      return value;
    }

    return fallback;
  }

  Future<String> _copiarArquivoParaPastaPersistente({
    required String arquivoOriginalPath,
    required String codigoSelo,
    required String tipoDocumento,
  }) async {
    final origem = File(arquivoOriginalPath);

    if (!await origem.exists()) {
      throw Exception('Arquivo original não encontrado: $arquivoOriginalPath');
    }

    final appDir = await getApplicationDocumentsDirectory();

    final documentosDir = Directory(
      p.join(
        appDir.path,
        'documentos_reurb',
        _normalizarNomeArquivo(codigoSelo),
      ),
    );

    if (!await documentosDir.exists()) {
      await documentosDir.create(recursive: true);
    }

    final extensao = p.extension(arquivoOriginalPath).isNotEmpty
        ? p.extension(arquivoOriginalPath)
        : '.jpg';

    final safeSelo = _normalizarNomeArquivo(codigoSelo);
    final safeTipo = _normalizarNomeArquivo(tipoDocumento);
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final destinoPath = p.join(
      documentosDir.path,
      '${safeSelo}_${safeTipo}_$timestamp$extensao',
    );

    final destino = await origem.copy(destinoPath);

    return destino.path;
  }

  String _normalizarNomeArquivo(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');
  }

  bool _isArquivoTemporario(String path) {
    return path.contains('/tmp/') ||
        path.contains('/private/var/mobile/Containers/Data/Application') &&
            path.contains('/tmp/');
  }

  void _cancelarEdicaoDocumento() {
    setState(() {
      _limparFormulario();
    });
  }

  Future<void> _confirmarExclusaoDocumento(
    Map<String, Object?> documento,
  ) async {
    final id = documento['id']?.toString();

    if (id == null || id.isEmpty) {
      await _mostrarAviso(
        titulo: 'Erro na exclusão',
        mensagem: 'Não foi possível identificar o documento selecionado.',
      );
      return;
    }

    final tipo = _labelDocumento(
      documento['tipo_documento']?.toString() ?? '',
    );

    final codigo = documento['codigo_selo']?.toString() ?? '';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirmar exclusão'),
          content: Text(
            'Deseja realmente excluir o documento "$tipo" da selagem "$codigo"?\n\n'
            'O registro será removido do banco local e o arquivo da imagem/documento será apagado do dispositivo.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.delete),
              label: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await _excluirDocumento(id);
    }
  }

  Future<void> _excluirDocumento(String id) async {
    LoadingDialog.show(
      context,
      title: 'Excluindo documento',
      message: 'Removendo documento e arquivo local do dispositivo...',
    );

    try {
      final db = ref.read(appDatabaseProvider);

      await db.excluirDocumentoReurb(
        id: id,
        apagarArquivo: true,
      );

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(() {
        if (_editingDocumentoId == id) {
          _limparFormulario();
        }

        _carregarDados();
      });

      await _mostrarAviso(
        titulo: 'Documento excluído',
        mensagem: 'O documento e o arquivo local foram excluídos com sucesso.',
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro ao excluir',
        mensagem: 'Não foi possível excluir o documento.\n\nDetalhes: $e',
      );
    }
  }

  void _carregarDados() {
    final db = ref.read(appDatabaseProvider);
    _futureCadastros = db.listarCadastrosSociaisParaDocumentos();
    _futureDocumentos = db.listarDocumentosReurb();
  }

  void _selecionarCadastro(
    String? value,
    List<Map<String, Object?>> cadastros,
  ) {
    if (value == null) return;

    final cadastro = cadastros.firstWhere(
      (item) => item['id']?.toString() == value,
    );

    setState(() {
      _cadastroSelecionadoId = value;
      _projetoSelecionadoId = cadastro['projeto_id']?.toString();
      _selagemSelecionadaId = cadastro['selagem_id']?.toString();
      _codigoSelo = cadastro['codigo_selo']?.toString();
    });
  }

  Future<void> _capturarFoto() async {
    LoadingDialog.show(
      context,
      title: 'Abrindo câmera',
      message: 'Prepare o documento ou a fachada para registro...',
    );

    try {
      final foto = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1600,
      );

      if (!mounted) return;

      LoadingDialog.hide(context);

      if (foto == null) {
        await _mostrarAviso(
          titulo: 'Captura cancelada',
          mensagem: 'Nenhuma imagem foi capturada.',
        );
        return;
      }

      setState(() {
        _arquivoSelecionado = foto;
      });

      await _mostrarAviso(
        titulo: 'Imagem capturada',
        mensagem:
            'A imagem foi capturada e está pronta para ser salva no dossiê.',
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro ao capturar imagem',
        mensagem: 'Não foi possível abrir a câmera.\n\nDetalhes: $e',
      );
    }
  }

  void _limparFormulario() {
    _editingDocumentoId = null;
    _arquivoOriginalPath = null;

    _cadastroSelecionadoId = null;
    _projetoSelecionadoId = null;
    _selagemSelecionadaId = null;
    _codigoSelo = null;

    _tipoDocumento = 'fachada';
    _arquivoSelecionado = null;
    _observacoesController.clear();
  }

  Future<void> _salvarDocumento() async {
    if (!_formKey.currentState!.validate()) return;

    if (_cadastroSelecionadoId == null ||
        _projetoSelecionadoId == null ||
        _codigoSelo == null) {
      await _mostrarAviso(
        titulo: 'Cadastro obrigatório',
        mensagem: 'Selecione um cadastro social antes de salvar documentos.',
      );
      return;
    }

    final arquivoSelecionadoPath = _arquivoSelecionado?.path;
    final arquivoExistentePath = _arquivoOriginalPath;

    final arquivoBasePath = arquivoSelecionadoPath ?? arquivoExistentePath;
    final sourceDeviceId = await ref.read(deviceIdentityProvider.future);

    if (arquivoBasePath == null || arquivoBasePath.isEmpty) {
      await _mostrarAviso(
        titulo: 'Imagem obrigatória',
        mensagem: 'Capture uma foto antes de salvar o documento.',
      );
      return;
    }

    LoadingDialog.show(
      context,
      title: _isEditing ? 'Atualizando documento' : 'Salvando documento',
      message: _isEditing
          ? 'Atualizando o documento no dossiê local do beneficiário...'
          : 'Registrando a imagem no dossiê local do beneficiário...',
    );

    try {
      final db = ref.read(appDatabaseProvider);

      final observacoes = _observacoesController.text.trim().isEmpty
          ? null
          : _observacoesController.text.trim();

      String arquivoPersistentePath = arquivoBasePath;

      final precisaCopiarArquivo = arquivoSelecionadoPath != null ||
          _isArquivoTemporario(arquivoBasePath);

      if (precisaCopiarArquivo) {
        arquivoPersistentePath = await _copiarArquivoParaPastaPersistente(
          arquivoOriginalPath: arquivoBasePath,
          codigoSelo: _codigoSelo!,
          tipoDocumento: _tipoDocumento,
        );
      }

      if (_isEditing) {
        final houveTrocaArquivo = arquivoSelecionadoPath != null &&
            arquivoExistentePath != null &&
            arquivoPersistentePath != arquivoExistentePath;

        await db.atualizarDocumentoReurb(
          id: _editingDocumentoId!,
          projetoId: _projetoSelecionadoId!,
          selagemId: _selagemSelecionadaId,
          cadastroSocialId: _cadastroSelecionadoId,
          codigoSelo: _codigoSelo!,
          tipoDocumento: _tipoDocumento,
          arquivoPath: arquivoPersistentePath,
          observacoes: observacoes,
        );

        if (houveTrocaArquivo && arquivoExistentePath.isNotEmpty) {
          final antigo = File(arquivoExistentePath);

          if (await antigo.exists()) {
            await antigo.delete();
          }
        }
      } else {
        await db.inserirDocumentoReurb(
          id: const Uuid().v4(),
          projetoId: _projetoSelecionadoId!,
          selagemId: _selagemSelecionadaId,
          cadastroSocialId: _cadastroSelecionadoId,
          codigoSelo: _codigoSelo!,
          tipoDocumento: _tipoDocumento,
          arquivoPath: arquivoPersistentePath,
          observacoes: observacoes,
          sourceDeviceId: sourceDeviceId,
        );
      }

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(() {
        _limparFormulario();
        _carregarDados();
      });

      await _mostrarAviso(
        titulo: _isEditing ? 'Documento atualizado' : 'Documento salvo',
        mensagem: _isEditing
            ? 'O documento foi atualizado com sucesso no dossiê local.'
            : 'A imagem foi registrada com sucesso no dossiê local.',
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: _isEditing ? 'Erro ao atualizar' : 'Erro ao salvar',
        mensagem: 'Não foi possível salvar o documento.\n\nDetalhes: $e',
      );
    }
  }

  Future<void> _mostrarAviso({
    required String titulo,
    required String mensagem,
  }) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(titulo),
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _labelDocumento(String value) {
    switch (value) {
      case 'fachada':
        return 'Foto da fachada';
      case 'rg_frente':
        return 'RG - frente';
      case 'rg_verso':
        return 'RG - verso';
      case 'cpf':
        return 'CPF';
      case 'comprovante_residencia':
        return 'Comprovante de residência';
      case 'documento_posse':
        return 'Documento do imóvel';
      case 'declaracao':
        return 'Declaração';
      case 'outro':
        return 'Outro';
      default:
        return value;
    }
  }

  Widget _previewImagem() {
    final path = _arquivoSelecionado?.path ?? _arquivoOriginalPath;

    if (path == null || path.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Nenhuma imagem capturada.'),
        ),
      );
    }

    final file = File(path);

    if (!file.existsSync()) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Arquivo de imagem não encontrado no dispositivo.'),
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Image.file(
        file,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documentos e Fotos'),
      ),
      body: FutureBuilder<List<Map<String, Object?>>>(
        future: _futureCadastros,
        builder: (context, cadastrosSnapshot) {
          if (cadastrosSnapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LinearProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Carregando cadastros sociais...'),
                    ],
                  ),
                ),
              ),
            );
          }

          final cadastros = cadastrosSnapshot.data ?? [];

          if (cadastros.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Nenhum cadastro social encontrado. Finalize o cadastro social antes de anexar documentos.',
                  ),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                _isEditing ? 'Editar Documento' : 'Novo Documento',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: _cadastroSelecionadoId,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Beneficiário / Cadastro Social',
                            prefixIcon: Icon(Icons.people),
                          ),
                          items: cadastros.map((cadastro) {
                            return DropdownMenuItem<String>(
                              value: cadastro['id']?.toString(),
                              child: Text(
                                '${cadastro['codigo_selo']} - ${cadastro['nome_responsavel']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) => _selecionarCadastro(
                            value,
                            cadastros,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Selecione o cadastro social.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _tipoDocumento,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de documento',
                            prefixIcon: Icon(Icons.description),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'fachada',
                              child: Text('Foto da fachada'),
                            ),
                            DropdownMenuItem(
                              value: 'rg_frente',
                              child: Text('RG - frente'),
                            ),
                            DropdownMenuItem(
                              value: 'rg_verso',
                              child: Text('RG - verso'),
                            ),
                            DropdownMenuItem(
                              value: 'cpf',
                              child: Text('CPF'),
                            ),
                            DropdownMenuItem(
                              value: 'comprovante_residencia',
                              child: Text('Comprovante de residência'),
                            ),
                            DropdownMenuItem(
                              value: 'documento_posse',
                              child: Text('Documento do imóvel'),
                            ),
                            DropdownMenuItem(
                              value: 'declaracao',
                              child: Text('Declaração'),
                            ),
                            DropdownMenuItem(
                              value: 'outro',
                              child: Text('Outro'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _tipoDocumento = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        _previewImagem(),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _capturarFoto,
                          icon: const Icon(Icons.camera_alt),
                          label: Text(
                              _isEditing ? 'SUBSTITUIR FOTO' : 'CAPTURAR FOTO'),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _observacoesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Observações',
                            prefixIcon: Icon(Icons.notes),
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _salvarDocumento,
                          icon: Icon(_isEditing ? Icons.update : Icons.save),
                          label: Text(
                            _isEditing
                                ? 'ATUALIZAR DOCUMENTO'
                                : 'SALVAR DOCUMENTO',
                          ),
                        ),
                        if (_isEditing) ...[
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: _cancelarEdicaoDocumento,
                            icon: const Icon(Icons.close),
                            label: const Text('CANCELAR EDIÇÃO'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Documentos registrados',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Map<String, Object?>>>(
                future: _futureDocumentos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            LinearProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Carregando documentos registrados...'),
                          ],
                        ),
                      ),
                    );
                  }

                  final documentos = snapshot.data ?? [];

                  if (documentos.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Nenhum documento registrado.'),
                      ),
                    );
                  }

                  return Column(
                    children: documentos.map((doc) {
                      final path = doc['arquivo_path']?.toString();
                      final file =
                          path == null || path.isEmpty ? null : File(path);
                      final existeArquivo = file != null && file.existsSync();

                      return Card(
                        child: ListTile(
                          onTap: () => _visualizarDocumento(doc),
                          leading: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => _visualizarDocumento(doc),
                            child: existeArquivo
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      file,
                                      width: 52,
                                      height: 52,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const SizedBox(
                                    width: 52,
                                    height: 52,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Color(0xFF1B5E20),
                                    ),
                                  ),
                          ),
                          title: Text(
                            _labelDocumento(
                              doc['tipo_documento']?.toString() ?? '',
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${doc['codigo_selo'] ?? ''} • ${doc['nome_responsavel'] ?? ''}\n'
                            'CPF: ${doc['cpf_responsavel'] ?? 'não informado'}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          isThreeLine: true,
                          trailing: Wrap(
                            spacing: 2,
                            children: [
                              IconButton(
                                tooltip: 'Editar documento',
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _prepararEdicaoDocumento(doc),
                              ),
                              IconButton(
                                tooltip: 'Excluir documento',
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _confirmarExclusaoDocumento(doc),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
