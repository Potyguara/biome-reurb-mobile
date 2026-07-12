import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

import '../../../core/widgets/loading_dialog.dart';
import '../../../data/local/database_provider.dart';
import '../../mobile/presentation/active_project_controller.dart';

class BaseCartograficaPage extends ConsumerStatefulWidget {
  const BaseCartograficaPage({super.key});

  @override
  ConsumerState<BaseCartograficaPage> createState() =>
      _BaseCartograficaPageState();
}

class _BaseCartograficaPageState extends ConsumerState<BaseCartograficaPage> {
  String? _projetoSelecionadoId;

  late Future<List<Map<String, Object?>>> _futureProjetos;
  Future<List<Map<String, Object?>>>? _futureLotesTecnicos;
  Future<List<Map<String, Object?>>>? _futureLotesCidadaos;

  @override
  void initState() {
    super.initState();

    // Inicializa o Future antes do primeiro build.
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

  void _carregarDados() {
    final db = ref.read(appDatabaseProvider);
    _futureProjetos = db.listarProjetosReurb();

    if (_projetoSelecionadoId != null) {
      _futureLotesTecnicos = db.listarLotesPreliminaresPorProjeto(
        _projetoSelecionadoId!,
      );
      _futureLotesCidadaos = db.listarVetorizacoesLoteCidadaoPorProjeto(
        _projetoSelecionadoId!,
      );
    } else {
      _futureLotesTecnicos = null;
      _futureLotesCidadaos = null;
    }
  }

  void _selecionarProjeto(String? projetoId) {
    setState(() {
      _projetoSelecionadoId = projetoId;
      _carregarDados();
    });
  }

  Future<void> _importarArquivo() async {
    if (_projetoSelecionadoId == null) {
      await _mostrarAviso(
        titulo: 'Projeto obrigatório',
        mensagem:
            'Selecione um projeto REURB antes de importar a base cartográfica.',
      );
      return;
    }

    LoadingDialog.show(
      context,
      title: 'Selecionando arquivo',
      message: 'Escolha o arquivo KML ou GeoJSON dos lotes preliminares...',
    );

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['kml', 'geojson', 'json'],
      );

      if (!mounted) return;
      LoadingDialog.hide(context);

      if (result == null || result.files.single.path == null) {
        await _mostrarAviso(
          titulo: 'Importação cancelada',
          mensagem: 'Nenhum arquivo foi selecionado.',
        );
        return;
      }

      final path = result.files.single.path!;
      final nomeArquivo = result.files.single.name;
      final conteudo = await File(path).readAsString();

      if (!mounted) return;

      LoadingDialog.show(
        context,
        title: 'Importando lotes',
        message: 'Processando geometrias e salvando no banco local...',
      );

      final extension = nomeArquivo.toLowerCase();

      int totalImportado;

      if (extension.endsWith('.kml')) {
        totalImportado = await _importarKml(
          conteudo: conteudo,
          nomeArquivo: nomeArquivo,
        );
      } else {
        totalImportado = await _importarGeoJson(
          conteudo: conteudo,
          nomeArquivo: nomeArquivo,
        );
      }

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(_carregarDados);

      await _mostrarAviso(
        titulo: 'Importação concluída',
        mensagem: 'Foram importados $totalImportado lotes preliminares.',
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro na importação',
        mensagem:
            'Não foi possível importar a base cartográfica.\n\nDetalhes: $e',
      );
    }
  }

  Future<int> _importarGeoJson({
    required String conteudo,
    required String nomeArquivo,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final json = jsonDecode(conteudo);

    final features = json['features'];

    if (features is! List) {
      throw Exception(
          'GeoJSON inválido: não foi encontrada a lista de features.');
    }

    var total = 0;

    for (final feature in features) {
      if (feature is! Map) continue;

      final properties = feature['properties'];
      final geometry = feature['geometry'];

      if (geometry == null) continue;

      final props = properties is Map ? properties : <String, dynamic>{};

      final codigo = _buscarCodigoLote(props, total + 1);
      final quadra = _buscarQuadra(props);

      await db.inserirLotePreliminar(
        id: const Uuid().v4(),
        projetoId: _projetoSelecionadoId!,
        codigoLote: codigo,
        quadra: quadra,
        areaM2: _buscarNumero(props, ['area_m2', 'area', 'AREA', 'Area']),
        perimetroM: _buscarNumero(
          props,
          ['perimetro_m', 'perimetro', 'PERIMETRO', 'Perimetro'],
        ),
        geometriaGeojson: jsonEncode(geometry),
        origemArquivo: nomeArquivo,
        tipoGeometria: geometry['type']?.toString(),
        statusLote: 'preliminar',
        necessitaRevisao: false,
      );

      total++;
    }

    return total;
  }

  Future<int> _importarKml({
    required String conteudo,
    required String nomeArquivo,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final document = XmlDocument.parse(conteudo);

    final placemarks = document.findAllElements('Placemark').toList();

    var total = 0;

    for (final placemark in placemarks) {
      final name = placemark.getElement('name')?.innerText.trim();

      final coordinatesNode = placemark
          .findAllElements('coordinates')
          .map((e) => e.innerText.trim())
          .where((e) => e.isNotEmpty)
          .firstOrNull;

      if (coordinatesNode == null) continue;

      final coords = _parseKmlCoordinatesToGeoJsonRing(coordinatesNode);

      if (coords.isEmpty) continue;

      final geometry = {
        'type': 'Polygon',
        'coordinates': [coords],
      };

      total++;

      final codigo = (name == null || name.isEmpty)
          ? 'LOTE-${total.toString().padLeft(4, '0')}'
          : name;

      await db.inserirLotePreliminar(
        id: const Uuid().v4(),
        projetoId: _projetoSelecionadoId!,
        codigoLote: codigo,
        quadra: null,
        geometriaGeojson: jsonEncode(geometry),
        origemArquivo: nomeArquivo,
        tipoGeometria: 'Polygon',
        statusLote: 'preliminar',
        necessitaRevisao: false,
      );
    }

    return total;
  }

  List<List<double>> _parseKmlCoordinatesToGeoJsonRing(String text) {
    final parts = text.split(RegExp(r'\s+'));
    final coords = <List<double>>[];

    for (final part in parts) {
      final values = part.split(',');

      if (values.length < 2) continue;

      final lon = double.tryParse(values[0]);
      final lat = double.tryParse(values[1]);

      if (lon == null || lat == null) continue;

      coords.add([lon, lat]);
    }

    return coords;
  }

  String _buscarCodigoLote(Map props, int fallbackIndex) {
    const keys = [
      'codigo_lote',
      'codigo',
      'CODIGO',
      'lote',
      'LOTE',
      'name',
      'Name',
      'id',
      'ID',
    ];

    for (final key in keys) {
      final value = props[key];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return 'LOTE-${fallbackIndex.toString().padLeft(4, '0')}';
  }

  String? _buscarQuadra(Map props) {
    const keys = [
      'quadra',
      'QUADRA',
      'Quadra',
      'q',
      'Q',
    ];

    for (final key in keys) {
      final value = props[key];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return null;
  }

  double? _buscarNumero(Map props, List<String> keys) {
    for (final key in keys) {
      final value = props[key];

      if (value == null) continue;

      final number = double.tryParse(
        value.toString().replaceAll(',', '.'),
      );

      if (number != null) {
        return number;
      }
    }

    return null;
  }

  Future<void> _limparLotesDoProjeto() async {
    if (_projetoSelecionadoId == null) {
      await _mostrarAviso(
        titulo: 'Projeto obrigatório',
        mensagem: 'Selecione um projeto antes de limpar os lotes importados.',
      );
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirmar limpeza'),
          content: const Text(
            'Deseja excluir todos os lotes preliminares importados para este projeto?',
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

    if (confirmar != true) return;

    LoadingDialog.show(
      context,
      title: 'Limpando base',
      message: 'Excluindo lotes preliminares do projeto selecionado...',
    );

    try {
      final db = ref.read(appDatabaseProvider);

      await db.excluirTodosLotesPreliminaresDoProjeto(_projetoSelecionadoId!);

      if (!mounted) return;

      LoadingDialog.hide(context);

      setState(_carregarDados);

      await _mostrarAviso(
        titulo: 'Base limpa',
        mensagem: 'Os lotes preliminares foram removidos com sucesso.',
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro ao limpar',
        mensagem: 'Não foi possível limpar os lotes.\n\nDetalhes: $e',
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

  String _formatarArea(Object? value) {
    if (value == null) return '-';
    final area = double.tryParse(value.toString());
    if (area == null) return '-';
    return '${area.toStringAsFixed(2)} m²';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Base Cartográfica'),
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
                    'Nenhum projeto autorizado está disponível neste aparelho. Atualize a sessão ou solicite o vínculo no painel web.',
                  ),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Importar Lotes Preliminares',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _projetoSelecionadoId,
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
                            ),
                          );
                        }).toList(),
                        onChanged: _selecionarProjeto,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Importe o arquivo KML ou GeoJSON contendo os lotes vetorizados preliminarmente a partir do ortomosaico.',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _importarArquivo,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('IMPORTAR KML/GEOJSON'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _limparLotesDoProjeto,
                        icon: const Icon(Icons.delete),
                        label: const Text('LIMPAR LOTES TÉCNICOS'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_projetoSelecionadoId == null)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Selecione um projeto para visualizar os lotes disponíveis.',
                    ),
                  ),
                )
              else ...[
                _SecaoLotesProjeto(
                  titulo: 'Lotes importados pelo técnico',
                  subtitulo:
                      'Geometrias provenientes de KML/GeoJSON da base cartográfica.',
                  icon: Icons.engineering_rounded,
                  color: const Color(0xFF1B5E20),
                  future: _futureLotesTecnicos!,
                  emptyMessage:
                      'Nenhum lote técnico importado para este projeto.',
                  itemBuilder: (lote) {
                    return ListTile(
                      leading: const Icon(
                        Icons.crop_square,
                        color: Color(0xFF1B5E20),
                      ),
                      title: Text(
                        lote['codigo_lote']?.toString() ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${lote['projeto_bairro'] ?? 'Projeto'} • '
                        'Quadra: ${lote['quadra'] ?? '-'}\n'
                        'Área: ${_formatarArea(lote['area_m2'])} • '
                        'Origem: ${lote['origem_arquivo'] ?? '-'}',
                      ),
                      isThreeLine: true,
                    );
                  },
                ),
                const SizedBox(height: 22),
                _SecaoLotesProjeto(
                  titulo: 'Lotes vetorizados pelos cidadãos',
                  subtitulo:
                      'Geometrias produzidas no módulo de vetorização assistida.',
                  icon: Icons.person_pin_circle_rounded,
                  color: Colors.orange,
                  future: _futureLotesCidadaos!,
                  emptyMessage:
                      'Nenhum lote vetorizado por cidadão neste projeto.',
                  itemBuilder: (lote) {
                    final codigo = lote['codigo_lote']?.toString();
                    final selo = lote['codigo_selo']?.toString();

                    return ListTile(
                      leading: const Icon(
                        Icons.person_pin_circle_rounded,
                        color: Colors.orange,
                      ),
                      title: Text(
                        (codigo != null && codigo.trim().isNotEmpty)
                            ? codigo
                            : (selo ?? 'Lote cidadão'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Selagem: ${selo ?? '-'} • '
                        'Status: ${lote['status'] ?? '-'}\n'
                        'Área: ${_formatarArea(lote['area_m2'])} • '
                        'Perímetro: ${lote['perimetro_m'] ?? '-'} m',
                      ),
                      isThreeLine: true,
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SecaoLotesProjeto extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icon;
  final Color color;
  final Future<List<Map<String, Object?>>> future;
  final String emptyMessage;
  final Widget Function(Map<String, Object?> lote) itemBuilder;

  const _SecaoLotesProjeto({
    required this.titulo,
    required this.subtitulo,
    required this.icon,
    required this.color,
    required this.future,
    required this.emptyMessage,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                titulo,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitulo,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<Map<String, Object?>>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      LinearProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Carregando lotes...'),
                    ],
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Não foi possível carregar esta lista.\n${snapshot.error}',
                  ),
                ),
              );
            }

            final lotes = snapshot.data ?? [];

            if (lotes.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(emptyMessage),
                ),
              );
            }

            return Column(
              children: lotes
                  .map(
                    (lote) => Card(
                      child: itemBuilder(lote),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

