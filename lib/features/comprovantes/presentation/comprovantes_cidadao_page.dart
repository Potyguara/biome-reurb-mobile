import 'package:biome_reurb/features/mobile/presentation/device_identity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../core/widgets/loading_dialog.dart';
import '../../../data/local/database_provider.dart';
import '../../cadastro_social/services/reurb_receipt_pdf_service.dart';

class ComprovantesCidadaoPage extends ConsumerStatefulWidget {
  const ComprovantesCidadaoPage({super.key});

  @override
  ConsumerState<ComprovantesCidadaoPage> createState() =>
      _ComprovantesCidadaoPageState();
}

class _ComprovantesCidadaoPageState
    extends ConsumerState<ComprovantesCidadaoPage> {
  late Future<List<Map<String, Object?>>> _futureCadastros;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    final db = ref.read(appDatabaseProvider);
    _futureCadastros = db.listarCadastrosCompletosParaComprovante();
  }

  String _consultaPublicaUrl(String codigoSelo) {
    final encodedSeal = Uri.encodeComponent(codigoSelo);

    return 'https://seudominio.com/consulta-reurb?selagem=$encodedSeal';
  }

  bool _boolFromDb(Object? value) {
    if (value == null) return false;

    final text = value.toString();

    return text == '1' || text == 'true';
  }

  String _simNao(Object? value) {
    return _boolFromDb(value) ? 'Sim' : 'Não';
  }

  String _text(Object? value) {
    if (value == null) return '-';

    final text = value.toString().trim();

    return text.isEmpty ? '-' : text;
  }

  List<String> _documentosFromRaw(Object? value) {
    if (value == null) return [];

    final raw = value.toString().trim();

    if (raw.isEmpty) return [];

    const recordSeparator = '\u001e';
    const fieldSeparator = '\u001f';

    final documentos = raw
        .split(recordSeparator)
        .map((item) {
          final parts = item.split(fieldSeparator);

          final tipoDocumento = parts.isNotEmpty ? parts[0].trim() : '';
          final observacao = parts.length >= 2 ? parts[1].trim() : '';
          final arquivoPath = parts.length >= 3 ? parts[2].trim() : '';

          if (observacao.isNotEmpty) {
            return observacao;
          }

          final label = _documentTypeLabel(tipoDocumento);

          if (label.isNotEmpty) {
            return label;
          }

          if (arquivoPath.isNotEmpty) {
            return p.basename(arquivoPath);
          }

          return '';
        })
        .where((item) {
          final text = item.trim();

          if (text.isEmpty) return false;

          // Segurança extra: não deixa caminho interno do iOS aparecer no PDF.
          if (text.startsWith('/private/')) return false;
          if (text.startsWith('/var/mobile/')) return false;
          if (text.contains('/Containers/Data/Application/')) return false;

          return true;
        })
        .toSet()
        .toList();

    return documentos;
  }

  String _documentTypeLabel(String value) {
    final normalized = value.trim().toLowerCase();

    const labels = {
      'foto_fachada': 'Foto da fachada',
      'fachada': 'Foto da fachada',
      'foto_imovel': 'Foto do imóvel',
      'imagem_campo': 'Imagem de campo',
      'rg_frente': 'RG frente',
      'rg_verso': 'RG verso',
      'rg': 'RG',
      'cpf': 'CPF',
      'cnh': 'CNH',
      'comprovante_residencia': 'Comprovante de residência',
      'comprovante_de_residencia': 'Comprovante de residência',
      'certidao_nascimento': 'Certidão de nascimento',
      'certidao_casamento': 'Certidão de casamento',
      'documento_imovel': 'Documento do imóvel',
      'documento_posse': 'Documento do imóvel',
      'matricula': 'Matrícula do imóvel',
      'escritura_publica': 'Escritura pública',
      'titulo_definitivo': 'Título definitivo',
      'titulo_nao_registrado': 'Título não registrado',
      'contrato_compra_venda': 'Contrato de compra e venda',
      'recibo_compra_venda': 'Recibo de compra e venda',
      'cessao_direitos': 'Cessão de direitos',
      'declaracao_posse': 'Declaração de posse',
      'formal_partilha': 'Formal de partilha/inventário',
      'termo_doacao': 'Termo de doação',
      'iptu': 'IPTU/cadastro municipal',
      'conta_energia': 'Conta de energia',
      'conta_agua': 'Conta de água',
      'termo_declaracao': 'Termo/declaração',
      'outro': 'Outro documento',
    };

    if (labels.containsKey(normalized)) {
      return labels[normalized]!;
    }

    if (normalized.isEmpty) {
      return '';
    }

    return normalized
        .replaceAll('_', ' ')
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .map((part) {
      final lower = part.toLowerCase();
      return lower[0].toUpperCase() + lower.substring(1);
    }).join(' ');
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

  Future<void> _gerarEnviarComprovante(Map<String, Object?> cadastro) async {
    final cadastroCompleto = _boolFromDb(cadastro['cadastro_completo']);

    if (!cadastroCompleto) {
      await _mostrarAviso(
        titulo: 'Cadastro incompleto',
        mensagem:
            'Este atendimento ainda não possui cadastro físico vinculado. Complete o cadastro físico antes de enviar o comprovante ao cidadão.',
      );
      return;
    }

    final codigoSelo = _text(cadastro['codigo_selo']);

    final projetoId = cadastro['projeto_id']?.toString().trim();

    if (projetoId == null || projetoId.isEmpty) {
      await _mostrarAviso(
        titulo: 'Projeto não identificado',
        mensagem:
            'Não foi possível identificar o projeto vinculado a este cadastro.',
      );
      return;
    }

    LoadingDialog.show(
      context,
      title: 'Gerando comprovante',
      message:
          'Criando PDF com dados sociais, físicos, lote e documentos anexados...',
    );

    try {
      final db = ref.read(appDatabaseProvider);

      final documentos = _documentosFromRaw(cadastro['documentos_lista']);
      final sourceDeviceId = await ref.read(deviceIdentityProvider.future);

      final pdfFile = await ReurbReceiptPdfService().generateCompleteReceiptPdf(
        projetoNome: _text(cadastro['projeto_nome']),
        municipio: _text(cadastro['projeto_municipio']),
        estado: _text(cadastro['projeto_estado']),
        bairro: _text(cadastro['projeto_bairro']),
        codigoSelo: codigoSelo,
        codigoLote: cadastro['codigo_lote_preliminar']?.toString(),
        situacaoSelagem: cadastro['situacao_selagem']?.toString(),
        latitude: cadastro['latitude']?.toString(),
        longitude: cadastro['longitude']?.toString(),
        precisaoGps: cadastro['precisao_gps']?.toString(),
        nomeResponsavel: _text(cadastro['nome_responsavel']),
        cpfResponsavel: cadastro['cpf_responsavel']?.toString(),
        rgResponsavel: cadastro['rg_responsavel']?.toString(),
        telefone: cadastro['telefone']?.toString(),
        estadoCivil: cadastro['estado_civil']?.toString(),
        profissao: cadastro['profissao']?.toString(),
        formaOcupacao: cadastro['forma_ocupacao']?.toString(),
        documentoImovel: cadastro['documento_posse']?.toString(),
        tempoOcupacao: cadastro['tempo_ocupacao_anos']?.toString(),
        tipoImovel: cadastro['tipo_imovel']?.toString(),
        usoImovel: cadastro['uso_imovel']?.toString(),
        materialParedes: cadastro['material_paredes']?.toString(),
        tipoCobertura: cadastro['tipo_cobertura']?.toString(),
        tipoPiso: cadastro['tipo_piso']?.toString(),
        numeroComodos: cadastro['numero_comodos']?.toString(),
        numeroBanheiros: cadastro['numero_banheiros']?.toString(),
        possuiEnergia: _simNao(cadastro['possui_energia']),
        possuiAgua: _simNao(cadastro['possui_agua']),
        possuiEsgoto: _simNao(cadastro['possui_esgoto']),
        possuiBanheiro: _simNao(cadastro['possui_banheiro']),
        condicaoHabitabilidade: cadastro['condicao_habitabilidade']?.toString(),
        areaRisco: _simNao(cadastro['area_risco']),
        sujeitoInundacao: _simNao(cadastro['sujeito_inundacao']),
        documentos: documentos,
        dataEmissao: DateTime.now(),
        consultaUrl: _consultaPublicaUrl(codigoSelo),
      );

      await db.inserirDocumentoReurb(
        id: const Uuid().v4(),
        projetoId: projetoId,
        sourceDeviceId: sourceDeviceId,
        selagemId: cadastro['selagem_id']?.toString(),
        cadastroSocialId: cadastro['cadastro_social_id']?.toString(),
        codigoSelo: codigoSelo,
        tipoDocumento: 'comprovante_selagem',
        arquivoPath: pdfFile.path,
        observacoes:
            'Comprovante REURB enviado/gerado para o cidadão a partir da tela de comprovantes.',
      );

      if (!mounted) return;

      LoadingDialog.hide(context);

      await SharePlus.instance.share(
        ShareParams(
          text:
              'Comprovante de Atendimento REURB\nCódigo da selagem: $codigoSelo',
          files: [
            XFile(pdfFile.path),
          ],
        ),
      );

      setState(() {
        _carregarDados();
      });
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro ao gerar comprovante',
        mensagem:
            'Não foi possível gerar/enviar o comprovante.\n\nDetalhes: $e',
      );
    }
  }

  Widget _statusChip(bool completo) {
    return Chip(
      label: Text(
        completo ? 'Completo' : 'Incompleto',
        style: TextStyle(
          color: completo ? Colors.green.shade900 : Colors.red.shade900,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: completo ? Colors.green.shade50 : Colors.red.shade50,
      side: BorderSide(
        color: completo ? Colors.green.shade200 : Colors.red.shade200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envio ao Cidadão'),
      ),
      body: FutureBuilder<List<Map<String, Object?>>>(
        future: _futureCadastros,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
                      Text('Carregando cadastros completos...'),
                    ],
                  ),
                ),
              ),
            );
          }

          final cadastros = snapshot.data ?? [];

          if (cadastros.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Nenhum cadastro social encontrado para emissão de comprovante.',
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _carregarDados();
              });
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Cadastros para envio',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gere e compartilhe o comprovante somente após conferir selagem, cadastro social, cadastro físico e documentos anexados.',
                ),
                const SizedBox(height: 16),
                ...cadastros.map((cadastro) {
                  final completo = _boolFromDb(cadastro['cadastro_completo']);
                  final totalDocs =
                      int.tryParse(_text(cadastro['total_documentos'])) ?? 0;

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        completo ? Icons.verified : Icons.warning_amber,
                        color: completo ? Colors.green : Colors.orange,
                      ),
                      title: Text(
                        _text(cadastro['nome_responsavel']),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${_text(cadastro['codigo_selo'])} • '
                        'Lote: ${_text(cadastro['codigo_lote_preliminar'])}\n'
                        'CPF: ${_text(cadastro['cpf_responsavel'])} • '
                        'Telefone: ${_text(cadastro['telefone'])}\n'
                        'Físico: ${cadastro['cadastro_fisico_id'] == null ? 'não' : 'sim'} • '
                        'Documentos anexados: $totalDocs',
                      ),
                      isThreeLine: true,
                      trailing: Wrap(
                        spacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _statusChip(completo),
                          IconButton(
                            tooltip: completo
                                ? 'Enviar comprovante ao cidadão'
                                : 'Cadastro incompleto',
                            icon: Icon(
                              Icons.send,
                              color: completo
                                  ? Colors.green.shade800
                                  : Colors.grey,
                            ),
                            onPressed: completo
                                ? () => _gerarEnviarComprovante(cadastro)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
