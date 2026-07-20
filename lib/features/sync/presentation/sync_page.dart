import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/widgets/loading_dialog.dart';
import '../../../data/local/database_provider.dart';
import '../../mobile/presentation/active_project_controller.dart';
import 'sync_center_controller.dart';

import 'package:archive/archive_io.dart';
import 'package:excel/excel.dart' hide Border;

class SyncPage extends ConsumerStatefulWidget {
  const SyncPage({super.key});

  @override
  ConsumerState<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends ConsumerState<SyncPage> {
  String? _ultimoArquivoExportado;

  CellValue _cell(Object? value) {
    if (value == null) return TextCellValue('');

    if (value is int) {
      return IntCellValue(value);
    }

    if (value is double) {
      return DoubleCellValue(value);
    }

    final asNumber = double.tryParse(value.toString());
    if (asNumber != null && value.toString().trim().isNotEmpty) {
      return DoubleCellValue(asNumber);
    }

    return TextCellValue(value.toString());
  }

  int _projetos = 0;
  int _selagens = 0;
  int _cadastrosFisicos = 0;
  int _cadastrosSociais = 0;
  int _documentos = 0;

  @override
  void initState() {
    super.initState();

    _carregarResumo();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await ref.read(syncCenterControllerProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _sincronizarAgora({bool silent = false}) async {
    final activeProject = ref.read(activeProjectControllerProvider);

    if (activeProject == null) {
      if (!silent) {
        await _mostrarAviso(
          titulo: 'Projeto obrigatório',
          mensagem: 'Selecione um projeto ativo antes de sincronizar os dados.',
        );
      }
      return;
    }

    if (!silent && mounted) {
      LoadingDialog.show(
        context,
        title: 'Sincronizando',
        message: 'Enviando registros pendentes ao painel web...',
      );
    }

    final result = await ref
        .read(syncCenterControllerProvider.notifier)
        .synchronizeNow(projectId: activeProject.id);

    await _carregarResumo();

    if (!mounted) return;

    if (!silent) {
      LoadingDialog.hide(context);

      if (result.attempted == 0) {
        await _mostrarAviso(
          titulo: 'Tudo sincronizado',
          mensagem: 'Não existem selagens pendentes para este projeto.',
        );
      } else if (result.allAccepted) {
        await _mostrarAviso(
          titulo: 'Sincronização concluída',
          mensagem:
              '${result.accepted} registro(s) confirmado(s) pelo servidor.',
        );
      } else if (result.offline) {
        await _mostrarAviso(
          titulo: 'Sem conexão',
          mensagem: 'Os registros continuam protegidos no aparelho e serão '
              'reenviados quando houver conexão.',
        );
      } else {
        await _mostrarAviso(
          titulo: 'Sincronização parcial',
          mensagem: 'Enviados: ${result.accepted}\n'
              'Falhas: ${result.rejected}\n'
              'Conflitos: ${result.conflicts}',
        );
      }
    }
  }

  Future<File> _gerarExcelCadastro({
    required Directory dir,
    required DateTime agora,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final pendencias = await db.listarPendenciasValidacao();

    final projetos = await db.listarProjetosParaExportacao();
    final selagens = await db.listarSelagensParaExportacao();
    final cadastrosFisicos = await db.listarCadastrosFisicosParaExportacao();
    final cadastrosSociais = await db.listarCadastrosSociaisParaExportacao();
    final documentos = await db.listarDocumentosParaExportacao();
    final consolidado = await db.listarConsolidadoGeralParaExportacao();

    final excel = Excel.createExcel();

    void criarAba({
      required String nome,
      required List<String> colunas,
      required List<Map<String, Object?>> linhas,
    }) {
      final sheet = excel[nome];

      for (var i = 0; i < colunas.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = TextCellValue(colunas[i]);
      }

      for (var rowIndex = 0; rowIndex < linhas.length; rowIndex++) {
        final linha = linhas[rowIndex];

        for (var colIndex = 0; colIndex < colunas.length; colIndex++) {
          final coluna = colunas[colIndex];

          sheet
              .cell(
                CellIndex.indexByColumnRow(
                  columnIndex: colIndex,
                  rowIndex: rowIndex + 1,
                ),
              )
              .value = _cell(linha[coluna]);
        }
      }
    }

    final resumo = [
      {
        'item': 'Projetos',
        'total': projetos.length,
      },
      {
        'item': 'Selagens',
        'total': selagens.length,
      },
      {
        'item': 'Cadastros físicos',
        'total': cadastrosFisicos.length,
      },
      {
        'item': 'Cadastros sociais',
        'total': cadastrosSociais.length,
      },
      {
        'item': 'Documentos e fotos',
        'total': documentos.length,
      },
      {
        'item': 'Exportado em',
        'total': agora.toIso8601String(),
      },
      {
        'item': 'Pendências',
        'total': pendencias.length,
      },
    ];

    criarAba(
      nome: 'Resumo',
      colunas: const ['item', 'total'],
      linhas: resumo,
    );

    if (projetos.isNotEmpty) {
      criarAba(
        nome: 'Projetos',
        colunas: projetos.first.keys.toList(),
        linhas: projetos,
      );
    }

    if (selagens.isNotEmpty) {
      criarAba(
        nome: 'Selagens',
        colunas: selagens.first.keys.toList(),
        linhas: selagens,
      );
    }

    if (cadastrosFisicos.isNotEmpty) {
      criarAba(
        nome: 'Cadastros Físicos',
        colunas: cadastrosFisicos.first.keys.toList(),
        linhas: cadastrosFisicos,
      );
    }

    if (cadastrosSociais.isNotEmpty) {
      criarAba(
        nome: 'Cadastros Sociais',
        colunas: cadastrosSociais.first.keys.toList(),
        linhas: cadastrosSociais,
      );
    }

    if (documentos.isNotEmpty) {
      criarAba(
        nome: 'Documentos',
        colunas: documentos.first.keys.toList(),
        linhas: documentos,
      );
    }

    final consolidadoColunas = [
      'codigo_lote_preliminar',
      'codigo_selo',
      'status_vinculo_geografico',
      'necessita_validacao_rtk',
      'observacao_geoespacial',
      'lote_preliminar_id',
      'projeto_nome',
      'municipio',
      'estado',
      'bairro',
      'situacao_selagem',
      'morador_presente',
      'moradia_ocupada',
      'situacao_atendimento',
      'tipo_unidade',
      'uso_imovel_selagem',
      'nome_informante',
      'telefone_informante',
      'relacao_informante',
      'revisita_necessaria',
      'latitude',
      'longitude',
      'precisao_gps',
      'tipo_imovel',
      'uso_imovel_fisico',
      'material_paredes',
      'tipo_cobertura',
      'tipo_piso',
      'numero_pavimentos',
      'numero_comodos',
      'numero_banheiros',
      'possui_energia',
      'possui_agua',
      'possui_esgoto',
      'possui_banheiro',
      'condicao_habitabilidade',
      'area_risco',
      'sujeito_inundacao',
      'nome_responsavel',
      'cpf_responsavel',
      'rg_responsavel',
      'orgao_emissor',
      'estado_civil',
      'profissao',
      'telefone',
      'quantidade_moradores',
      'renda_familiar',
      'recebe_programa_social',
      'programa_social',
      'tempo_ocupacao_anos',
      'forma_ocupacao',
      'documento_posse',
      'possui_outro_imovel',
      'possui_conflito',
      'total_documentos',
    ];

    if (pendencias.isNotEmpty) {
      criarAba(
        nome: 'Pendências',
        colunas: const [
          'categoria',
          'tipo',
          'criticidade',
          'codigo_lote',
          'codigo_selo',
          'responsavel',
          'projeto',
          'bairro',
          'descricao',
          'acao_recomendada',
        ],
        linhas: pendencias,
      );
    }

    criarAba(
      nome: 'Consolidado Geral',
      colunas: consolidadoColunas,
      linhas: consolidado,
    );

    final defaultSheet = excel.getDefaultSheet();

    if (defaultSheet != null && defaultSheet != 'Resumo') {
      excel.delete(defaultSheet);
    }

    final nomeArquivo =
        'BIOME_REURB_CADASTROS_${agora.year}${agora.month.toString().padLeft(2, '0')}${agora.day.toString().padLeft(2, '0')}_${agora.hour.toString().padLeft(2, '0')}${agora.minute.toString().padLeft(2, '0')}${agora.second.toString().padLeft(2, '0')}.xlsx';

    final file = File(p.join(dir.path, nomeArquivo));

    final bytes = excel.encode();

    if (bytes == null) {
      throw Exception('Não foi possível gerar o arquivo Excel.');
    }

    await file.writeAsBytes(bytes, flush: true);

    return file;
  }

  String _somenteDigitos(String? value) {
    if (value == null) return '';
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String _normalizarNomeArquivo(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');
  }

  String _pastaCpfDocumento(Map<String, Object?> doc) {
    final cpf = _somenteDigitos(
      doc['cpf_responsavel']?.toString(),
    );

    if (cpf.isNotEmpty) {
      return cpf;
    }

    final codigoSelo = doc['codigo_selo']?.toString() ?? 'SEM_SELO';

    return 'SEM_CPF_${_normalizarNomeArquivo(codigoSelo)}';
  }

  String _nomeDocumentoNoZip(Map<String, Object?> doc, String path) {
    final codigoSelo = _normalizarNomeArquivo(
      doc['codigo_selo']?.toString() ?? 'SEM_SELO',
    );

    final codigoLote = _normalizarNomeArquivo(
      doc['codigo_lote_preliminar']?.toString() ?? 'SEM_LOTE',
    );

    final tipoDocumento = _normalizarNomeArquivo(
      doc['tipo_documento']?.toString() ?? 'documento',
    );

    final id = _normalizarNomeArquivo(
      doc['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
    );

    final ext = p.extension(path).isEmpty ? '.jpg' : p.extension(path);

    return '${codigoLote}_${codigoSelo}_${tipoDocumento}_$id$ext';
  }

  Future<void> _exportarZipCompleto() async {
    LoadingDialog.show(
      context,
      title: 'Exportando pacote completo',
      message: 'Gerando Excel, JSON e pacote ZIP com documentos...',
    );

    try {
      final db = ref.read(appDatabaseProvider);
      final dir = await getApplicationDocumentsDirectory();
      final agora = DateTime.now();

      final projetos = await db.listarProjetosParaExportacao();
      final selagens = await db.listarSelagensParaExportacao();
      final cadastrosFisicos = await db.listarCadastrosFisicosParaExportacao();
      final cadastrosSociais = await db.listarCadastrosSociaisParaExportacao();
      final documentos = await db.listarDocumentosParaExportacao();

      final excelFile = await _gerarExcelCadastro(
        dir: dir,
        agora: agora,
      );

      final pacoteJson = {
        'app': 'BIOME REURB',
        'tipo_exportacao': 'pacote_completo_zip',
        'versao': '1.0.0',
        'exportado_em': agora.toIso8601String(),
        'resumo': {
          'projetos': projetos.length,
          'selagens': selagens.length,
          'cadastros_fisicos': cadastrosFisicos.length,
          'cadastros_sociais': cadastrosSociais.length,
          'documentos': documentos.length,
        },
        'dados': {
          'projetos': projetos,
          'selagens': selagens,
          'cadastros_fisicos': cadastrosFisicos,
          'cadastros_sociais': cadastrosSociais,
          'documentos': documentos,
        },
      };

      final archive = Archive();

      final excelBytes = await excelFile.readAsBytes();

      archive.addFile(
        ArchiveFile(
          p.basename(excelFile.path),
          excelBytes.length,
          excelBytes,
        ),
      );

      final jsonText = const JsonEncoder.withIndent('  ').convert(pacoteJson);
      final jsonBytes = utf8.encode(jsonText);

      archive.addFile(
        ArchiveFile(
          'dados.json',
          jsonBytes.length,
          jsonBytes,
        ),
      );
      for (final doc in documentos) {
        final path = doc['arquivo_path']?.toString();

        if (path == null || path.isEmpty) {
          continue;
        }

        final file = File(path);

        if (!await file.exists()) {
          continue;
        }

        final pastaCpf = _pastaCpfDocumento(doc);
        final nomeArquivo = _nomeDocumentoNoZip(doc, path);

        final nomeNoZip = 'arquivos/$pastaCpf/$nomeArquivo';

        final bytes = await file.readAsBytes();

        archive.addFile(
          ArchiveFile(
            nomeNoZip,
            bytes.length,
            bytes,
          ),
        );
      }
      final zipBytes = ZipEncoder().encode(archive);

      if (zipBytes == null) {
        throw Exception('Não foi possível gerar o arquivo ZIP.');
      }

      final nomeZip =
          'BIOME_REURB_EXPORT_${agora.year}${agora.month.toString().padLeft(2, '0')}${agora.day.toString().padLeft(2, '0')}_${agora.hour.toString().padLeft(2, '0')}${agora.minute.toString().padLeft(2, '0')}${agora.second.toString().padLeft(2, '0')}.zip';

      final zipFile = File(p.join(dir.path, nomeZip));

      await zipFile.writeAsBytes(zipBytes, flush: true);

// Depois que o ZIP foi gerado com sucesso, marca os registros como exportados.
      await db.marcarRegistrosComoExportados();

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(() {
        _ultimoArquivoExportado = zipFile.path;
      });

      await _carregarResumo();

      await _mostrarAviso(
        titulo: 'Pacote ZIP gerado',
        mensagem: 'O pacote completo foi gerado com sucesso.\n\n'
            'Inclui:\n'
            '- Planilha Excel consolidada\n'
            '- dados.json\n'
            '- fotos e documentos organizados por CPF\n\n'
            'Os registros locais foram marcados como exportados.\n\n'
            'Arquivo:\n${zipFile.path}',
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro na exportação',
        mensagem: 'Não foi possível gerar o pacote ZIP.\n\nDetalhes: $e',
      );
    }
  }

  Future<void> _carregarResumo() async {
    final db = ref.read(appDatabaseProvider);

    final projetos = await db.listarProjetosParaExportacao();
    final selagens = await db.listarSelagensParaExportacao();
    final cadastrosFisicos = await db.listarCadastrosFisicosParaExportacao();
    final cadastrosSociais = await db.listarCadastrosSociaisParaExportacao();
    final documentos = await db.listarDocumentosParaExportacao();

    if (!mounted) return;

    setState(() {
      _projetos = projetos.length;
      _selagens = selagens.length;
      _cadastrosFisicos = cadastrosFisicos.length;
      _cadastrosSociais = cadastrosSociais.length;
      _documentos = documentos.length;
    });
  }

  Future<void> _exportarJson() async {
    LoadingDialog.show(
      context,
      title: 'Exportando dados',
      message: 'Gerando pacote JSON com os dados coletados em campo...',
    );

    try {
      final db = ref.read(appDatabaseProvider);

      final projetos = await db.listarProjetosParaExportacao();
      final selagens = await db.listarSelagensParaExportacao();
      final cadastrosFisicos = await db.listarCadastrosFisicosParaExportacao();
      final cadastrosSociais = await db.listarCadastrosSociaisParaExportacao();
      final documentos = await db.listarDocumentosParaExportacao();

      final agora = DateTime.now();

      final pacote = {
        'app': 'BIOME REURB',
        'tipo_exportacao': 'coleta_campo_json',
        'versao': '1.0.0',
        'exportado_em': agora.toIso8601String(),
        'resumo': {
          'projetos': projetos.length,
          'selagens': selagens.length,
          'cadastros_fisicos': cadastrosFisicos.length,
          'cadastros_sociais': cadastrosSociais.length,
          'documentos': documentos.length,
        },
        'dados': {
          'projetos': projetos,
          'selagens': selagens,
          'cadastros_fisicos': cadastrosFisicos,
          'cadastros_sociais': cadastrosSociais,
          'documentos': documentos,
        },
      };

      final dir = await getApplicationDocumentsDirectory();

      final nomeArquivo =
          'biome_reurb_export_${agora.year}${agora.month.toString().padLeft(2, '0')}${agora.day.toString().padLeft(2, '0')}_${agora.hour.toString().padLeft(2, '0')}${agora.minute.toString().padLeft(2, '0')}${agora.second.toString().padLeft(2, '0')}.json';

      final file = File(p.join(dir.path, nomeArquivo));

      const encoder = JsonEncoder.withIndent('  ');
      await file.writeAsString(
        encoder.convert(pacote),
        flush: true,
      );

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(() {
        _ultimoArquivoExportado = file.path;
      });

      await _carregarResumo();

      await _mostrarAviso(
        titulo: 'Exportação concluída',
        mensagem:
            'O pacote JSON foi gerado com sucesso.\n\nArquivo:\n${file.path}',
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro na exportação',
        mensagem: 'Não foi possível exportar os dados.\n\nDetalhes: $e',
      );
    }
  }

  Future<void> _compartilharArquivo() async {
    final path = _ultimoArquivoExportado;

    if (path == null || path.isEmpty) {
      await _mostrarAviso(
        titulo: 'Nenhum arquivo exportado',
        mensagem: 'Gere uma exportação antes de compartilhar o arquivo.',
      );
      return;
    }

    final file = File(path);

    if (!await file.exists()) {
      await _mostrarAviso(
        titulo: 'Arquivo não encontrado',
        mensagem: 'O arquivo exportado não foi encontrado no dispositivo.',
      );
      return;
    }

    if (!mounted) return;

    LoadingDialog.show(
      context,
      title: 'Preparando compartilhamento',
      message: 'Abrindo opções para envio do arquivo exportado...',
    );

    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      LoadingDialog.hide(context);

      await SharePlus.instance.share(
        ShareParams(
          text: 'Exportação BIOME REURB',
          files: [
            XFile(path),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro ao compartilhar',
        mensagem: 'Não foi possível compartilhar o arquivo.\n\nDetalhes: $e',
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

  String _formatDateTime(DateTime? value) {
    if (value == null) return 'Ainda não executada';

    final local = value.toLocal();

    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year} às '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  Widget _statusCard({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFDDE7E0)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: Color(0xFF10251A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF68756D),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(syncCenterControllerProvider);
    final activeProject = ref.watch(activeProjectControllerProvider);
    final totalRegistros = _projetos +
        _selagens +
        _cadastrosFisicos +
        _cadastrosSociais +
        _documentos;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF7),
      appBar: AppBar(
        title: const Text('Central de Sincronização'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: state.syncing
                ? null
                : () async {
                    await ref
                        .read(syncCenterControllerProvider.notifier)
                        .refresh();
                    await _carregarResumo();
                  },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(syncCenterControllerProvider.notifier).refresh();
          await _carregarResumo();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF063D1C), Color(0xFF0B6B31)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.cloud_sync_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Sincronização online',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    activeProject == null
                        ? 'Nenhum projeto ativo selecionado.'
                        : 'Projeto: ${activeProject.name}',
                    style: const TextStyle(
                      color: Color(0xFFDDF5E4),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Última tentativa: ${_formatDateTime(state.lastSyncAt)}',
                    style: const TextStyle(
                      color: Color(0xFFBFE8CA),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed:
                          state.syncing ? null : () => _sincronizarAgora(),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0B5D2A),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      icon: state.syncing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : const Icon(Icons.sync_rounded),
                      label: Text(
                        state.syncing
                            ? 'SINCRONIZANDO...'
                            : 'SINCRONIZAR AGORA',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _statusCard(
                  icon: Icons.schedule_rounded,
                  label: 'Pendentes',
                  value: state.pending,
                  color: const Color(0xFFD97706),
                ),
                const SizedBox(width: 9),
                _statusCard(
                  icon: Icons.cloud_done_rounded,
                  label: 'Enviados',
                  value: state.synced,
                  color: const Color(0xFF0B5D2A),
                ),
                const SizedBox(width: 9),
                _statusCard(
                  icon: Icons.error_outline_rounded,
                  label: 'Falhas',
                  value: state.failed + state.conflicts,
                  color: const Color(0xFFB42318),
                ),
              ],
            ),
            if (state.message != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  state.message!,
                  style: const TextStyle(
                    color: Color(0xFF8A1C13),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Falhas e conflitos',
              style: TextStyle(
                color: Color(0xFF10251A),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            if (state.failures.isEmpty)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFDDE7E0)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF0B5D2A),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Nenhuma falha ou conflito registrado.',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF355345),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              for (final failure in state.failures)
                Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(
                      failure['sync_status'] == 'conflict'
                          ? Icons.warning_amber_rounded
                          : Icons.error_outline_rounded,
                      color: const Color(0xFFB42318),
                    ),
                    title: Text(
                      failure['codigo_selo']?.toString() ??
                          'Selagem sem código',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      failure['sync_error']?.toString() ??
                          'Falha sem detalhamento.',
                    ),
                    trailing: Text(
                      '${failure['sync_attempts'] ?? 0}x',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
            const SizedBox(height: 24),
            ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text(
                'Exportação de contingência',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: const Text(
                'Backup manual em JSON ou ZIP para situações excepcionais.',
              ),
              children: [
                const SizedBox(height: 8),
                Text('Registros locais disponíveis: $totalRegistros'),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _exportarJson,
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('EXPORTAR JSON'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _exportarZipCompleto,
                    icon: const Icon(Icons.archive_rounded),
                    label: const Text('EXPORTAR ZIP DE CONTINGÊNCIA'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _compartilharArquivo,
                    icon: const Icon(Icons.share_rounded),
                    label: const Text('COMPARTILHAR EXPORTAÇÃO'),
                  ),
                ),
                if (_ultimoArquivoExportado != null) ...[
                  const SizedBox(height: 12),
                  SelectableText(
                    'Último arquivo:\n$_ultimoArquivoExportado',
                  ),
                ],
                const SizedBox(height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
