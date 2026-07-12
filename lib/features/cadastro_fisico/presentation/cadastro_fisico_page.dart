import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/widgets/loading_dialog.dart';
import '../../../data/local/database_provider.dart';

class CadastroFisicoPage extends ConsumerStatefulWidget {
  const CadastroFisicoPage({super.key});

  @override
  ConsumerState<CadastroFisicoPage> createState() => _CadastroFisicoPageState();
}

class _CadastroFisicoPageState extends ConsumerState<CadastroFisicoPage> {
  final _formKey = GlobalKey<FormState>();

  final _codigoSeloController = TextEditingController();
  final _pavimentosController = TextEditingController(text: '1');
  final _comodosController = TextEditingController();
  final _banheirosController = TextEditingController();
  final _observacoesController = TextEditingController();

  String? _selagemSelecionadaId;
  String? _projetoSelecionadoId;

  String _tipoImovel = 'casa';
  String _usoImovel = 'residencial';
  String _materialParedes = 'alvenaria';
  String _tipoCobertura = 'telha_fibrocimento';
  String _tipoPiso = 'cimento';
  String _condicaoHabitabilidade = 'boa';

  bool _possuiEnergia = true;
  bool _possuiAgua = true;
  bool _possuiEsgoto = false;
  bool _possuiBanheiro = true;
  bool _areaRisco = false;
  bool _sujeitoInundacao = false;

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
    _pavimentosController.dispose();
    _comodosController.dispose();
    _banheirosController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  void _carregarDados() {
    final db = ref.read(appDatabaseProvider);
    _futureSelagens = db.listarSelagensParaCadastroFisico();
    _futureCadastros = db.listarCadastrosFisicos();
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

      final tipoUnidade = selagem['tipo_unidade']?.toString();
      final uso = selagem['uso_imovel']?.toString();

      const tiposPermitidos = {
        'casa',
        'apartamento',
        'ponto_comercial',
        'terreno_vazio',
        'institucional',
        'outro',
      };

      const usosPermitidos = {
        'residencial',
        'comercial',
        'misto',
        'religioso',
        'institucional',
        'sem_uso',
      };

      if (tipoUnidade != null && tiposPermitidos.contains(tipoUnidade)) {
        _tipoImovel = tipoUnidade;
      } else {
        _tipoImovel = 'casa';
      }

      if (uso != null && usosPermitidos.contains(uso)) {
        _usoImovel = uso;
      } else {
        _usoImovel = 'residencial';
      }
    });
  }

  Future<void> _salvarCadastroFisico() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selagemSelecionadaId == null || _projetoSelecionadoId == null) {
      await _mostrarAviso(
        titulo: 'Selagem obrigatória',
        mensagem: 'Selecione uma selagem antes de salvar o cadastro físico.',
      );
      return;
    }

    LoadingDialog.show(
      context,
      title: _isEditing
          ? 'Atualizando cadastro físico'
          : 'Salvando cadastro físico',
      message: _isEditing
          ? 'Atualizando as informações físicas do imóvel no banco local...'
          : 'Registrando as informações físicas do imóvel no banco local...',
    );

    try {
      final db = ref.read(appDatabaseProvider);

      final observacoes = _observacoesController.text.trim().isEmpty
          ? null
          : _observacoesController.text.trim();

      if (_isEditing) {
        await db.atualizarCadastroFisico(
          id: _editingCadastroId!,
          projetoId: _projetoSelecionadoId!,
          selagemId: _selagemSelecionadaId,
          codigoSelo: _codigoSeloController.text.trim(),
          tipoImovel: _tipoImovel,
          usoImovel: _usoImovel,
          materialParedes: _materialParedes,
          tipoCobertura: _tipoCobertura,
          tipoPiso: _tipoPiso,
          numeroPavimentos: int.tryParse(_pavimentosController.text.trim()),
          numeroComodos: int.tryParse(_comodosController.text.trim()),
          numeroBanheiros: int.tryParse(_banheirosController.text.trim()),
          possuiEnergia: _possuiEnergia,
          possuiAgua: _possuiAgua,
          possuiEsgoto: _possuiEsgoto,
          possuiBanheiro: _possuiBanheiro,
          condicaoHabitabilidade: _condicaoHabitabilidade,
          areaRisco: _areaRisco,
          sujeitoInundacao: _sujeitoInundacao,
          observacoes: observacoes,
        );
      } else {
        await db.inserirCadastroFisico(
          id: const Uuid().v4(),
          projetoId: _projetoSelecionadoId!,
          selagemId: _selagemSelecionadaId,
          codigoSelo: _codigoSeloController.text.trim(),
          tipoImovel: _tipoImovel,
          usoImovel: _usoImovel,
          materialParedes: _materialParedes,
          tipoCobertura: _tipoCobertura,
          tipoPiso: _tipoPiso,
          numeroPavimentos: int.tryParse(_pavimentosController.text.trim()),
          numeroComodos: int.tryParse(_comodosController.text.trim()),
          numeroBanheiros: int.tryParse(_banheirosController.text.trim()),
          possuiEnergia: _possuiEnergia,
          possuiAgua: _possuiAgua,
          possuiEsgoto: _possuiEsgoto,
          possuiBanheiro: _possuiBanheiro,
          condicaoHabitabilidade: _condicaoHabitabilidade,
          areaRisco: _areaRisco,
          sujeitoInundacao: _sujeitoInundacao,
          observacoes: observacoes,
        );
      }

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(() {
        _limparFormulario();
        _carregarDados();
      });

      await _mostrarAviso(
        titulo:
            _isEditing ? 'Cadastro físico atualizado' : 'Cadastro físico salvo',
        mensagem: _isEditing
            ? 'O cadastro físico do imóvel foi atualizado com sucesso.'
            : 'O cadastro físico do imóvel foi registrado com sucesso.',
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: _isEditing ? 'Erro ao atualizar' : 'Erro ao salvar',
        mensagem: 'Não foi possível salvar o cadastro físico.\n\nDetalhes: $e',
      );
    }
  }

  void _limparFormulario() {
    _editingCadastroId = null;
    _selagemSelecionadaId = null;
    _projetoSelecionadoId = null;
    _codigoSeloController.clear();
    _pavimentosController.text = '1';
    _comodosController.clear();
    _banheirosController.clear();
    _observacoesController.clear();

    _tipoImovel = 'casa';
    _usoImovel = 'residencial';
    _materialParedes = 'alvenaria';
    _tipoCobertura = 'telha_fibrocimento';
    _tipoPiso = 'cimento';
    _condicaoHabitabilidade = 'boa';

    _possuiEnergia = true;
    _possuiAgua = true;
    _possuiEsgoto = false;
    _possuiBanheiro = true;
    _areaRisco = false;
    _sujeitoInundacao = false;

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

  String _label(String value) {
    switch (value) {
      case 'casa':
        return 'Casa';
      case 'apartamento':
        return 'Apartamento';
      case 'ponto_comercial':
        return 'Ponto comercial';
      case 'terreno_vazio':
        return 'Terreno vazio';
      case 'institucional':
        return 'Institucional';
      case 'residencial':
        return 'Residencial';
      case 'comercial':
        return 'Comercial';
      case 'misto':
        return 'Misto';
      case 'religioso':
        return 'Religioso';
      case 'sem_uso':
        return 'Sem uso aparente';
      case 'alvenaria':
        return 'Alvenaria';
      case 'madeira':
        return 'Madeira';
      case 'mista':
        return 'Mista';
      case 'taipa':
        return 'Taipa';
      case 'telha_ceramica':
        return 'Telha cerâmica';
      case 'telha_fibrocimento':
        return 'Telha fibrocimento';
      case 'laje':
        return 'Laje';
      case 'palha':
        return 'Palha';
      case 'cimento':
        return 'Cimento';
      case 'ceramica':
        return 'Cerâmica';
      case 'terra':
        return 'Terra batida';
      case 'boa':
        return 'Boa';
      case 'regular':
        return 'Regular';
      case 'precaria':
        return 'Precária';
      case 'inabitavel':
        return 'Inabitável';
      case 'outro':
        return 'Outro';
      default:
        return value;
    }
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
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  void _prepararEdicaoCadastroFisico(Map<String, Object?> cadastro) {
    setState(() {
      _editingCadastroId = cadastro['id']?.toString();

      _selagemSelecionadaId = cadastro['selagem_id']?.toString();
      _projetoSelecionadoId = cadastro['projeto_id']?.toString();

      _codigoSeloController.text = cadastro['codigo_selo']?.toString() ?? '';

      _tipoImovel = _valorPermitido(
        cadastro['tipo_imovel']?.toString(),
        const {
          'casa',
          'apartamento',
          'ponto_comercial',
          'terreno_vazio',
          'institucional',
          'outro',
        },
        'casa',
      );

      _usoImovel = _valorPermitido(
        cadastro['uso_imovel']?.toString(),
        const {
          'residencial',
          'comercial',
          'misto',
          'religioso',
          'institucional',
          'sem_uso',
        },
        'residencial',
      );

      _materialParedes = _valorPermitido(
        cadastro['material_paredes']?.toString(),
        const {
          'alvenaria',
          'madeira',
          'mista',
          'taipa',
          'outro',
        },
        'alvenaria',
      );

      _tipoCobertura = _valorPermitido(
        cadastro['tipo_cobertura']?.toString(),
        const {
          'telha_ceramica',
          'telha_fibrocimento',
          'laje',
          'palha',
          'outro',
        },
        'telha_fibrocimento',
      );

      _tipoPiso = _valorPermitido(
        cadastro['tipo_piso']?.toString(),
        const {
          'cimento',
          'ceramica',
          'terra',
          'madeira',
          'outro',
        },
        'cimento',
      );

      _condicaoHabitabilidade = _valorPermitido(
        cadastro['condicao_habitabilidade']?.toString(),
        const {
          'boa',
          'regular',
          'precaria',
          'inabitavel',
        },
        'boa',
      );

      _pavimentosController.text =
          cadastro['numero_pavimentos']?.toString() ?? '1';
      _comodosController.text = cadastro['numero_comodos']?.toString() ?? '';
      _banheirosController.text =
          cadastro['numero_banheiros']?.toString() ?? '';

      _possuiEnergia = _boolFromDb(cadastro['possui_energia']);
      _possuiAgua = _boolFromDb(cadastro['possui_agua']);
      _possuiEsgoto = _boolFromDb(cadastro['possui_esgoto']);
      _possuiBanheiro = _boolFromDb(cadastro['possui_banheiro']);

      _areaRisco = _boolFromDb(cadastro['area_risco']);
      _sujeitoInundacao = _boolFromDb(cadastro['sujeito_inundacao']);

      _observacoesController.text = cadastro['observacoes']?.toString() ?? '';

      _codigoLotePreliminar = cadastro['codigo_lote_preliminar']?.toString();
      _statusVinculoGeografico =
          cadastro['status_vinculo_geografico']?.toString();
      _necessitaValidacaoRtk = _boolFromDb(cadastro['necessita_validacao_rtk']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cadastro físico carregado para edição.'),
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

  void _cancelarEdicaoCadastroFisico() {
    setState(() {
      _limparFormulario();
    });
  }

  Future<void> _confirmarExclusaoCadastroFisico(
    Map<String, Object?> cadastro,
  ) async {
    final id = cadastro['id']?.toString();

    if (id == null || id.isEmpty) {
      await _mostrarAviso(
        titulo: 'Erro na exclusão',
        mensagem: 'Não foi possível identificar o cadastro físico selecionado.',
      );
      return;
    }

    final codigo =
        cadastro['codigo_selo']?.toString() ?? 'este cadastro físico';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirmar exclusão'),
          content: Text(
            'Deseja realmente excluir o cadastro físico "$codigo"?\n\n'
            'A selagem, o cadastro social e os documentos vinculados não serão apagados.',
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
      await _excluirCadastroFisico(id);
    }
  }

  Future<void> _excluirCadastroFisico(String id) async {
    LoadingDialog.show(
      context,
      title: 'Excluindo cadastro físico',
      message: 'Removendo o cadastro físico do banco local...',
    );

    try {
      final db = ref.read(appDatabaseProvider);

      await db.excluirCadastroFisico(id);

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(() {
        if (_editingCadastroId == id) {
          _limparFormulario();
        }

        _carregarDados();
      });

      await _mostrarAviso(
        titulo: 'Cadastro físico excluído',
        mensagem: 'O cadastro físico foi excluído com sucesso.',
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro ao excluir',
        mensagem: 'Não foi possível excluir o cadastro físico.\n\nDetalhes: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Físico'),
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
                    'Nenhuma selagem cadastrada. Realize a selagem antes do cadastro físico.',
                  ),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                _isEditing ? 'Editar Cadastro Físico' : 'Novo Cadastro Físico',
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
                          value: _selagemSelecionadaId,
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
                        _sectionTitle('Caracterização do imóvel'),
                        _dropdown(
                          label: 'Tipo de imóvel',
                          icon: Icons.house,
                          value: _tipoImovel,
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
                              setState(() => _tipoImovel = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        _dropdown(
                          label: 'Uso do imóvel',
                          icon: Icons.domain,
                          value: _usoImovel,
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
                        _sectionTitle('Características construtivas'),
                        _dropdown(
                          label: 'Material das paredes',
                          icon: Icons.foundation,
                          value: _materialParedes,
                          items: const [
                            DropdownMenuItem(
                                value: 'alvenaria', child: Text('Alvenaria')),
                            DropdownMenuItem(
                                value: 'madeira', child: Text('Madeira')),
                            DropdownMenuItem(
                                value: 'mista', child: Text('Mista')),
                            DropdownMenuItem(
                                value: 'taipa', child: Text('Taipa')),
                            DropdownMenuItem(
                                value: 'outro', child: Text('Outro')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _materialParedes = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        _dropdown(
                          label: 'Tipo de cobertura',
                          icon: Icons.roofing,
                          value: _tipoCobertura,
                          items: const [
                            DropdownMenuItem(
                                value: 'telha_ceramica',
                                child: Text('Telha cerâmica')),
                            DropdownMenuItem(
                                value: 'telha_fibrocimento',
                                child: Text('Telha fibrocimento')),
                            DropdownMenuItem(
                                value: 'laje', child: Text('Laje')),
                            DropdownMenuItem(
                                value: 'palha', child: Text('Palha')),
                            DropdownMenuItem(
                                value: 'outro', child: Text('Outro')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _tipoCobertura = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        _dropdown(
                          label: 'Tipo de piso',
                          icon: Icons.grid_view,
                          value: _tipoPiso,
                          items: const [
                            DropdownMenuItem(
                                value: 'cimento', child: Text('Cimento')),
                            DropdownMenuItem(
                                value: 'ceramica', child: Text('Cerâmica')),
                            DropdownMenuItem(
                                value: 'terra', child: Text('Terra batida')),
                            DropdownMenuItem(
                                value: 'madeira', child: Text('Madeira')),
                            DropdownMenuItem(
                                value: 'outro', child: Text('Outro')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _tipoPiso = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _pavimentosController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Pavimentos',
                                  prefixIcon: Icon(Icons.layers),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _comodosController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Cômodos',
                                  prefixIcon: Icon(Icons.meeting_room),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _banheirosController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Banheiros',
                            prefixIcon: Icon(Icons.bathtub),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _sectionTitle('Infraestrutura e habitabilidade'),
                        SwitchListTile(
                          value: _possuiEnergia,
                          title: const Text('Possui energia elétrica?'),
                          subtitle: Text(_possuiEnergia ? 'Sim' : 'Não'),
                          onChanged: (value) {
                            setState(() => _possuiEnergia = value);
                          },
                        ),
                        SwitchListTile(
                          value: _possuiAgua,
                          title: const Text('Possui abastecimento de água?'),
                          subtitle: Text(_possuiAgua ? 'Sim' : 'Não'),
                          onChanged: (value) {
                            setState(() => _possuiAgua = value);
                          },
                        ),
                        SwitchListTile(
                          value: _possuiEsgoto,
                          title: const Text('Possui esgotamento sanitário?'),
                          subtitle: Text(_possuiEsgoto ? 'Sim' : 'Não'),
                          onChanged: (value) {
                            setState(() => _possuiEsgoto = value);
                          },
                        ),
                        SwitchListTile(
                          value: _possuiBanheiro,
                          title: const Text('Possui banheiro?'),
                          subtitle: Text(_possuiBanheiro ? 'Sim' : 'Não'),
                          onChanged: (value) {
                            setState(() => _possuiBanheiro = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        _dropdown(
                          label: 'Condição de habitabilidade',
                          icon: Icons.health_and_safety,
                          value: _condicaoHabitabilidade,
                          items: const [
                            DropdownMenuItem(value: 'boa', child: Text('Boa')),
                            DropdownMenuItem(
                                value: 'regular', child: Text('Regular')),
                            DropdownMenuItem(
                                value: 'precaria', child: Text('Precária')),
                            DropdownMenuItem(
                                value: 'inabitavel', child: Text('Inabitável')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _condicaoHabitabilidade = value);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          value: _areaRisco,
                          title: const Text('Área de risco?'),
                          subtitle: Text(_areaRisco ? 'Sim' : 'Não'),
                          onChanged: (value) {
                            setState(() => _areaRisco = value);
                          },
                        ),
                        SwitchListTile(
                          value: _sujeitoInundacao,
                          title: const Text('Sujeito à inundação?'),
                          subtitle: Text(_sujeitoInundacao ? 'Sim' : 'Não'),
                          onChanged: (value) {
                            setState(() => _sujeitoInundacao = value);
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
                          onPressed: _salvarCadastroFisico,
                          icon: Icon(_isEditing ? Icons.update : Icons.save),
                          label: Text(
                            _isEditing
                                ? 'ATUALIZAR CADASTRO FÍSICO'
                                : 'SALVAR CADASTRO FÍSICO',
                          ),
                        ),
                        if (_isEditing) ...[
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: _cancelarEdicaoCadastroFisico,
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
                'Cadastros físicos realizados',
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
                            Text('Carregando cadastros físicos...'),
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
                        child: Text('Nenhum cadastro físico registrado.'),
                      ),
                    );
                  }

                  return Column(
                    children: cadastros.map((cadastro) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.home_work,
                            color: Color(0xFF1B5E20),
                          ),
                          title: Text(
                            cadastro['codigo_selo']?.toString() ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${cadastro['projeto_bairro'] ?? 'Projeto'}\n'
                            'Lote: ${cadastro['codigo_lote_preliminar'] ?? 'sem lote'} • '
                            '${_label(cadastro['tipo_imovel']?.toString() ?? '')} • '
                            '${_label(cadastro['uso_imovel']?.toString() ?? '')}\n'
                            'Água: ${_simNao(cadastro['possui_agua'])} • '
                            'Energia: ${_simNao(cadastro['possui_energia'])}',
                          ),
                          isThreeLine: true,
                          trailing: Wrap(
                            spacing: 2,
                            children: [
                              IconButton(
                                tooltip: 'Editar cadastro físico',
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () =>
                                    _prepararEdicaoCadastroFisico(cadastro),
                              ),
                              IconButton(
                                tooltip: 'Excluir cadastro físico',
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _confirmarExclusaoCadastroFisico(cadastro),
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
