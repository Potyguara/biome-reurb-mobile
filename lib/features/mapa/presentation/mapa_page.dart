import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_mbtiles/flutter_map_mbtiles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/widgets/loading_dialog.dart';
import '../../../data/local/database_provider.dart';

class MapaPage extends ConsumerStatefulWidget {
  const MapaPage({super.key});

  @override
  ConsumerState<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends ConsumerState<MapaPage> {
  final MapController _mapController = MapController();

  late Future<List<Map<String, Object?>>> _futureMapa;

  String _mapaBase = 'osm';

  bool _showLotesTecnicos = true;
  bool _showLotesCidadaos = true;
  bool _showLabels = true;
  bool _showGps = true;
  bool _showOrtomosaico = false;

  LatLng? _posicaoAtual;

  String? _ortomosaicoPath;
  MbTilesTileProvider? _ortomosaicoTileProvider;

  @override
  void initState() {
    super.initState();
    _carregarMapa();
    _capturarGpsInicial();
    _carregarOrtomosaicoPersistido();
  }

  void _carregarMapa() {
    final db = ref.read(appDatabaseProvider);
    _futureMapa = db.listarMapaGeralColeta();
  }

  Future<File> _arquivoOrtomosaicoPersistido() async {
    final appDir = await getApplicationDocumentsDirectory();

    final ortoDir = Directory(
      p.join(appDir.path, 'ortomosaicos_vetorizacao'),
    );

    if (!await ortoDir.exists()) {
      await ortoDir.create(recursive: true);
    }

    return File(
      p.join(
        ortoDir.path,
        'ortomosaico_vetorizacao_atual.mbtiles',
      ),
    );
  }

  Future<void> _carregarOrtomosaicoPersistido() async {
    try {
      final file = await _arquivoOrtomosaicoPersistido();

      if (!await file.exists()) {
        return;
      }

      final tileProvider = MbTilesTileProvider.fromPath(
        path: file.path,
      );

      if (!mounted) return;

      setState(() {
        _ortomosaicoPath = file.path;
        _ortomosaicoTileProvider = tileProvider;
        _showOrtomosaico = true;
      });

      _forcarAtualizacaoMapa();
    } catch (e) {
      debugPrint('Erro ao carregar ortomosaico persistido no mapa: $e');
    }
  }

  void _forcarAtualizacaoMapa() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      try {
        final camera = _mapController.camera;
        _mapController.move(camera.center, camera.zoom);
      } catch (_) {}
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      try {
        final camera = _mapController.camera;
        _mapController.move(camera.center, camera.zoom);
      } catch (_) {}
    });
  }

  int _intFromDb(Object? value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  bool _boolFromDb(Object? value) {
    if (value == null) return false;
    final text = value.toString();
    return text == '1' || text == 'true';
  }

  double? _toDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '.'));
  }

  List<LatLng> _extrairPontosDoGeoJson(String? geometriaText) {
    if (geometriaText == null || geometriaText.trim().isEmpty) {
      return [];
    }

    try {
      final geometry = jsonDecode(geometriaText);

      if (geometry is! Map) {
        return [];
      }

      final type = geometry['type']?.toString();
      final coordinates = geometry['coordinates'];

      if (type == 'Polygon' && coordinates is List && coordinates.isNotEmpty) {
        final firstRing = coordinates.first;

        if (firstRing is! List) {
          return [];
        }

        return firstRing
            .whereType<List>()
            .map((coord) {
              if (coord.length < 2) return null;

              final lon = _toDouble(coord[0]);
              final lat = _toDouble(coord[1]);

              if (lat == null || lon == null) return null;

              return LatLng(lat, lon);
            })
            .whereType<LatLng>()
            .toList();
      }

      if (type == 'MultiPolygon' &&
          coordinates is List &&
          coordinates.isNotEmpty &&
          coordinates.first is List &&
          (coordinates.first as List).isNotEmpty) {
        final polygon = coordinates.first as List;
        final firstRing = polygon.first;

        if (firstRing is! List) {
          return [];
        }

        return firstRing
            .whereType<List>()
            .map((coord) {
              if (coord.length < 2) return null;

              final lon = _toDouble(coord[0]);
              final lat = _toDouble(coord[1]);

              if (lat == null || lon == null) return null;

              return LatLng(lat, lon);
            })
            .whereType<LatLng>()
            .toList();
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  LatLng _centroDosPontos(List<LatLng> points) {
    if (points.isEmpty) {
      return _posicaoAtual ?? const LatLng(0.034, -51.069);
    }

    var lat = 0.0;
    var lon = 0.0;

    for (final p in points) {
      lat += p.latitude;
      lon += p.longitude;
    }

    return LatLng(lat / points.length, lon / points.length);
  }

  LatLng _centroGeral(List<Map<String, Object?>> lotes) {
    final pontos = <LatLng>[];

    for (final lote in lotes) {
      pontos.addAll(
        _extrairPontosDoGeoJson(
          lote['geometria_geojson']?.toString(),
        ),
      );
    }

    if (pontos.isEmpty) {
      return _posicaoAtual ?? const LatLng(0.034, -51.069);
    }

    return _centroDosPontos(pontos);
  }

  String _statusLote(Map<String, Object?> lote) {
    final totalSelagens = _intFromDb(lote['total_selagens']);
    final totalFisicos = _intFromDb(lote['total_cadastros_fisicos']);
    final totalSociais = _intFromDb(lote['total_cadastros_sociais']);
    final totalDocumentos = _intFromDb(lote['total_documentos']);
    final necessitaRtk = _boolFromDb(lote['necessita_validacao_rtk']);
    final necessitaRevisao = _boolFromDb(lote['necessita_revisao']);

    if (totalSelagens == 0) {
      return 'sem_selagem';
    }

    if (necessitaRtk || necessitaRevisao) {
      return 'requer_rtk';
    }

    if (totalSociais == 0) {
      return 'sem_social';
    }

    if (totalFisicos == 0) {
      return 'sem_fisico';
    }

    if (totalDocumentos == 0) {
      return 'sem_documentos';
    }

    return 'completo';
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'completo':
        return 'Completo';
      case 'sem_selagem':
        return 'Sem selagem';
      case 'sem_social':
        return 'Sem cadastro social';
      case 'sem_fisico':
        return 'Sem cadastro físico';
      case 'sem_documentos':
        return 'Sem documentos';
      case 'requer_rtk':
        return 'Requer RTK/Revisão';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'completo':
        return Colors.green;
      case 'sem_selagem':
        return Colors.orange;
      case 'sem_social':
        return Colors.red;
      case 'sem_fisico':
        return Colors.deepPurple;
      case 'sem_documentos':
        return Colors.blueGrey;
      case 'requer_rtk':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  Polygon _criarPoligono(Map<String, Object?> lote) {
    final pontos = _extrairPontosDoGeoJson(
      lote['geometria_geojson']?.toString(),
    );

    final status = _statusLote(lote);
    final origem = lote['origem_vetorizacao']?.toString();
    final color = origem == 'cidadao' ? Colors.orange : _statusColor(status);

    return Polygon(
      points: pontos,
      color: color.withOpacity(0.22),
      borderColor: color,
      borderStrokeWidth: status == 'requer_rtk' ? 4 : 2,
    );
  }

  Marker _criarLabel(Map<String, Object?> lote) {
    final pontos = _extrairPontosDoGeoJson(
      lote['geometria_geojson']?.toString(),
    );

    final centro = _centroDosPontos(pontos);
    final status = _statusLote(lote);
    final origem = lote['origem_vetorizacao']?.toString();
    final color = origem == 'cidadao' ? Colors.orange : _statusColor(status);

    final codigoLote = lote['codigo_lote']?.toString() ?? 'Lote';

    return Marker(
      point: centro,
      width: 110,
      height: 42,
      child: GestureDetector(
        onTap: () => _abrirResumoLote(lote),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color,
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 3,
                color: Colors.black26,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                codigoLote,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _statusLabel(status),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _capturarGpsInicial() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) return;

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      if (!mounted) return;

      setState(() {
        _posicaoAtual = LatLng(position.latitude, position.longitude);
      });
    } catch (_) {
      // Continua sem GPS.
    }
  }

  Future<void> _centralizarGps() async {
    LoadingDialog.show(
      context,
      title: 'Capturando GPS',
      message: 'Atualizando sua posição no mapa...',
    );

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('O serviço de localização está desativado.');
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permissão de localização negada permanentemente.');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      if (!mounted) return;

      LoadingDialog.hide(context);

      final latLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _posicaoAtual = latLng;
      });

      _mapController.move(latLng, 19);
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro no GPS',
        mensagem: 'Não foi possível capturar a localização.\n\nDetalhes: $e',
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

  Future<void> _importarOrtomosaicoMbtiles() async {
    LoadingDialog.show(
      context,
      title: 'Importando ortomosaico',
      message: 'Selecione o arquivo MBTiles do ortomosaico...',
    );

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (!mounted) return;

      if (result == null || result.files.single.path == null) {
        LoadingDialog.hide(context);
        return;
      }

      final fileName = result.files.single.name.toLowerCase();

      if (!fileName.endsWith('.mbtiles')) {
        LoadingDialog.hide(context);

        await _mostrarAviso(
          titulo: 'Arquivo inválido',
          mensagem: 'Selecione um arquivo com extensão .mbtiles.',
        );
        return;
      }

      final origem = File(result.files.single.path!);

      if (!await origem.exists()) {
        throw Exception('Arquivo MBTiles não encontrado.');
      }

      final appDir = await getApplicationDocumentsDirectory();

      final ortoDir = Directory(
        p.join(appDir.path, 'ortomosaicos_vetorizacao'),
      );

      if (!await ortoDir.exists()) {
        await ortoDir.create(recursive: true);
      }

      final destinoPath = p.join(
        ortoDir.path,
        'ortomosaico_vetorizacao_atual.mbtiles',
      );

      final destinoFile = File(destinoPath);

      if (await destinoFile.exists()) {
        await destinoFile.delete();
      }

      final destino = await origem.copy(destinoPath);

      final tileProvider = MbTilesTileProvider.fromPath(
        path: destino.path,
      );

      if (!mounted) return;

      setState(() {
        _ortomosaicoPath = destino.path;
        _ortomosaicoTileProvider = tileProvider;
        _showOrtomosaico = true;
      });

      _forcarAtualizacaoMapa();

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Ortomosaico importado',
        mensagem: 'O MBTiles foi carregado com sucesso no mapa geral.',
      );
    } catch (e) {
      if (!mounted) return;

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Erro ao importar ortomosaico',
        mensagem: 'Não foi possível importar o MBTiles.\n\nDetalhes: $e',
      );
    }
  }

  void _removerOrtomosaico() {
    setState(() {
      _showOrtomosaico = false;
      _ortomosaicoPath = null;
      _ortomosaicoTileProvider = null;
    });
  }

  Widget _layerSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    IconData icon = Icons.layers,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            color: onChanged == null ? Colors.grey : const Color(0xFF1B5E20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: onChanged == null ? Colors.grey : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: onChanged == null ? Colors.grey : null,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Future<void> _abrirControleCamadas() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Camadas do mapa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Mapa base',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment<String>(
                        value: 'osm',
                        icon: Icon(Icons.map),
                        label: Text('Mapa'),
                      ),
                      ButtonSegment<String>(
                        value: 'satellite',
                        icon: Icon(Icons.satellite_alt),
                        label: Text('Satélite'),
                      ),
                    ],
                    selected: {_mapaBase},
                    onSelectionChanged: (values) {
                      final selected = values.first;

                      setState(() {
                        _mapaBase = selected;
                      });

                      setModalState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  _layerSwitch(
                    title: 'Lotes vetorizados pelo técnico',
                    subtitle: 'Polígonos importados da base cartográfica',
                    value: _showLotesTecnicos,
                    icon: Icons.engineering_rounded,
                    onChanged: (value) {
                      setState(() => _showLotesTecnicos = value);
                      setModalState(() {});
                    },
                  ),
                  _layerSwitch(
                    title: 'Lotes vetorizados pelo cidadão',
                    subtitle: 'Polígonos produzidos na vetorização assistida',
                    value: _showLotesCidadaos,
                    icon: Icons.person_pin_circle_rounded,
                    onChanged: (value) {
                      setState(() => _showLotesCidadaos = value);
                      setModalState(() {});
                    },
                  ),
                  _layerSwitch(
                    title: 'Identificação dos lotes',
                    subtitle: 'Códigos e status clicáveis no mapa',
                    value: _showLabels,
                    icon: Icons.label,
                    onChanged: (value) {
                      setState(() => _showLabels = value);
                      setModalState(() {});
                    },
                  ),
                  _layerSwitch(
                    title: 'Minha localização',
                    subtitle: 'Posição GPS atual do cadastrador',
                    value: _showGps,
                    icon: Icons.my_location,
                    onChanged: (value) {
                      setState(() => _showGps = value);
                      setModalState(() {});
                    },
                  ),
                  _layerSwitch(
                    title: 'Ortomosaico',
                    subtitle: _ortomosaicoPath == null
                        ? 'Nenhum MBTiles importado'
                        : 'MBTiles local carregado',
                    value: _showOrtomosaico,
                    icon: Icons.image,
                    onChanged: _ortomosaicoTileProvider == null
                        ? null
                        : (value) {
                            setState(() => _showOrtomosaico = value);
                            setModalState(() {});
                          },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await _importarOrtomosaicoMbtiles();
                          },
                          icon: const Icon(Icons.upload_file),
                          label: Text(
                            _ortomosaicoPath == null
                                ? 'IMPORTAR MBTILES'
                                : 'SUBSTITUIR MBTILES',
                          ),
                        ),
                      ),
                      if (_ortomosaicoPath != null) ...[
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          tooltip: 'Remover ortomosaico',
                          onPressed: () {
                            _removerOrtomosaico();
                            setModalState(() {});
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  _legendaMapa(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _legendaMapa() {
    final itens = [
      ['Completo', Colors.green],
      ['Sem selagem', Colors.orange],
      ['Sem cadastro social', Colors.red],
      ['Sem cadastro físico', Colors.deepPurple],
      ['Sem documentos', Colors.blueGrey],
      ['Requer RTK/Revisão', Colors.redAccent],
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Legenda',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...itens.map((item) {
              final label = item[0] as String;
              final color = item[1] as Color;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.30),
                        border: Border.all(color: color, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _abrirResumoLote(Map<String, Object?> lote) {
    final status = _statusLote(lote);
    final color = _statusColor(status);

    final codigoLote = lote['codigo_lote']?.toString() ?? 'não informado';
    final projeto = lote['projeto_nome']?.toString() ?? 'não informado';
    final bairro = lote['projeto_bairro']?.toString() ?? 'não informado';
    final municipio = lote['projeto_municipio']?.toString() ?? 'não informado';

    final codigosSelagem =
        lote['codigos_selagem']?.toString().trim().isEmpty ?? true
            ? 'não vinculada'
            : lote['codigos_selagem'].toString();

    final responsaveis =
        lote['nomes_responsaveis']?.toString().trim().isEmpty ?? true
            ? 'não informado'
            : lote['nomes_responsaveis'].toString();

    final cpfs = lote['cpfs_responsaveis']?.toString().trim().isEmpty ?? true
        ? 'não informado'
        : lote['cpfs_responsaveis'].toString();

    final telefones =
        lote['telefones_responsaveis']?.toString().trim().isEmpty ?? true
            ? 'não informado'
            : lote['telefones_responsaveis'].toString();

    final totalSelagens = _intFromDb(lote['total_selagens']);
    final totalFisicos = _intFromDb(lote['total_cadastros_fisicos']);
    final totalSociais = _intFromDb(lote['total_cadastros_sociais']);
    final totalDocumentos = _intFromDb(lote['total_documentos']);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Lote $codigoLote',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      _statusLabel(status),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: color,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _infoLinha('Projeto', projeto),
              _infoLinha('Município', municipio),
              _infoLinha('Bairro', bairro),
              _infoLinha('Quadra', lote['quadra']?.toString() ?? '-'),
              _infoLinha('Área m²', lote['area_m2']?.toString() ?? '-'),
              _infoLinha('Perímetro m', lote['perimetro_m']?.toString() ?? '-'),
              const Divider(height: 24),
              _infoLinha('Selagem', codigosSelagem),
              _infoLinha('Responsável', responsaveis),
              _infoLinha('CPF', cpfs),
              _infoLinha('Telefone', telefones),
              const Divider(height: 24),
              _infoLinha('Total de selagens', totalSelagens.toString()),
              _infoLinha('Cadastro físico', totalFisicos > 0 ? 'Sim' : 'Não'),
              _infoLinha('Cadastro social', totalSociais > 0 ? 'Sim' : 'Não'),
              _infoLinha('Documentos/fotos', totalDocumentos.toString()),
              const SizedBox(height: 16),
              Card(
                color: color.withOpacity(0.10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _acaoRecomendada(status),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoLinha(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 135,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _acaoRecomendada(String status) {
    switch (status) {
      case 'completo':
        return 'Cadastro completo. Lote apto para conferência final.';
      case 'sem_selagem':
        return 'Ação recomendada: realizar a selagem do imóvel em campo.';
      case 'sem_social':
        return 'Ação recomendada: realizar cadastro social do responsável familiar.';
      case 'sem_fisico':
        return 'Ação recomendada: realizar cadastro físico do imóvel.';
      case 'sem_documentos':
        return 'Ação recomendada: anexar documentos e fotos ao dossiê.';
      case 'requer_rtk':
        return 'Ação recomendada: encaminhar para validação RTK/topográfica.';
      default:
        return 'Ação recomendada: revisar as informações do lote.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF7),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, Object?>>>(
          future: _futureMapa,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _MapLoadingView();
            }

            final lotes = snapshot.data ?? [];

            if (lotes.isEmpty) {
              return _EmptyMapView(
                onBack: () => Navigator.of(context).pop(),
                onImportMbtiles: _importarOrtomosaicoMbtiles,
              );
            }

            final center = _centroGeral(lotes);

            final lotesComGeometria = lotes.where((lote) {
              return _extrairPontosDoGeoJson(
                    lote['geometria_geojson']?.toString(),
                  ).length >=
                  3;
            }).toList();

            final lotesTecnicos = lotesComGeometria.where((lote) {
              return lote['origem_vetorizacao']?.toString() == 'tecnico';
            }).toList();

            final lotesCidadaos = lotesComGeometria.where((lote) {
              return lote['origem_vetorizacao']?.toString() == 'cidadao';
            }).toList();

            final polygonsTecnicos = _showLotesTecnicos
                ? lotesTecnicos.map(_criarPoligono).toList()
                : <Polygon>[];

            final polygonsCidadaos = _showLotesCidadaos
                ? lotesCidadaos.map(_criarPoligono).toList()
                : <Polygon>[];

            final labels = _showLabels
                ? [
                    if (_showLotesTecnicos) ...lotesTecnicos.map(_criarLabel),
                    if (_showLotesCidadaos) ...lotesCidadaos.map(_criarLabel),
                  ]
                : <Marker>[];

            final markers = <Marker>[
              ...labels,
              if (_showGps && _posicaoAtual != null)
                Marker(
                  point: _posicaoAtual!,
                  width: 52,
                  height: 52,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.15),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 34,
                      ),
                    ),
                  ),
                ),
            ];

            final totalCompletos =
                lotes.where((lote) => _statusLote(lote) == 'completo').length;

            final totalPendencias = lotes.length - totalCompletos;

            return Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 18,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    if (_mapaBase == 'osm')
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.biome_reurb',
                      ),
                    if (_mapaBase == 'satellite')
                      TileLayer(
                        urlTemplate:
                            'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                        userAgentPackageName: 'com.example.biome_reurb',
                      ),
                    if (_showOrtomosaico && _ortomosaicoTileProvider != null)
                      TileLayer(
                        tileProvider: _ortomosaicoTileProvider!,
                        userAgentPackageName: 'com.example.biome_reurb',
                        maxZoom: 22,
                      ),
                    if (polygonsTecnicos.isNotEmpty)
                      PolygonLayer(
                        polygons: polygonsTecnicos,
                      ),
                    if (polygonsCidadaos.isNotEmpty)
                      PolygonLayer(
                        polygons: polygonsCidadaos,
                      ),
                    if (markers.isNotEmpty)
                      MarkerLayer(
                        markers: markers,
                      ),
                  ],
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  top: 14,
                  child: _PremiumMapHeader(
                    lotes: lotes.length,
                    completos: totalCompletos,
                    pendencias: totalPendencias,
                    mapaBase: _mapaBase,
                    ortomosaicoAtivo:
                        _showOrtomosaico && _ortomosaicoTileProvider != null,
                    onBack: () => Navigator.of(context).pop(),
                    onRefresh: () {
                      setState(() {
                        _carregarMapa();
                      });
                    },
                    onLayers: _abrirControleCamadas,
                  ),
                ),
                Positioned(
                  right: 14,
                  top: 168,
                  child: Column(
                    children: [
                      _MapFloatingButton(
                        icon: Icons.my_location_rounded,
                        label: 'GPS',
                        onTap: _centralizarGps,
                      ),
                      const SizedBox(height: 10),
                      _MapFloatingButton(
                        icon: Icons.layers_rounded,
                        label: 'Camadas',
                        onTap: _abrirControleCamadas,
                      ),
                      const SizedBox(height: 10),
                      _MapFloatingButton(
                        icon: Icons.image_rounded,
                        label: 'Orto',
                        active: _showOrtomosaico &&
                            _ortomosaicoTileProvider != null,
                        onTap: _abrirControleCamadas,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 18,
                  child: _MapBottomPanel(
                    lotes: lotes.length,
                    completos: totalCompletos,
                    pendencias: totalPendencias,
                    showLotes: _showLotesTecnicos || _showLotesCidadaos,
                    showLabels: _showLabels,
                    showGps: _showGps,
                    onLayers: _abrirControleCamadas,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PremiumMapHeader extends StatelessWidget {
  final int lotes;
  final int completos;
  final int pendencias;
  final String mapaBase;
  final bool ortomosaicoAtivo;
  final VoidCallback onBack;
  final VoidCallback onRefresh;
  final VoidCallback onLayers;

  const _PremiumMapHeader({
    required this.lotes,
    required this.completos,
    required this.pendencias,
    required this.mapaBase,
    required this.ortomosaicoAtivo,
    required this.onBack,
    required this.onRefresh,
    required this.onLayers,
  });

  @override
  Widget build(BuildContext context) {
    final baseLabel = mapaBase == 'satellite' ? 'Satélite' : 'Mapa';

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFE2ECE6),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22063D1C),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _HeaderIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: onBack,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mapa da Coleta',
                      style: TextStyle(
                        color: Color(0xFF10251A),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Lotes, selagens, GPS e ortomosaico',
                      style: TextStyle(
                        color: Color(0xFF68756D),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _HeaderIconButton(
                icon: Icons.refresh_rounded,
                onTap: onRefresh,
              ),
              const SizedBox(width: 8),
              _HeaderIconButton(
                icon: Icons.layers_rounded,
                onTap: onLayers,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MiniStatusChip(
                  label: 'Lotes',
                  value: lotes.toString(),
                  color: const Color(0xFF0B5D2A),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniStatusChip(
                  label: 'Completos',
                  value: completos.toString(),
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniStatusChip(
                  label: 'Pendências',
                  value: pendencias.toString(),
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _LayerBadge(
                icon: Icons.map_rounded,
                label: baseLabel,
              ),
              const SizedBox(width: 8),
              _LayerBadge(
                icon: Icons.image_rounded,
                label: ortomosaicoAtivo ? 'Ortomosaico ativo' : 'Sem orto',
                active: ortomosaicoAtivo,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF3F8F5),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: const Color(0xFF0B5D2A),
          ),
        ),
      ),
    );
  }
}

class _MiniStatusChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStatusChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: color.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF68756D),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LayerBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _LayerBadge({
    required this.icon,
    required this.label,
    this.active = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF0B5D2A) : const Color(0xFF8B9890);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: color,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapFloatingButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _MapFloatingButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF0B5D2A) : const Color(0xFF10251A);

    return Material(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(22),
      elevation: 5,
      shadowColor: const Color(0x26063D1C),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          width: 76,
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: active ? const Color(0xFFBBDDC5) : const Color(0xFFE2ECE6),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapBottomPanel extends StatelessWidget {
  final int lotes;
  final int completos;
  final int pendencias;
  final bool showLotes;
  final bool showLabels;
  final bool showGps;
  final VoidCallback onLayers;

  const _MapBottomPanel({
    required this.lotes,
    required this.completos,
    required this.pendencias,
    required this.showLotes,
    required this.showLabels,
    required this.showGps,
    required this.onLayers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFE2ECE6),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26063D1C),
            blurRadius: 30,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Resumo do mapa',
                  style: TextStyle(
                    color: Color(0xFF10251A),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onLayers,
                icon: const Icon(Icons.tune_rounded, size: 18),
                label: const Text('Camadas'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0B5D2A),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _BottomMetric(
                  icon: Icons.crop_square_rounded,
                  label: 'Lotes',
                  value: lotes.toString(),
                  color: const Color(0xFF0B5D2A),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BottomMetric(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'OK',
                  value: completos.toString(),
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BottomMetric(
                  icon: Icons.warning_amber_rounded,
                  label: 'Pend.',
                  value: pendencias.toString(),
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _VisibilityPill(
                label: 'Lotes',
                active: showLotes,
              ),
              const SizedBox(width: 7),
              _VisibilityPill(
                label: 'Labels',
                active: showLabels,
              ),
              const SizedBox(width: 7),
              _VisibilityPill(
                label: 'GPS',
                active: showGps,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _BottomMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 21,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF68756D),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VisibilityPill extends StatelessWidget {
  final String label;
  final bool active;

  const _VisibilityPill({
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE8F5EC) : const Color(0xFFF1F4F2),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          active ? '$label ativo' : '$label off',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? const Color(0xFF0B5D2A) : const Color(0xFF8B9890),
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _MapLoadingView extends StatelessWidget {
  const _MapLoadingView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6FAF7),
      padding: const EdgeInsets.all(22),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x16063D1C),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                minHeight: 6,
                borderRadius: BorderRadius.all(Radius.circular(99)),
              ),
              SizedBox(height: 18),
              Text(
                'Carregando mapa geral da coleta...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF68756D),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyMapView extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onImportMbtiles;

  const _EmptyMapView({
    required this.onBack,
    required this.onImportMbtiles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6FAF7),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              _HeaderIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: onBack,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Mapa da Coleta',
                  style: TextStyle(
                    color: Color(0xFF10251A),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14063D1C),
                  blurRadius: 26,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5EC),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: const Icon(
                    Icons.map_outlined,
                    color: Color(0xFF0B5D2A),
                    size: 42,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Nenhum lote preliminar importado',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF10251A),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Importe a base cartográfica antes de visualizar o mapa geral da coleta.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF68756D),
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: onImportMbtiles,
                    icon: const Icon(Icons.image_rounded),
                    label: const Text('Importar ortomosaico MBTiles'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B5D2A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
