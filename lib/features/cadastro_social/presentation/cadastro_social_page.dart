import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/widgets/loading_dialog.dart';
import '../../../data/local/database_provider.dart';

class CadastroSocialPage extends ConsumerStatefulWidget {
  const CadastroSocialPage({super.key});

  @override
  ConsumerState<CadastroSocialPage> createState() => _CadastroSocialPageState();
}

class _CadastroSocialPageState extends ConsumerState<CadastroSocialPage> {
  final _formKey = GlobalKey<FormState>();

  final _codigoSeloController = TextEditingController();
  final _nomeResponsavelController = TextEditingController();
  final _cpfController = TextEditingController();
  final _rgController = TextEditingController();
  final _orgaoEmissorController = TextEditingController();
  final _profissaoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _quantidadeMoradoresController = TextEditingController();
  final _rendaFamiliarController = TextEditingController();
  final _programaSocialController = TextEditingController();
  final _tempoOcupacaoController = TextEditingController();
  final _observacoesController = TextEditingController();

  String? _selagemSelecionadaId;
  String? _projetoSelecionadoId;

  String _estadoCivil = 'solteiro';
  String _formaOcupacao = 'posse';
  String _documentoPosse = 'nenhum';

  bool _recebeProgramaSocial = false;
  bool _possuiOutroImovel = false;
  bool _possuiConflito = false;

  late Future<List<Map<String, Object?>>> _futureSelagens;
  late Future<List<Map<String, Object?>>> _futureCadastros;

  String? _codigoLotePreliminar;
  String? _statusVinculoGeografico;
  bool _necessitaValidacaoRtk = false;

  String? _editingCadastroId;

  bool get _isEditing => _editingCadastroId != null;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _codigoSeloController.dispose();
    _nomeResponsavelController.dispose();
    _cpfController.dispose();
    _rgController.dispose();
    _orgaoEmissorController.dispose();
    _profissaoController.dispose();
    _telefoneController.dispose();
    _quantidadeMoradoresController.dispose();
    _rendaFamiliarController.dispose();
    _programaSocialController.dispose();
    _tempoOcupacaoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  void _carregarDados() {
    final db = ref.read(appDatabaseProvider);
    _futureSelagens = db.listarSelagensParaCadastroSocial();
    _futureCadastros = db.listarCadastrosSociais();
  }

  bool _boolFromDb(Object? value) {
    if (value == null) return false;
    final text = value.toString();
    return text == '1' || text == 'true';
  }

  void _selecionarSelagem(
    String? value,
    List<Map<String, Object?>> selagens,
  ) {
    final selagem = selagens.firstWhere(
      (item) => item['id']?.toString() == value,
    );

    setState(() {
      _selagemSelecionadaId = value;
      _projetoSelecionadoId = selagem['projeto_id']?.toString();
      _codigoSeloController.text = selagem['codigo_selo']?.toString() ?? '';
      _codigoLotePreliminar = selagem['codigo_lote_preliminar']?.toString();
      _statusVinculoGeografico =
          selagem['status_vinculo_geografico']?.toString();
      _necessitaValidacaoRtk = _boolFromDb(selagem['necessita_validacao_rtk']);

      final nomeInformante = selagem['nome_informante']?.toString();
      final telefoneInformante = selagem['telefone_informante']?.toString();

      if (nomeInformante != null && nomeInformante.isNotEmpty) {
        _nomeResponsavelController.text = nomeInformante;
      }

      if (telefoneInformante != null && telefoneInformante.isNotEmpty) {
        _telefoneController.text = telefoneInformante;
      }
    });
  }

  Future<void> _salvarCadastroSocial() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selagemSelecionadaId == null || _projetoSelecionadoId == null) {
      await _mostrarAviso(
        titulo: 'Selagem obrigatória',
        mensagem: 'Selecione uma selagem antes de salvar o cadastro social.',
      );
      return;
    }

    LoadingDialog.show(
      context,
      title: _isEditing
          ? 'Atualizando cadastro social'
          : 'Salvando cadastro social',
      message: _isEditing
          ? 'Atualizando os dados do responsável familiar no banco local...'
          : 'Registrando os dados do responsável familiar no banco local...',
    );

    final cadastroSocialId = _editingCadastroId ?? const Uuid().v4();

    String? cpf;
    String? rg;
    String? orgaoEmissor;
    String? profissao;
    String? telefone;
    String? programaSocial;
    String? observacoes;

    try {
      final db = ref.read(appDatabaseProvider);

      cpf = _cpfController.text.trim().isEmpty
          ? null
          : _cpfController.text.trim();

      rg = _rgController.text.trim().isEmpty ? null : _rgController.text.trim();

      orgaoEmissor = _orgaoEmissorController.text.trim().isEmpty
          ? null
          : _orgaoEmissorController.text.trim();

      profissao = _profissaoController.text.trim().isEmpty
          ? null
          : _profissaoController.text.trim();

      telefone = _telefoneController.text.trim().isEmpty
          ? null
          : _telefoneController.text.trim();

      programaSocial = _programaSocialController.text.trim().isEmpty
          ? null
          : _programaSocialController.text.trim();

      observacoes = _observacoesController.text.trim().isEmpty
          ? null
          : _observacoesController.text.trim();

      if (_isEditing) {
        await db.atualizarCadastroSocial(
          id: cadastroSocialId,
          projetoId: _projetoSelecionadoId!,
          selagemId: _selagemSelecionadaId,
          codigoSelo: _codigoSeloController.text.trim(),
          nomeResponsavel: _nomeResponsavelController.text.trim(),
          cpfResponsavel: cpf,
          rgResponsavel: rg,
          orgaoEmissor: orgaoEmissor,
          estadoCivil: _estadoCivil,
          profissao: profissao,
          telefone: telefone,
          quantidadeMoradores:
              int.tryParse(_quantidadeMoradoresController.text.trim()),
          rendaFamiliar: double.tryParse(
            _rendaFamiliarController.text.replaceAll(',', '.'),
          ),
          recebeProgramaSocial: _recebeProgramaSocial,
          programaSocial: programaSocial,
          tempoOcupacaoAnos: int.tryParse(_tempoOcupacaoController.text.trim()),
          formaOcupacao: _formaOcupacao,
          documentoPosse: _documentoPosse,
          possuiOutroImovel: _possuiOutroImovel,
          possuiConflito: _possuiConflito,
          observacoes: observacoes,
        );
      } else {
        await db.inserirCadastroSocial(
          id: cadastroSocialId,
          projetoId: _projetoSelecionadoId!,
          selagemId: _selagemSelecionadaId,
          codigoSelo: _codigoSeloController.text.trim(),
          nomeResponsavel: _nomeResponsavelController.text.trim(),
          cpfResponsavel: cpf,
          rgResponsavel: rg,
          orgaoEmissor: orgaoEmissor,
          estadoCivil: _estadoCivil,
          profissao: profissao,
          telefone: telefone,
          quantidadeMoradores:
              int.tryParse(_quantidadeMoradoresController.text.trim()),
          rendaFamiliar: double.tryParse(
            _rendaFamiliarController.text.replaceAll(',', '.'),
          ),
          recebeProgramaSocial: _recebeProgramaSocial,
          programaSocial: programaSocial,
          tempoOcupacaoAnos: int.tryParse(_tempoOcupacaoController.text.trim()),
          formaOcupacao: _formaOcupacao,
          documentoPosse: _documentoPosse,
          possuiOutroImovel: _possuiOutroImovel,
          possuiConflito: _possuiConflito,
          observacoes: observacoes,
        );
      }

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(() {
        _carregarDados();
      });

      if (!mounted) return;

      setState(() {
        _limparFormulario();
        _carregarDados();
      });

      if (_isEditing) {
        await _mostrarAviso(
          titulo: 'Cadastro social atualizado',
          mensagem: 'O cadastro social foi atualizado com sucesso.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: _isEditing ? 'Erro ao atualizar' : 'Erro ao salvar',
        mensagem: 'Não foi possível salvar o cadastro social.\n\nDetalhes: $e',
      );
    }
  }

  void _limparFormulario() {
    _editingCadastroId = null;
    _selagemSelecionadaId = null;
    _projetoSelecionadoId = null;

    _codigoSeloController.clear();
    _nomeResponsavelController.clear();
    _cpfController.clear();
    _rgController.clear();
    _orgaoEmissorController.clear();
    _profissaoController.clear();
    _telefoneController.clear();
    _quantidadeMoradoresController.clear();
    _rendaFamiliarController.clear();
    _programaSocialController.clear();
    _tempoOcupacaoController.clear();
    _observacoesController.clear();

    _estadoCivil = 'solteiro';
    _formaOcupacao = 'posse';
    _documentoPosse = 'nenhum';

    _recebeProgramaSocial = false;
    _possuiOutroImovel = false;
    _possuiConflito = false;

    _codigoLotePreliminar = null;
    _statusVinculoGeografico = null;
    _necessitaValidacaoRtk = false;
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

  String _simNao(Object? value) {
    if (value == null) return 'Não';
    final text = value.toString();
    return text == '1' || text == 'true' ? 'Sim' : 'Não';
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  void _prepararEdicaoCadastroSocial(Map<String, Object?> cadastro) {
    setState(() {
      _editingCadastroId = cadastro['id']?.toString();

      _selagemSelecionadaId = cadastro['selagem_id']?.toString();
      _projetoSelecionadoId = cadastro['projeto_id']?.toString();

      _codigoSeloController.text = cadastro['codigo_selo']?.toString() ?? '';
      _nomeResponsavelController.text =
          cadastro['nome_responsavel']?.toString() ?? '';
      _cpfController.text = cadastro['cpf_responsavel']?.toString() ?? '';
      _rgController.text = cadastro['rg_responsavel']?.toString() ?? '';
      _orgaoEmissorController.text =
          cadastro['orgao_emissor']?.toString() ?? '';
      _profissaoController.text = cadastro['profissao']?.toString() ?? '';
      _telefoneController.text = cadastro['telefone']?.toString() ?? '';
      _quantidadeMoradoresController.text =
          cadastro['quantidade_moradores']?.toString() ?? '';
      _rendaFamiliarController.text =
          cadastro['renda_familiar']?.toString() ?? '';
      _programaSocialController.text =
          cadastro['programa_social']?.toString() ?? '';
      _tempoOcupacaoController.text =
          cadastro['tempo_ocupacao_anos']?.toString() ?? '';
      _observacoesController.text = cadastro['observacoes']?.toString() ?? '';

      _estadoCivil = _valorPermitido(
        cadastro['estado_civil']?.toString(),
        const {
          'solteiro',
          'casado',
          'uniao_estavel',
          'divorciado',
          'viuvo',
        },
        'solteiro',
      );

      _formaOcupacao = _valorPermitido(
        cadastro['forma_ocupacao']?.toString(),
        const {
          'posse',
          'propriedade',
          'imovel_matriculado',
          'imovel_titulado_nao_registrado',
          'compra_venda',
          'heranca',
          'aluguel',
          'cedido',
          'ocupacao',
        },
        'posse',
      );

      _documentoPosse = _valorPermitido(
        cadastro['documento_posse']?.toString(),
        const {
          'nenhum',
          'matricula',
          'escritura_publica',
          'titulo_definitivo',
          'titulo_nao_registrado',
          'contrato_compra_venda',
          'recibo_compra_venda',
          'cessao_direitos',
          'declaracao_posse',
          'formal_partilha',
          'termo_doacao',
          'iptu',
          'conta_energia',
          'conta_agua',
          'outro',
        },
        'nenhum',
      );

      _recebeProgramaSocial = _boolFromDb(cadastro['recebe_programa_social']);
      _possuiOutroImovel = _boolFromDb(cadastro['possui_outro_imovel']);
      _possuiConflito = _boolFromDb(cadastro['possui_conflito']);

      _codigoLotePreliminar = cadastro['codigo_lote_preliminar']?.toString();
      _statusVinculoGeografico =
          cadastro['status_vinculo_geografico']?.toString();
      _necessitaValidacaoRtk = _boolFromDb(cadastro['necessita_validacao_rtk']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cadastro social carregado para edição.'),
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

  void _cancelarEdicaoCadastroSocial() {
    setState(() {
      _limparFormulario();
    });
  }

  Future<void> _confirmarExclusaoCadastroSocial(
    Map<String, Object?> cadastro,
  ) async {
    final id = cadastro['id']?.toString();

    if (id == null || id.isEmpty) {
      await _mostrarAviso(
        titulo: 'Erro na exclusão',
        mensagem: 'Não foi possível identificar o cadastro social selecionado.',
      );
      return;
    }

    final codigo =
        cadastro['codigo_selo']?.toString() ?? 'este cadastro social';

    LoadingDialog.show(
      context,
      title: 'Verificando vínculos',
      message: 'Consultando documentos vinculados ao cadastro social...',
    );

    try {
      final db = ref.read(appDatabaseProvider);

      final resumo = await db.resumoVinculosCadastroSocial(
        cadastroSocialId: id,
        codigoSelo: codigo,
      );

      if (!mounted) return;

      LoadingDialog.hide(context);

      final totalDocumentos = resumo['documentos'] ?? 0;
      final possuiDocumentos = totalDocumentos > 0;

      final confirmar = await showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              possuiDocumentos
                  ? 'Excluir cadastro e documentos?'
                  : 'Confirmar exclusão',
            ),
            content: Text(
              possuiDocumentos
                  ? 'O cadastro social "$codigo" possui $totalDocumentos documento(s)/foto(s) vinculado(s).\n\n'
                      'Ao confirmar, o app excluirá o cadastro social, os registros de documentos e os arquivos locais associados.\n\n'
                      'A selagem e o cadastro físico serão mantidos.'
                  : 'Deseja realmente excluir o cadastro social "$codigo"?\n\n'
                      'Nenhum documento vinculado foi encontrado. A selagem e o cadastro físico serão mantidos.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.delete),
                label: Text(possuiDocumentos ? 'Excluir tudo' : 'Excluir'),
              ),
            ],
          );
        },
      );

      if (confirmar == true) {
        await _excluirCadastroSocialComDependencias(
          cadastroSocialId: id,
          codigoSelo: codigo,
        );
      }
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro ao verificar vínculos',
        mensagem:
            'Não foi possível verificar os vínculos do cadastro social.\n\nDetalhes: $e',
      );
    }
  }

  Future<void> _excluirCadastroSocialComDependencias({
    required String cadastroSocialId,
    required String codigoSelo,
  }) async {
    LoadingDialog.show(
      context,
      title: 'Excluindo cadastro social',
      message: 'Removendo cadastro social, documentos e arquivos locais...',
    );

    try {
      final db = ref.read(appDatabaseProvider);

      await db.excluirCadastroSocialComDependencias(
        cadastroSocialId: cadastroSocialId,
        codigoSelo: codigoSelo,
        apagarArquivos: true,
      );

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(() {
        if (_editingCadastroId == cadastroSocialId) {
          _limparFormulario();
        }

        _carregarDados();
      });

      await _mostrarAviso(
        titulo: 'Cadastro social excluído',
        mensagem:
            'O cadastro social e seus documentos vinculados foram excluídos com sucesso.',
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro ao excluir',
        mensagem: 'Não foi possível excluir o cadastro social.\n\nDetalhes: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Social'),
      ),
      body: FutureBuilder<List<Map<String, Object?>>>(
        future: _futureSelagens,
        builder: (context, selagensSnapshot) {
          if (selagensSnapshot.connectionState == ConnectionState.waiting) {
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
                      Text('Carregando selagens disponíveis...'),
                    ],
                  ),
                ),
              ),
            );
          }

          final selagens = selagensSnapshot.data ?? [];

          if (selagens.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Nenhuma selagem cadastrada. Realize a selagem antes do cadastro social.',
                  ),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                _isEditing ? 'Editar Cadastro Social' : 'Novo Cadastro Social',
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
                          initialValue: _selagemSelecionadaId,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Selagem / Imóvel',
                            prefixIcon: Icon(Icons.qr_code_2),
                          ),
                          items: selagens.map((selagem) {
                            return DropdownMenuItem<String>(
                              value: selagem['id']?.toString(),
                              child: Text(
                                '${selagem['codigo_selo']} - ${selagem['projeto_bairro']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) => _selecionarSelagem(
                            value,
                            selagens,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Selecione a selagem.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _codigoSeloController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Código da selagem',
                            prefixIcon: Icon(Icons.confirmation_number),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Vínculo geoespacial',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B5E20),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                    'Lote preliminar: ${_codigoLotePreliminar ?? 'sem lote'}'),
                                Text(
                                    'Status: ${_statusVinculoGeografico ?? 'não validado'}'),
                                Text(
                                    'Necessita RTK: ${_necessitaValidacaoRtk ? 'Sim' : 'Não'}'),
                              ],
                            ),
                          ),
                        ),
                        _sectionTitle('Responsável familiar'),
                        TextFormField(
                          controller: _nomeResponsavelController,
                          decoration: const InputDecoration(
                            labelText: 'Nome do responsável',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Informe o nome do responsável.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _cpfController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'CPF',
                            prefixIcon: Icon(Icons.badge),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _rgController,
                                decoration: const InputDecoration(
                                  labelText: 'RG',
                                  prefixIcon: Icon(Icons.credit_card),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _orgaoEmissorController,
                                decoration: const InputDecoration(
                                  labelText: 'Órgão emissor',
                                  prefixIcon: Icon(Icons.account_balance),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _dropdown(
                          label: 'Estado civil',
                          icon: Icons.favorite,
                          value: _estadoCivil,
                          items: const [
                            DropdownMenuItem(
                                value: 'solteiro', child: Text('Solteiro(a)')),
                            DropdownMenuItem(
                                value: 'casado', child: Text('Casado(a)')),
                            DropdownMenuItem(
                                value: 'uniao_estavel',
                                child: Text('União estável')),
                            DropdownMenuItem(
                                value: 'divorciado',
                                child: Text('Divorciado(a)')),
                            DropdownMenuItem(
                                value: 'viuvo', child: Text('Viúvo(a)')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _estadoCivil = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _profissaoController,
                          decoration: const InputDecoration(
                            labelText: 'Profissão / ocupação',
                            prefixIcon: Icon(Icons.work),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _telefoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Telefone',
                            prefixIcon: Icon(Icons.phone),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _sectionTitle('Composição familiar e renda'),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _quantidadeMoradoresController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Moradores',
                                  prefixIcon: Icon(Icons.groups),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _rendaFamiliarController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Renda familiar',
                                  prefixIcon: Icon(Icons.payments),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          value: _recebeProgramaSocial,
                          title: const Text('Recebe programa social?'),
                          subtitle: Text(_recebeProgramaSocial ? 'Sim' : 'Não'),
                          onChanged: (value) {
                            setState(() => _recebeProgramaSocial = value);
                          },
                        ),
                        if (_recebeProgramaSocial) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _programaSocialController,
                            decoration: const InputDecoration(
                              labelText: 'Qual programa social?',
                              prefixIcon: Icon(Icons.volunteer_activism),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        _sectionTitle('Ocupação e posse'),
                        TextFormField(
                          controller: _tempoOcupacaoController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Tempo de ocupação anos',
                            prefixIcon: Icon(Icons.schedule),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _dropdown(
                          label: 'Forma de ocupação',
                          icon: Icons.home,
                          value: _formaOcupacao,
                          items: const [
                            DropdownMenuItem(
                              value: 'posse',
                              child: Text('Posse'),
                            ),
                            DropdownMenuItem(
                              value: 'propriedade',
                              child: Text('Propriedade'),
                            ),
                            DropdownMenuItem(
                              value: 'imovel_matriculado',
                              child: Text('Imóvel matriculado'),
                            ),
                            DropdownMenuItem(
                              value: 'imovel_titulado_nao_registrado',
                              child:
                                  Text('Imóvel titulado, mas não registrado'),
                            ),
                            DropdownMenuItem(
                              value: 'compra_venda',
                              child: Text('Compra e venda'),
                            ),
                            DropdownMenuItem(
                              value: 'heranca',
                              child: Text('Herança'),
                            ),
                            DropdownMenuItem(
                              value: 'aluguel',
                              child: Text('Aluguel'),
                            ),
                            DropdownMenuItem(
                              value: 'cedido',
                              child: Text('Cedido'),
                            ),
                            DropdownMenuItem(
                              value: 'ocupacao',
                              child: Text('Ocupação'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _formaOcupacao = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        _dropdown(
                          label: 'Documento de imóvel',
                          icon: Icons.description,
                          value: _documentoPosse,
                          items: const [
                            DropdownMenuItem(
                              value: 'nenhum',
                              child: Text('Nenhum documento'),
                            ),
                            DropdownMenuItem(
                              value: 'matricula',
                              child: Text('Matrícula do imóvel'),
                            ),
                            DropdownMenuItem(
                              value: 'escritura_publica',
                              child: Text('Escritura pública'),
                            ),
                            DropdownMenuItem(
                              value: 'titulo_definitivo',
                              child: Text('Título definitivo'),
                            ),
                            DropdownMenuItem(
                              value: 'titulo_nao_registrado',
                              child: Text('Título não registrado'),
                            ),
                            DropdownMenuItem(
                              value: 'contrato_compra_venda',
                              child: Text('Contrato de compra e venda'),
                            ),
                            DropdownMenuItem(
                              value: 'recibo_compra_venda',
                              child: Text('Recibo de compra e venda'),
                            ),
                            DropdownMenuItem(
                              value: 'cessao_direitos',
                              child: Text('Cessão de direitos'),
                            ),
                            DropdownMenuItem(
                              value: 'declaracao_posse',
                              child: Text('Declaração de posse'),
                            ),
                            DropdownMenuItem(
                              value: 'formal_partilha',
                              child: Text('Formal de partilha/inventário'),
                            ),
                            DropdownMenuItem(
                              value: 'termo_doacao',
                              child: Text('Termo de doação'),
                            ),
                            DropdownMenuItem(
                              value: 'iptu',
                              child: Text('IPTU/cadastro municipal'),
                            ),
                            DropdownMenuItem(
                              value: 'conta_energia',
                              child: Text('Conta de energia'),
                            ),
                            DropdownMenuItem(
                              value: 'conta_agua',
                              child: Text('Conta de água'),
                            ),
                            DropdownMenuItem(
                              value: 'outro',
                              child: Text('Outro documento'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _documentoPosse = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          value: _possuiOutroImovel,
                          title: const Text('Possui outro imóvel?'),
                          subtitle: Text(_possuiOutroImovel ? 'Sim' : 'Não'),
                          onChanged: (value) {
                            setState(() => _possuiOutroImovel = value);
                          },
                        ),
                        SwitchListTile(
                          value: _possuiConflito,
                          title: const Text('Existe conflito sobre a posse?'),
                          subtitle: Text(_possuiConflito ? 'Sim' : 'Não'),
                          onChanged: (value) {
                            setState(() => _possuiConflito = value);
                          },
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
                          onPressed: _salvarCadastroSocial,
                          icon: Icon(_isEditing ? Icons.update : Icons.save),
                          label: Text(
                            _isEditing
                                ? 'ATUALIZAR CADASTRO SOCIAL'
                                : 'SALVAR CADASTRO SOCIAL',
                          ),
                        ),
                        if (_isEditing) ...[
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: _cancelarEdicaoCadastroSocial,
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
                'Cadastros sociais realizados',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Map<String, Object?>>>(
                future: _futureCadastros,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            LinearProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Carregando cadastros sociais...'),
                          ],
                        ),
                      ),
                    );
                  }

                  final cadastros = snapshot.data ?? [];

                  if (cadastros.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Nenhum cadastro social registrado.'),
                      ),
                    );
                  }

                  return Column(
                    children: cadastros.map((cadastro) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.people,
                            color: Color(0xFF1B5E20),
                          ),
                          title: Text(
                            cadastro['nome_responsavel']?.toString() ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${cadastro['codigo_selo'] ?? ''} • '
                            'Lote: ${cadastro['codigo_lote_preliminar'] ?? 'sem lote'}\n'
                            'CPF: ${cadastro['cpf_responsavel'] ?? 'não informado'} • '
                            'Moradores: ${cadastro['quantidade_moradores'] ?? '-'}\n'
                            'Programa social: ${_simNao(cadastro['recebe_programa_social'])} • '
                            'Conflito: ${_simNao(cadastro['possui_conflito'])}',
                          ),
                          isThreeLine: true,
                          trailing: Wrap(
                            spacing: 2,
                            children: [
                              IconButton(
                                tooltip: 'Editar cadastro social',
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () =>
                                    _prepararEdicaoCadastroSocial(cadastro),
                              ),
                              IconButton(
                                tooltip: 'Excluir cadastro social',
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _confirmarExclusaoCadastroSocial(cadastro),
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
