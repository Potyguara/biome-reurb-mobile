// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/widgets/loading_dialog.dart';
import '../../../data/local/database_provider.dart';
import '../models/lote_mapa_result.dart';

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_map_mbtiles/flutter_map_mbtiles.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LoteMapSelectorPage extends ConsumerStatefulWidget {
  final String projetoId;

  const LoteMapSelectorPage({
    super.key,
    required this.projetoId,
  });

  @override
  ConsumerState<LoteMapSelectorPage> createState() =>
      _LoteMapSelectorPageState();
}

class _LoteMapSelectorPageState extends ConsumerState<LoteMapSelectorPage> {
  final MapController _mapController = MapController();

  late Future<List<Map<String, Object?>>> _futureLotes;
  String? _ortomosaicoPath;
  MbTilesTileProvider? _ortomosaicoTileProvider;

  LatLng? _posicaoAtual;
  Map<String, Object?>? _loteSelecionado;

  String _mapaBase = 'osm';

  bool _showLotes = true;
  bool _showLabelsLotes = true;
  bool _showGps = true;
  bool _showOrtomosaico = false;

  String _statusVinculoGeografico = 'confirmado';
  bool _necessitaValidacaoRtk = false;

  final _observacaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarLotes();
    _capturarPosicaoInicial();
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _importarOrtomosaicoMbtiles() async {
    LoadingDialog.show(
      context,
      title: 'Importando ortomosaico',
      message: 'Selecione o arquivo MBTiles gerado a partir do ortomosaico...',
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
        p.join(appDir.path, 'ortomosaicos'),
      );

      if (!await ortoDir.exists()) {
        await ortoDir.create(recursive: true);
      }

      final destinoPath = p.join(
        ortoDir.path,
        'ortomosaico_${widget.projetoId}_${DateTime.now().millisecondsSinceEpoch}.mbtiles',
      );

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

      LoadingDialog.hide(context);

      await _mostrarAviso(
        titulo: 'Ortomosaico importado',
        mensagem: 'O arquivo MBTiles foi importado com sucesso.\n\n'
            'Caminho local:\n${destino.path}',
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

  void _removerOrtomosaicoDaSessao() {
    setState(() {
      _showOrtomosaico = false;
      _ortomosaicoPath = null;
      _ortomosaicoTileProvider = null;
    });
  }

  void _carregarLotes() {
    final db = ref.read(appDatabaseProvider);
    _futureLotes = db.listarLotesPreliminaresPorProjeto(widget.projetoId);
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      title: 'Lotes preliminares',
                      subtitle: 'Polígonos importados do KML/GeoJSON',
                      value: _showLotes,
                      icon: Icons.crop_square,
                      onChanged: (value) {
                        setState(() => _showLotes = value);
                        setModalState(() {});
                      },
                    ),
                    _layerSwitch(
                      title: 'Códigos dos lotes',
                      subtitle: 'Rótulos clicáveis para seleção do lote',
                      value: _showLabelsLotes,
                      icon: Icons.label,
                      onChanged: (value) {
                        setState(() => _showLabelsLotes = value);
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
                              _removerOrtomosaicoDaSessao();
                              setModalState(() {});
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _capturarPosicaoInicial() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return;
      }

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

      _mapController.move(
        LatLng(position.latitude, position.longitude),
        19,
      );
    } catch (_) {
      // A tela continua funcionando sem GPS.
    }
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

  double? _toDouble(Object? value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString().replaceAll(',', '.'));
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

  LatLng _centroGeralDosLotes(List<Map<String, Object?>> lotes) {
    final todosPontos = <LatLng>[];

    for (final lote in lotes) {
      todosPontos.addAll(
        _extrairPontosDoGeoJson(
          lote['geometria_geojson']?.toString(),
        ),
      );
    }

    if (_posicaoAtual != null) {
      return _posicaoAtual!;
    }

    if (todosPontos.isEmpty) {
      return const LatLng(0.034, -51.069);
    }

    return _centroDosPontos(todosPontos);
  }

  Polygon _criarPoligono(Map<String, Object?> lote) {
    final pontos = _extrairPontosDoGeoJson(
      lote['geometria_geojson']?.toString(),
    );

    final selecionado =
        lote['id']?.toString() == _loteSelecionado?['id']?.toString();

    return Polygon(
      points: pontos,
      color: selecionado
          ? Colors.green.withOpacity(0.35)
          : Colors.orange.withOpacity(0.20),
      borderColor: selecionado ? Colors.green.shade900 : Colors.deepOrange,
      borderStrokeWidth: selecionado ? 4 : 2,
    );
  }

  Marker _criarLabelLote(Map<String, Object?> lote) {
    final pontos = _extrairPontosDoGeoJson(
      lote['geometria_geojson']?.toString(),
    );

    final centro = _centroDosPontos(pontos);

    return Marker(
      point: centro,
      width: 90,
      height: 32,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _loteSelecionado = lote;
            _statusVinculoGeografico = 'confirmado';
            _necessitaValidacaoRtk = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.90),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.green.shade900,
              width: 1,
            ),
          ),
          child: Text(
            lote['codigo_lote']?.toString() ?? 'Lote',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarSelecao() async {
    final lote = _loteSelecionado;

    if (lote == null) {
      await _mostrarAviso(
        titulo: 'Lote obrigatório',
        mensagem: 'Toque em um lote no mapa antes de confirmar.',
      );
      return;
    }

    final result = LoteMapaResult(
      lotePreliminarId: lote['id'].toString(),
      codigoLotePreliminar: lote['codigo_lote']?.toString() ?? '',
      statusVinculoGeografico: _statusVinculoGeografico,
      necessitaValidacaoRtk: _necessitaValidacaoRtk,
      observacaoGeoespacial: _observacaoController.text.trim().isEmpty
          ? null
          : _observacaoController.text.trim(),
    );

    Navigator.of(context).pop(result);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Lote no Mapa'),
        actions: [
          IconButton(
            tooltip: 'Camadas',
            onPressed: _abrirControleCamadas,
            icon: const Icon(Icons.layers),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, Object?>>>(
        future: _futureLotes,
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
                      Text('Carregando lotes no mapa...'),
                    ],
                  ),
                ),
              ),
            );
          }

          final lotes = snapshot.data ?? [];

          if (lotes.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Nenhum lote preliminar importado para este projeto.',
                  ),
                ),
              ),
            );
          }

          final center = _centroGeralDosLotes(lotes);

          final polygons = _showLotes
              ? lotes
                  .where((lote) =>
                      _extrairPontosDoGeoJson(
                        lote['geometria_geojson']?.toString(),
                      ).length >=
                      3)
                  .map(_criarPoligono)
                  .toList()
              : <Polygon>[];

          final labels = _showLabelsLotes
              ? lotes
                  .where((lote) =>
                      _extrairPontosDoGeoJson(
                        lote['geometria_geojson']?.toString(),
                      ).length >=
                      3)
                  .map(_criarLabelLote)
                  .toList()
              : <Marker>[];

          final markers = <Marker>[
            ...labels,
            if (_showGps && _posicaoAtual != null)
              Marker(
                point: _posicaoAtual!,
                width: 48,
                height: 48,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 36,
                ),
              ),
          ];

          return Column(
            children: [
              Expanded(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 19,
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
                    if (_showLotes)
                      PolygonLayer(
                        polygons: polygons,
                      ),
                    if (markers.isNotEmpty)
                      MarkerLayer(
                        markers: markers,
                      ),
                  ],
                ),
              ),
              Material(
                color: Colors.white,
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _loteSelecionado == null
                            ? 'Toque no código do lote no mapa para selecionar.'
                            : 'Lote selecionado: ${_loteSelecionado!['codigo_lote']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _statusVinculoGeografico,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Status do vínculo',
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
                      const SizedBox(height: 8),

                      // Substitui o SwitchListTile para não gerar erro com ListTile.
                      Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Necessita validação RTK?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 2),
                                Text('Marque quando houver dúvida no vínculo.'),
                              ],
                            ),
                          ),
                          Switch(
                            value: _necessitaValidacaoRtk,
                            onChanged: (value) {
                              setState(() => _necessitaValidacaoRtk = value);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _observacaoController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Observação geoespacial',
                          prefixIcon: Icon(Icons.edit_location_alt),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _centralizarGps,
                              icon: const Icon(Icons.my_location),
                              label: const Text('GPS'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _confirmarSelecao,
                              icon: const Icon(Icons.check),
                              label: const Text('CONFIRMAR'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
