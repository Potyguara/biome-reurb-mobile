// ignore_for_file: unused_element, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import '../../../core/widgets/loading_dialog.dart';
import '../../../data/local/database_provider.dart';
import '../../lotes_mapa/models/lote_mapa_result.dart';
import '../../lotes_mapa/presentation/lote_map_selector_page.dart';
import '../../mobile/presentation/active_project_controller.dart';
import '../../mobile/presentation/device_identity_provider.dart';
import '../data/seal_code_reservation_repository.dart';
import 'seal_sync_controller.dart';

class SelagemPage extends ConsumerStatefulWidget {
  const SelagemPage({super.key});

  @override
  ConsumerState<SelagemPage> createState() => _SelagemPageState();
}

class _SelagemPageState extends ConsumerState<SelagemPage> {
  final _formKey = GlobalKey<FormState>();

  final _codigoController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _observacoesController = TextEditingController();

  final _nomeInformanteController = TextEditingController();
  final _telefoneInformanteController = TextEditingController();
  final _precisaoGpsController = TextEditingController();

  bool _moradorPresente = true;
  bool _moradiaOcupada = true;
  bool _revisitaNecessaria = false;

  String _situacaoAtendimento = 'atendido';
  String _tipoUnidade = 'casa';
  String _usoImovel = 'residencial';
  String _relacaoInformante = 'responsavel';

  String? _projetoSelecionadoId;
  String _situacao = 'ocupado';

  late Future<List<Map<String, Object?>>> _futureProjetos;
  late Future<List<Map<String, Object?>>> _futureSelagens;

  String? _lotePreliminarSelecionadoId;
  String? _codigoLotePreliminarSelecionado;

  String _statusVinculoGeografico = 'confirmado';
  bool _necessitaValidacaoRtk = false;

  final _observacaoGeoespacialController = TextEditingController();

  late Future<List<Map<String, Object?>>> _futureLotesPreliminares;

  String? _editingSelagemId;

  bool get _isEditing => _editingSelagemId != null;

  @override
  void initState() {
    super.initState();

    // Inicializa os Futures antes do primeiro build.
    _carregarDados();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final activeProject = ref.read(activeProjectControllerProvider);

      if (activeProject == null) return;

      final db = ref.read(appDatabaseProvider);

      await db.upsertProjetoAutorizado(
        id: activeProject.id,
        nome: activeProject.name,
        municipio: activeProject.municipality,
        estado: activeProject.state,
        bairro: activeProject.neighborhood,
        modalidadeReurb: activeProject.reurbType,
        status: activeProject.status,
      );

      if (!mounted) return;

      setState(() {
        _projetoSelecionadoId = activeProject.id;
        _carregarDados();
      });
    });
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _observacoesController.dispose();
    _nomeInformanteController.dispose();
    _telefoneInformanteController.dispose();
    _precisaoGpsController.dispose();
    _observacaoGeoespacialController.dispose();
    super.dispose();
  }

  Future<void> _confirmarExclusaoSelagem(Map<String, Object?> selagem) async {
    final id = selagem['id']?.toString();

    if (id == null || id.isEmpty) {
      await _mostrarAviso(
        titulo: 'Erro na exclusão',
        mensagem: 'Não foi possível identificar a selagem selecionada.',
      );
      return;
    }

    final codigo = selagem['codigo_selo']?.toString() ?? 'esta selagem';

    LoadingDialog.show(
      context,
      title: 'Verificando vínculos',
      message: 'Consultando cadastros e documentos vinculados à selagem...',
    );

    try {
      final db = ref.read(appDatabaseProvider);

      final resumo = await db.resumoVinculosSelagem(
        selagemId: id,
        codigoSelo: codigo,
      );

      if (!mounted) return;

      LoadingDialog.hide(context);

      final totalFisicos = resumo['cadastros_fisicos'] ?? 0;
      final totalSociais = resumo['cadastros_sociais'] ?? 0;
      final totalDocumentos = resumo['documentos'] ?? 0;

      final possuiDependencias =
          totalFisicos > 0 || totalSociais > 0 || totalDocumentos > 0;

      final confirmar = await showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              possuiDependencias
                  ? 'Excluir selagem e vínculos?'
                  : 'Confirmar exclusão',
            ),
            content: Text(
              possuiDependencias
                  ? 'A selagem "$codigo" possui registros vinculados:\n\n'
                      '- Cadastros físicos: $totalFisicos\n'
                      '- Cadastros sociais: $totalSociais\n'
                      '- Documentos/fotos: $totalDocumentos\n\n'
                      'Ao confirmar, o app excluirá a selagem, os cadastros vinculados, os registros de documentos e os arquivos locais das fotos/documentos.\n\n'
                      'Essa ação deve ser usada apenas para corrigir erro antes da exportação/sincronização.'
                  : 'Deseja realmente excluir a selagem "$codigo"?\n\n'
                      'Nenhum cadastro ou documento vinculado foi encontrado.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.delete),
                label: Text(
                  possuiDependencias ? 'Excluir tudo' : 'Excluir',
                ),
              ),
            ],
          );
        },
      );

      if (confirmar == true) {
        await _excluirSelagemComDependencias(
          selagemId: id,
          codigoSelo: codigo,
        );
      }
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro ao verificar vínculos',
        mensagem:
            'Não foi possível verificar os vínculos da selagem.\n\nDetalhes: $e',
      );
    }
  }

  Future<void> _excluirSelagemComDependencias({
    required String selagemId,
    required String codigoSelo,
  }) async {
    LoadingDialog.show(
      context,
      title: 'Excluindo selagem',
      message: 'Removendo a selagem, vínculos e arquivos locais...',
    );

    try {
      final db = ref.read(appDatabaseProvider);

      await db.excluirSelagemComDependencias(
        selagemId: selagemId,
        codigoSelo: codigoSelo,
        apagarArquivos: true,
      );

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(() {
        if (_editingSelagemId == selagemId) {
          _cancelarEdicaoSelagem();
        }

        _carregarDados();
      });

      await _mostrarAviso(
        titulo: 'Selagem excluída',
        mensagem:
            'A selagem e todos os registros vinculados foram excluídos com sucesso.\n\n'
            'Também foram removidos os arquivos locais de documentos/fotos vinculados, quando existentes.',
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro ao excluir',
        mensagem:
            'Não foi possível excluir a selagem e seus vínculos.\n\nDetalhes: $e',
      );
    }
  }

  void _prepararEdicaoSelagem(Map<String, Object?> selagem) {
    setState(() {
      _editingSelagemId = selagem['id']?.toString();

      _projetoSelecionadoId = selagem['projeto_id']?.toString();
      _lotePreliminarSelecionadoId = selagem['lote_preliminar_id']?.toString();
      _codigoLotePreliminarSelecionado =
          selagem['codigo_lote_preliminar']?.toString();

      _codigoController.text = selagem['codigo_selo']?.toString() ?? '';

      _situacao = selagem['situacao']?.toString() ?? 'ocupado';

      _moradorPresente = _boolFromDb(selagem['morador_presente']);
      _moradiaOcupada = _boolFromDb(selagem['moradia_ocupada']);

      _situacaoAtendimento =
          selagem['situacao_atendimento']?.toString() ?? 'atendido';
      _tipoUnidade = selagem['tipo_unidade']?.toString() ?? 'casa';
      _usoImovel = selagem['uso_imovel']?.toString() ?? 'residencial';

      _nomeInformanteController.text =
          selagem['nome_informante']?.toString() ?? '';
      _telefoneInformanteController.text =
          selagem['telefone_informante']?.toString() ?? '';

      _relacaoInformante =
          selagem['relacao_informante']?.toString() ?? 'responsavel';

      _revisitaNecessaria = _boolFromDb(selagem['revisita_necessaria']);

      _latitudeController.text = selagem['latitude']?.toString() ?? '';
      _longitudeController.text = selagem['longitude']?.toString() ?? '';
      _precisaoGpsController.text = selagem['precisao_gps']?.toString() ?? '';

      _statusVinculoGeografico =
          selagem['status_vinculo_geografico']?.toString() ?? 'nao_validado';

      _necessitaValidacaoRtk = _boolFromDb(selagem['necessita_validacao_rtk']);

      _observacaoGeoespacialController.text =
          selagem['observacao_geoespacial']?.toString() ?? '';

      _observacoesController.text = selagem['observacoes']?.toString() ?? '';

      final db = ref.read(appDatabaseProvider);

      if (_projetoSelecionadoId != null) {
        _futureLotesPreliminares =
            db.listarLotesPreliminaresPorProjeto(_projetoSelecionadoId!);
      } else {
        _futureLotesPreliminares = Future.value([]);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selagem carregada para edição.'),
      ),
    );
  }

  bool _boolFromDb(Object? value) {
    if (value == null) return false;

    final text = value.toString();

    return text == '1' || text == 'true';
  }

  void _cancelarEdicaoSelagem() {
    setState(() {
      _editingSelagemId = null;

      _codigoController.clear();
      _latitudeController.clear();
      _longitudeController.clear();
      _precisaoGpsController.clear();
      _observacoesController.clear();
      _nomeInformanteController.clear();
      _telefoneInformanteController.clear();
      _observacaoGeoespacialController.clear();

      _lotePreliminarSelecionadoId = null;
      _codigoLotePreliminarSelecionado = null;

      _situacao = 'ocupado';
      _moradorPresente = true;
      _moradiaOcupada = true;
      _revisitaNecessaria = false;

      _situacaoAtendimento = 'atendido';
      _tipoUnidade = 'casa';
      _usoImovel = 'residencial';
      _relacaoInformante = 'responsavel';

      _statusVinculoGeografico = 'confirmado';
      _necessitaValidacaoRtk = false;
    });
  }

  Future<void> _selecionarLoteNoMapa() async {
    if (_projetoSelecionadoId == null) {
      await _mostrarAviso(
        titulo: 'Projeto obrigatório',
        mensagem:
            'Selecione um projeto REURB antes de selecionar o lote no mapa.',
      );
      return;
    }

    final result = await Navigator.of(context).push<LoteMapaResult>(
      MaterialPageRoute(
        builder: (_) {
          return LoteMapSelectorPage(
            projetoId: _projetoSelecionadoId!,
          );
        },
      ),
    );

    if (result == null) return;

    setState(() {
      _lotePreliminarSelecionadoId = result.lotePreliminarId;
      _codigoLotePreliminarSelecionado = result.codigoLotePreliminar;
      _statusVinculoGeografico = result.statusVinculoGeografico;
      _necessitaValidacaoRtk = result.necessitaValidacaoRtk;

      _observacaoGeoespacialController.text =
          result.observacaoGeoespacial ?? '';
    });
  }

  void _carregarDados() {
    final db = ref.read(appDatabaseProvider);
    _futureProjetos = db.listarProjetosReurb();
    _futureSelagens = db.listarSelagensReurb();

    if (_projetoSelecionadoId != null) {
      _futureLotesPreliminares =
          db.listarLotesPreliminaresPorProjeto(_projetoSelecionadoId!);
    } else {
      _futureLotesPreliminares = Future.value([]);
    }
  }

  Future<void> _gerarCodigoSelagem(
    List<Map<String, Object?>> projetos,
  ) async {
    if (_projetoSelecionadoId == null) {
      await _mostrarAviso(
        titulo: 'Projeto obrigatório',
        mensagem:
            'Selecione um projeto REURB antes de gerar o código da selagem.',
      );
      return;
    }

    LoadingDialog.show(
      context,
      title: 'Reservando código',
      message: 'Obtendo um código oficial de selagem...',
    );

    try {
      final repository = ref.read(sealCodeReservationRepositoryProvider);

      final codigo = await repository.nextCode(
        projectId: _projetoSelecionadoId!,
      );

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(() {
        _codigoController.text = codigo;
      });
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarErro(
        titulo: 'Código indisponível',
        mensagem:
            'Não foi possível obter um código oficial de selagem.\n\nDetalhes: $e',
      );
    }
  }

  Future<void> _capturarCoordenada() async {
    LoadingDialog.show(
      context,
      title: 'Capturando localização',
      message: 'Obtendo coordenadas GPS do imóvel...',
    );

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception(
            'O serviço de localização está desativado no dispositivo.');
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Permissão de localização negada permanentemente. Ative a permissão nas configurações do dispositivo.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(() {
        _latitudeController.text = position.latitude.toStringAsFixed(8);
        _longitudeController.text = position.longitude.toStringAsFixed(8);
        _precisaoGpsController.text = position.accuracy.toStringAsFixed(2);
      });

      await _mostrarAviso(
        titulo: 'Coordenada capturada',
        mensagem: 'Latitude: ${position.latitude.toStringAsFixed(8)}\n'
            'Longitude: ${position.longitude.toStringAsFixed(8)}\n'
            'Precisão estimada: ${position.accuracy.toStringAsFixed(2)} m',
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarErro(
        titulo: 'Erro na localização',
        mensagem: 'Não foi possível capturar a coordenada.\n\nDetalhes: $e',
      );
    }
  }

  Future<void> _salvarSelagem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_projetoSelecionadoId == null) {
      await _mostrarAviso(
        titulo: 'Projeto obrigatório',
        mensagem: 'Selecione um projeto REURB antes de salvar a selagem.',
      );
      return;
    }

    LoadingDialog.show(
      context,
      title: 'Salvando selagem',
      message: 'Registrando a selagem no banco local...',
    );

    try {
      final db = ref.read(appDatabaseProvider);
      final sourceDeviceId = await ref.read(deviceIdentityProvider.future);

      final wasEditing = _isEditing;
      final savedLocalId = wasEditing ? _editingSelagemId! : const Uuid().v4();

      if (wasEditing) {
        await db.atualizarSelagemReurb(
          id: savedLocalId,
          projetoId: _projetoSelecionadoId!,
          lotePreliminarId: _lotePreliminarSelecionadoId,
          codigoLotePreliminar: _codigoLotePreliminarSelecionado,
          codigoSelo: _codigoController.text.trim(),
          situacao: _situacao,
          moradorPresente: _moradorPresente,
          moradiaOcupada: _moradiaOcupada,
          situacaoAtendimento: _situacaoAtendimento,
          tipoUnidade: _tipoUnidade,
          usoImovel: _usoImovel,
          nomeInformante: _nomeInformanteController.text.trim().isEmpty
              ? null
              : _nomeInformanteController.text.trim(),
          telefoneInformante: _telefoneInformanteController.text.trim().isEmpty
              ? null
              : _telefoneInformanteController.text.trim(),
          relacaoInformante: _relacaoInformante,
          revisitaNecessaria: _revisitaNecessaria,
          statusVinculoGeografico: _lotePreliminarSelecionadoId == null
              ? 'sem_lote_vetorizado'
              : _statusVinculoGeografico,
          necessitaValidacaoRtk: _lotePreliminarSelecionadoId == null
              ? true
              : _necessitaValidacaoRtk,
          observacaoGeoespacial:
              _observacaoGeoespacialController.text.trim().isEmpty
                  ? null
                  : _observacaoGeoespacialController.text.trim(),
          latitude:
              double.tryParse(_latitudeController.text.replaceAll(',', '.')),
          longitude:
              double.tryParse(_longitudeController.text.replaceAll(',', '.')),
          precisaoGps:
              double.tryParse(_precisaoGpsController.text.replaceAll(',', '.')),
          observacoes: _observacoesController.text.trim().isEmpty
              ? null
              : _observacoesController.text.trim(),
          sourceDeviceId: sourceDeviceId,
        );
      } else {
        await db.inserirSelagemReurb(
          id: savedLocalId,
          projetoId: _projetoSelecionadoId!,
          lotePreliminarId: _lotePreliminarSelecionadoId,
          codigoLotePreliminar: _codigoLotePreliminarSelecionado,
          codigoSelo: _codigoController.text.trim(),
          situacao: _situacao,
          moradorPresente: _moradorPresente,
          moradiaOcupada: _moradiaOcupada,
          situacaoAtendimento: _situacaoAtendimento,
          tipoUnidade: _tipoUnidade,
          usoImovel: _usoImovel,
          nomeInformante: _nomeInformanteController.text.trim().isEmpty
              ? null
              : _nomeInformanteController.text.trim(),
          telefoneInformante: _telefoneInformanteController.text.trim().isEmpty
              ? null
              : _telefoneInformanteController.text.trim(),
          relacaoInformante: _relacaoInformante,
          revisitaNecessaria: _revisitaNecessaria,
          statusVinculoGeografico: _lotePreliminarSelecionadoId == null
              ? 'sem_lote_vetorizado'
              : _statusVinculoGeografico,
          necessitaValidacaoRtk: _lotePreliminarSelecionadoId == null
              ? true
              : _necessitaValidacaoRtk,
          observacaoGeoespacial:
              _observacaoGeoespacialController.text.trim().isEmpty
                  ? null
                  : _observacaoGeoespacialController.text.trim(),
          latitude:
              double.tryParse(_latitudeController.text.replaceAll(',', '.')),
          longitude:
              double.tryParse(_longitudeController.text.replaceAll(',', '.')),
          precisaoGps:
              double.tryParse(_precisaoGpsController.text.replaceAll(',', '.')),
          observacoes: _observacoesController.text.trim().isEmpty
              ? null
              : _observacoesController.text.trim(),
          sourceDeviceId: sourceDeviceId,
        );
      }

      final syncResult = await ref
          .read(sealSyncControllerProvider.notifier)
          .synchronize(projectId: _projetoSelecionadoId!);

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(() {
        _codigoController.clear();
        _latitudeController.clear();
        _longitudeController.clear();
        _observacoesController.clear();
        _situacao = 'ocupado';
        _nomeInformanteController.clear();
        _telefoneInformanteController.clear();
        _precisaoGpsController.clear();

        _moradorPresente = true;
        _moradiaOcupada = true;
        _revisitaNecessaria = false;

        _situacaoAtendimento = 'atendido';
        _tipoUnidade = 'casa';
        _usoImovel = 'residencial';
        _relacaoInformante = 'responsavel';
        _lotePreliminarSelecionadoId = null;
        _codigoLotePreliminarSelecionado = null;
        _statusVinculoGeografico = 'confirmado';
        _necessitaValidacaoRtk = false;
        _observacaoGeoespacialController.clear();
        _editingSelagemId = null;
        _carregarDados();
      });

      final syncMessage = syncResult.allAccepted
          ? 'A selagem foi salva no aparelho e sincronizada com o painel web.'
          : syncResult.offline
              ? 'A selagem foi salva no aparelho. Não havia conexão com o '
                  'servidor, então ela permanecerá na fila para reenvio.'
              : syncResult.conflicts > 0
                  ? 'A selagem foi salva, mas há um conflito que precisa de revisão.'
                  : 'A selagem foi salva no aparelho e permanece pendente de '
                      'sincronização.';

      await _mostrarAviso(
        titulo: wasEditing ? 'Selagem atualizada' : 'Selagem salva',
        mensagem: syncMessage,
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarErro(
        titulo: 'Erro ao salvar',
        mensagem: 'Não foi possível salvar a selagem.\n\nDetalhes: $e',
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

  Future<void> _mostrarErro({
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

  String _situacaoLabel(String situacao) {
    switch (situacao) {
      case 'ocupado':
        return 'Ocupado';
      case 'ausente':
        return 'Morador ausente';
      case 'vazio':
        return 'Imóvel vazio';
      case 'construcao':
        return 'Em construção';
      case 'recusa':
        return 'Recusa';
      default:
        return situacao;
    }
  }

  String _formatarCoordenada(Object? value) {
    if (value == null) return '-';
    final numero = double.tryParse(value.toString());
    if (numero == null) return '-';
    return numero.toStringAsFixed(8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selagem de Imóvel'),
      ),
      body: FutureBuilder<List<Map<String, Object?>>>(
        future: _futureProjetos,
        builder: (context, projetosSnapshot) {
          if (projetosSnapshot.connectionState == ConnectionState.waiting) {
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
                      Text('Carregando projetos REURB...'),
                    ],
                  ),
                ),
              ),
            );
          }

          final projetos = projetosSnapshot.data ?? [];

          if (projetos.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Nenhum projeto cadastrado. Cadastre um projeto REURB antes de iniciar a selagem.',
                  ),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Nova Selagem',
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
                          value: _projetoSelecionadoId,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Projeto REURB',
                            prefixIcon: Icon(Icons.folder_copy),
                          ),
                          items: projetos.map((projeto) {
                            return DropdownMenuItem<String>(
                              value: projeto['id']?.toString(),
                              child: Text(
                                '${projeto['nome']} - ${projeto['bairro']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _projetoSelecionadoId = value;
                              _lotePreliminarSelecionadoId = null;
                              _codigoLotePreliminarSelecionado = null;
                              _codigoController.clear();

                              final db = ref.read(appDatabaseProvider);

                              if (value != null) {
                                _futureLotesPreliminares =
                                    db.listarLotesPreliminaresPorProjeto(value);
                              } else {
                                _futureLotesPreliminares = Future.value([]);
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Selecione o projeto REURB.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        const SizedBox(height: 12),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Lote preliminar vinculado',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B5E20),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _codigoLotePreliminarSelecionado == null
                                      ? 'Nenhum lote selecionado no mapa.'
                                      : 'Lote selecionado: $_codigoLotePreliminarSelecionado',
                                ),
                                const SizedBox(height: 12),
                                OutlinedButton.icon(
                                  onPressed: _selecionarLoteNoMapa,
                                  icon: const Icon(Icons.map),
                                  label: const Text('SELECIONAR LOTE NO MAPA'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _codigoController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Código da selagem',
                                  prefixIcon: Icon(Icons.qr_code_2),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Gere o código da selagem.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton.filled(
                              tooltip: 'Gerar código',
                              onPressed: () => _gerarCodigoSelagem(projetos),
                              icon: const Icon(Icons.refresh),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        DropdownButtonFormField<String>(
                          initialValue: _statusVinculoGeografico,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Status do vínculo geoespacial',
                            prefixIcon: Icon(Icons.gps_fixed),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'confirmado',
                              child: Text('Confirmado em campo'),
                            ),
                            DropdownMenuItem(
                              value: 'provavel',
                              child: Text('Provável, mas requer atenção'),
                            ),
                            DropdownMenuItem(
                              value: 'requer_conferencia',
                              child: Text('Requer conferência técnica'),
                            ),
                            DropdownMenuItem(
                              value: 'inconsistente',
                              child: Text('Inconsistente'),
                            ),
                            DropdownMenuItem(
                              value: 'sem_lote_vetorizado',
                              child: Text('Sem lote vetorizado'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _statusVinculoGeografico = value;

                                _necessitaValidacaoRtk =
                                    value == 'requer_conferencia' ||
                                        value == 'inconsistente' ||
                                        value == 'sem_lote_vetorizado';
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          value: _necessitaValidacaoRtk,
                          title: const Text('Necessita validação RTK?'),
                          subtitle:
                              Text(_necessitaValidacaoRtk ? 'Sim' : 'Não'),
                          onChanged: (value) {
                            setState(() => _necessitaValidacaoRtk = value);
                          },
                        ),
                        TextFormField(
                          controller: _observacaoGeoespacialController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Observação geoespacial',
                            prefixIcon: Icon(Icons.edit_location_alt),
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 18),
                        DropdownButtonFormField<String>(
                          value: _situacao,
                          decoration: const InputDecoration(
                            labelText: 'Situação do imóvel',
                            prefixIcon: Icon(Icons.home),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'ocupado',
                              child: Text('Ocupado'),
                            ),
                            DropdownMenuItem(
                              value: 'ausente',
                              child: Text('Morador ausente'),
                            ),
                            DropdownMenuItem(
                              value: 'vazio',
                              child: Text('Imóvel vazio'),
                            ),
                            DropdownMenuItem(
                              value: 'construcao',
                              child: Text('Em construção'),
                            ),
                            DropdownMenuItem(
                              value: 'recusa',
                              child: Text('Recusa'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _situacao = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          value: _moradorPresente,
                          title: const Text('Morador presente?'),
                          subtitle: Text(_moradorPresente ? 'Sim' : 'Não'),
                          onChanged: (value) {
                            setState(() => _moradorPresente = value);
                          },
                        ),
                        SwitchListTile(
                          value: _moradiaOcupada,
                          title: const Text('Moradia ocupada?'),
                          subtitle: Text(_moradiaOcupada ? 'Sim' : 'Não'),
                          onChanged: (value) {
                            setState(() => _moradiaOcupada = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _situacaoAtendimento,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Situação do atendimento',
                            prefixIcon: Icon(Icons.assignment_turned_in),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'atendido', child: Text('Atendido')),
                            DropdownMenuItem(
                                value: 'morador_ausente',
                                child: Text('Morador ausente')),
                            DropdownMenuItem(
                                value: 'imovel_fechado',
                                child: Text('Imóvel fechado')),
                            DropdownMenuItem(
                                value: 'recusa', child: Text('Recusa')),
                            DropdownMenuItem(
                                value: 'revisita',
                                child: Text('Requer revisita')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _situacaoAtendimento = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _tipoUnidade,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de unidade',
                            prefixIcon: Icon(Icons.house),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'casa', child: Text('Casa')),
                            DropdownMenuItem(
                                value: 'apartamento',
                                child: Text('Apartamento')),
                            DropdownMenuItem(
                                value: 'ponto_comercial',
                                child: Text('Ponto comercial')),
                            DropdownMenuItem(
                                value: 'terreno_vazio',
                                child: Text('Terreno vazio')),
                            DropdownMenuItem(
                                value: 'institucional',
                                child: Text('Institucional')),
                            DropdownMenuItem(
                                value: 'outro', child: Text('Outro')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _tipoUnidade = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _usoImovel,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Uso do imóvel',
                            prefixIcon: Icon(Icons.domain),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'residencial',
                                child: Text('Residencial')),
                            DropdownMenuItem(
                                value: 'comercial', child: Text('Comercial')),
                            DropdownMenuItem(
                                value: 'misto', child: Text('Misto')),
                            DropdownMenuItem(
                                value: 'religioso', child: Text('Religioso')),
                            DropdownMenuItem(
                                value: 'institucional',
                                child: Text('Institucional')),
                            DropdownMenuItem(
                                value: 'sem_uso',
                                child: Text('Sem uso aparente')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _usoImovel = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nomeInformanteController,
                          decoration: const InputDecoration(
                            labelText: 'Nome do informante',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _telefoneInformanteController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Telefone do informante',
                            prefixIcon: Icon(Icons.phone),
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _relacaoInformante,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Relação com o imóvel',
                            prefixIcon: Icon(Icons.family_restroom),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'responsavel',
                                child: Text('Responsável')),
                            DropdownMenuItem(
                                value: 'conjuge', child: Text('Cônjuge')),
                            DropdownMenuItem(
                                value: 'filho', child: Text('Filho(a)')),
                            DropdownMenuItem(
                                value: 'parente', child: Text('Parente')),
                            DropdownMenuItem(
                                value: 'inquilino', child: Text('Inquilino')),
                            DropdownMenuItem(
                                value: 'vizinho', child: Text('Vizinho')),
                            DropdownMenuItem(
                                value: 'informante', child: Text('Informante')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _relacaoInformante = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          value: _revisitaNecessaria,
                          title: const Text('Revisita necessária?'),
                          subtitle: Text(_revisitaNecessaria ? 'Sim' : 'Não'),
                          onChanged: (value) {
                            setState(() => _revisitaNecessaria = value);
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _latitudeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Latitude',
                                  prefixIcon: Icon(Icons.my_location),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _longitudeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Longitude',
                                  prefixIcon: Icon(Icons.my_location),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _precisaoGpsController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Precisão GPS estimada m',
                            prefixIcon: Icon(Icons.gps_fixed),
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: _capturarCoordenada,
                          icon: const Icon(Icons.gps_fixed),
                          label: const Text('CAPTURAR GPS'),
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
                          onPressed: _salvarSelagem,
                          icon: Icon(_isEditing ? Icons.update : Icons.save),
                          label: Text(_isEditing
                              ? 'ATUALIZAR SELAGEM'
                              : 'SALVAR SELAGEM'),
                        ),
                        if (_isEditing) ...[
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: _cancelarEdicaoSelagem,
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
                'Selagens realizadas',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Map<String, Object?>>>(
                future: _futureSelagens,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            LinearProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Carregando selagens realizadas...'),
                          ],
                        ),
                      ),
                    );
                  }

                  final selagens = snapshot.data ?? [];

                  if (selagens.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Nenhuma selagem cadastrada.'),
                      ),
                    );
                  }

                  return Column(
                    children: selagens.map((selagem) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.qr_code_2,
                            color: Color(0xFF1B5E20),
                          ),
                          title: Text(
                            selagem['codigo_selo']?.toString() ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${selagem['projeto_nome'] ?? 'Projeto não informado'}\n'
                            'Lote: ${selagem['codigo_lote_preliminar'] ?? 'sem lote'} • '
                            '${_situacaoLabel(selagem['situacao'].toString())}\n'
                            'Vínculo: ${selagem['status_vinculo_geografico'] ?? 'não validado'} • '
                            'RTK: ${selagem['necessita_validacao_rtk'] == 1 ? 'Sim' : 'Não'}',
                          ),
                          isThreeLine: true,
                          trailing: Wrap(
                            spacing: 2,
                            children: [
                              IconButton(
                                tooltip: 'Editar selagem',
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () =>
                                    _prepararEdicaoSelagem(selagem),
                              ),
                              IconButton(
                                tooltip: 'Excluir selagem',
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _confirmarExclusaoSelagem(selagem),
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
