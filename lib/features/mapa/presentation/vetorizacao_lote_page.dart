// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_mbtiles/flutter_map_mbtiles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../../../core/widgets/loading_dialog.dart';
import '../../../data/local/database_provider.dart';
import '../data/lot_geometry_sync_database.dart';
import '../data/lot_geometry_sync_repository.dart';
import 'package:uuid/uuid.dart';

class VetorizacaoLotePage extends ConsumerStatefulWidget {
  const VetorizacaoLotePage({super.key});

  @override
  ConsumerState<VetorizacaoLotePage> createState() =>
      _VetorizacaoLotePageState();
}

class _VetorizacaoLotePageState extends ConsumerState<VetorizacaoLotePage> {
  final MapController _mapController = MapController();

  final List<LatLng> _vertices = [];

  String _vetorizacaoId = const Uuid().v4();

  String? _projetoId;
  String? _selagemId;
  String? _cadastroSocialId;
  String? _codigoSelo;
  String? _codigoLote;

  LatLng _center = const LatLng(0.034, -51.069);

  MbTilesTileProvider? _ortomosaicoTileProvider;
  String? _ortomosaicoNome;
  LatLngBounds? _ortomosaicoBounds;

  bool _loading = true;
  bool _loadingGps = false;
  bool _mostrarVertices = true;
  bool _mostrarSegmentos = true;
  bool _mostrarPoligono = true;
  bool _painelExpandido = true;
  bool _arrastandoVertice = false;

  int? _selectedVertexIndex;

  static const Color _primary = Color(0xFF0B5D2A);
  static const Color _surface = Color(0xFFF6FAF7);

  static const double _snapToleranceMeters = 0.20;

  final GlobalKey _mapKey = GlobalKey();
  final TextEditingController _codigoSeloController = TextEditingController();
  final TextEditingController _codigoLoteController = TextEditingController();

  List<Map<String, Object?>> _selagensDisponiveis = [];
  String? _selagemSelecionadaId;

  List<Map<String, Object?>> _vetorizacoesSalvas = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inicializarTela();
    });
  }

  @override
  void dispose() {
    _codigoSeloController.dispose();
    _codigoLoteController.dispose();
    super.dispose();
  }

  LatLng _aplicarSnap(LatLng point) {
    final verticesSalvos = <LatLng>[];

    for (final row in _vetorizacoesSalvas) {
      final id = row['id']?.toString();

      // Evita snap no próprio lote atual.
      if (id == _vetorizacaoId) continue;

      final geojson = row['geometria_geojson']?.toString();

      if (geojson == null || geojson.trim().isEmpty) continue;

      final vertices = _verticesFromGeoJson(geojson);

      if (vertices.length >= 3) {
        verticesSalvos.addAll(vertices);
      }
    }

    if (verticesSalvos.isEmpty) return point;

    final snapVertice = _snapEmVertice(point, verticesSalvos);

    if (snapVertice != null) {
      return snapVertice;
    }

    final snapSegmento = _snapEmSegmento(point);

    if (snapSegmento != null) {
      return snapSegmento;
    }

    return point;
  }

  LatLng? _snapEmVertice(LatLng point, List<LatLng> verticesSalvos) {
    const distance = Distance();

    LatLng? bestPoint;
    var bestDistance = double.infinity;

    for (final candidate in verticesSalvos) {
      final d = distance.as(
        LengthUnit.Meter,
        point,
        candidate,
      );

      if (d < bestDistance) {
        bestDistance = d;
        bestPoint = candidate;
      }
    }

    if (bestPoint != null && bestDistance <= _snapToleranceMeters) {
      return bestPoint;
    }

    return null;
  }

  LatLng? _snapEmSegmento(LatLng point) {
    LatLng? bestPoint;
    var bestDistance = double.infinity;

    for (final row in _vetorizacoesSalvas) {
      final id = row['id']?.toString();

      // Evita snap no próprio lote atual.
      if (id == _vetorizacaoId) continue;

      final geojson = row['geometria_geojson']?.toString();

      if (geojson == null || geojson.trim().isEmpty) continue;

      final vertices = _verticesFromGeoJson(geojson);

      if (vertices.length < 3) continue;

      for (var i = 0; i < vertices.length; i++) {
        final a = vertices[i];
        final b = vertices[(i + 1) % vertices.length];

        final projected = _projetarPontoNoSegmento(
          point: point,
          a: a,
          b: b,
        );

        final distance = _distanciaMetros(point, projected);

        if (distance < bestDistance) {
          bestDistance = distance;
          bestPoint = projected;
        }
      }
    }

    if (bestPoint != null && bestDistance <= _snapToleranceMeters) {
      return bestPoint;
    }

    return null;
  }

  LatLng _projetarPontoNoSegmento({
    required LatLng point,
    required LatLng a,
    required LatLng b,
  }) {
    final originLat = point.latitude * math.pi / 180.0;
    const earthRadius = 6378137.0;

    math.Point<double> toXY(LatLng p0) {
      final lat = p0.latitude * math.pi / 180.0;
      final lon = p0.longitude * math.pi / 180.0;

      final originLon = point.longitude * math.pi / 180.0;

      final x = earthRadius * (lon - originLon) * math.cos(originLat);
      final y = earthRadius * (lat - originLat);

      return math.Point<double>(x, y);
    }

    LatLng fromXY(math.Point<double> xy) {
      final originLon = point.longitude * math.pi / 180.0;

      final lat = point.latitude + (xy.y / earthRadius) * 180.0 / math.pi;
      final lon = point.longitude +
          (xy.x / (earthRadius * math.cos(originLat))) * 180.0 / math.pi;

      // originLon fica aqui apenas para manter a referência matemática explícita.
      // ignore: unused_local_variable
      final _ = originLon;

      return LatLng(lat, lon);
    }

    final p = toXY(point);
    final pa = toXY(a);
    final pb = toXY(b);

    final ab = math.Point<double>(
      pb.x - pa.x,
      pb.y - pa.y,
    );

    final ap = math.Point<double>(
      p.x - pa.x,
      p.y - pa.y,
    );

    final ab2 = ab.x * ab.x + ab.y * ab.y;

    if (ab2 == 0) return a;

    var t = (ap.x * ab.x + ap.y * ab.y) / ab2;

    if (t < 0) t = 0;
    if (t > 1) t = 1;

    final projected = math.Point<double>(
      pa.x + ab.x * t,
      pa.y + ab.y * t,
    );

    return fromXY(projected);
  }

  double _distanciaMetros(LatLng a, LatLng b) {
    return _distanciaPlanaLocalM(a, b);
  }

  Future<void> _carregarVetorizacoesSalvasParaMapa() async {
    final db = ref.read(appDatabaseProvider);

    final rows = await db.listarVetorizacoesLoteCidadaoParaMapa();

    if (!mounted) return;

    setState(() {
      _vetorizacoesSalvas = rows;
    });
  }

  Future<void> _selecionarSelagemParaVetorizacao(String? selagemId) async {
    if (selagemId == null || selagemId.isEmpty) return;

    final item = _selagensDisponiveis.firstWhere(
      (row) => row['id']?.toString() == selagemId,
      orElse: () => <String, Object?>{},
    );

    if (item.isEmpty) return;

    final codigoSelo = item['codigo_selo']?.toString();
    final codigoLote = item['codigo_lote_preliminar']?.toString();
    final projetoId = item['projeto_id']?.toString();
    final cadastroSocialId = item['cadastro_social_id']?.toString();

    setState(() {
      _selagemSelecionadaId = selagemId;

      _selagemId = selagemId;
      _codigoSelo = codigoSelo;
      _codigoLote = codigoLote;
      _projetoId = projetoId;
      _cadastroSocialId = cadastroSocialId;

      _codigoSeloController.text = codigoSelo ?? '';
      _codigoLoteController.text = codigoLote ?? '';

      _vertices.clear();
      _selectedVertexIndex = null;
    });

    final db = ref.read(appDatabaseProvider);

    final row = await db.buscarVetorizacaoLoteCidadao(
      codigoSelo: codigoSelo,
      codigoLote: codigoLote,
    );

    if (!mounted) return;

    if (row != null) {
      final geometria = row['geometria_geojson']?.toString();

      if (geometria != null && geometria.trim().isNotEmpty) {
        final vertices = _verticesFromGeoJson(geometria);

        setState(() {
          _vertices
            ..clear()
            ..addAll(vertices);

          _vetorizacaoId = row['id']?.toString() ?? _vetorizacaoId;
        });

        await Future.delayed(const Duration(milliseconds: 250));

        if (mounted) {
          _zoomNoLote();
        }

        return;
      }
    }

    if (_ortomosaicoBounds != null) {
      _fitBounds(_ortomosaicoBounds!);
    }
  }

  Future<void> _carregarSelagensDisponiveis() async {
    final db = ref.read(appDatabaseProvider);

    final rows = await db.listarSelagensParaVinculoVetorizacao();

    if (!mounted) return;

    setState(() {
      _selagensDisponiveis = rows;

      if (_selagemId != null && _selagemId!.isNotEmpty) {
        final exists = rows.any(
          (item) => item['id']?.toString() == _selagemId,
        );

        if (exists) {
          _selagemSelecionadaId = _selagemId;
        }
      }
    });
  }

  bool _temSelagemVinculada() {
    final codigoSelo = _codigoSelo?.trim();
    final selagemId = _selagemSelecionadaId?.trim() ?? _selagemId?.trim();

    return (selagemId != null && selagemId.isNotEmpty) ||
        (codigoSelo != null && codigoSelo.isNotEmpty);
  }

  Future<File?> _arquivoOrtomosaicoPersistido() async {
    final appDir = await getApplicationDocumentsDirectory();

    final ortoDir = Directory(
      p.join(appDir.path, 'ortomosaicos_vetorizacao'),
    );

    if (!await ortoDir.exists()) {
      await ortoDir.create(recursive: true);
    }

    final file = File(
      p.join(ortoDir.path, 'ortomosaico_vetorizacao_atual.mbtiles'),
    );

    if (await file.exists()) {
      return file;
    }

    return null;
  }

  Future<void> _carregarOrtomosaicoPersistido() async {
    try {
      final file = await _arquivoOrtomosaicoPersistido();

      if (file == null) return;

      final bounds = _readMbTilesBounds(file.path);

      final tileProvider = MbTilesTileProvider.fromPath(
        path: file.path,
      );

      if (!mounted) return;

      setState(() {
        _ortomosaicoTileProvider = tileProvider;
        _ortomosaicoNome = p.basename(file.path);
        _ortomosaicoBounds = bounds;
      });

      _forcarAtualizacaoMapa();
    } catch (e) {
      debugPrint('Erro ao carregar ortomosaico persistido: $e');
    }
  }

  Future<void> _inicializarTela() async {
    _capturarArgumentos();

    await _carregarSelagensDisponiveis();
    await _carregarVetorizacaoSalva();
    await _carregarVetorizacoesSalvasParaMapa();
    await _carregarOrtomosaicoPersistido();

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    await Future.delayed(const Duration(milliseconds: 450));

    if (!mounted) return;

    if (_ortomosaicoBounds != null) {
      _fitBounds(_ortomosaicoBounds!);
      _forcarAtualizacaoMapa();
      return;
    }

    final boundsVetorizacoes = _boundsDasVetorizacoesSalvas();

    if (boundsVetorizacoes != null) {
      _fitBounds(boundsVetorizacoes);
      _forcarAtualizacaoMapa();
      return;
    }

    if (_vertices.length >= 3) {
      _zoomNoLote();
      _forcarAtualizacaoMapa();
      return;
    }

    await _centralizarGps(silent: true);
    _forcarAtualizacaoMapa();
  }

  List<Polygon> _polygonsVetorizacoesSalvas() {
    final polygons = <Polygon>[];

    for (final row in _vetorizacoesSalvas) {
      final id = row['id']?.toString();
      final geojson = row['geometria_geojson']?.toString();

      if (geojson == null || geojson.trim().isEmpty) continue;

      final vertices = _verticesFromGeoJson(geojson);

      if (vertices.length < 3) continue;

      final isCurrent = id == _vetorizacaoId;

      polygons.add(
        Polygon(
          points: vertices,
          color: isCurrent
              ? const Color(0xFF0B5D2A).withValues(alpha: 0.22)
              : Colors.orange.withValues(alpha: 0.20),
          borderColor: isCurrent ? const Color(0xFF0B5D2A) : Colors.orange,
          borderStrokeWidth: isCurrent ? 4 : 3,
        ),
      );
    }

    return polygons;
  }

  List<Marker> _labelsVetorizacoesSalvas() {
    final markers = <Marker>[];

    for (final row in _vetorizacoesSalvas) {
      final geojson = row['geometria_geojson']?.toString();

      if (geojson == null || geojson.trim().isEmpty) continue;

      final vertices = _verticesFromGeoJson(geojson);

      if (vertices.length < 3) continue;

      final codigoSelo = row['codigo_selo']?.toString();
      final codigoLote = row['codigo_lote']?.toString();

      final label = codigoLote?.isNotEmpty == true
          ? 'Lote $codigoLote'
          : codigoSelo?.isNotEmpty == true
              ? codigoSelo!
              : 'Vetorizado';

      markers.add(
        Marker(
          point: _centroide(vertices),
          width: 120,
          height: 34,
          child: _VetorizacaoLabel(
            text: label,
          ),
        ),
      );
    }

    return markers;
  }

  LatLng _centroide(List<LatLng> vertices) {
    var lat = 0.0;
    var lon = 0.0;

    for (final point in vertices) {
      lat += point.latitude;
      lon += point.longitude;
    }

    return LatLng(
      lat / vertices.length,
      lon / vertices.length,
    );
  }

  LatLngBounds? _boundsDasVetorizacoesSalvas() {
    final points = <LatLng>[];

    for (final row in _vetorizacoesSalvas) {
      final geojson = row['geometria_geojson']?.toString();

      if (geojson == null || geojson.trim().isEmpty) continue;

      final vertices = _verticesFromGeoJson(geojson);

      if (vertices.isNotEmpty) {
        points.addAll(vertices);
      }
    }

    if (points.isEmpty) return null;

    return LatLngBounds.fromPoints(points);
  }

  void _capturarArgumentos() {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is! Map) return;

    final id = args['id']?.toString();
    final projetoId = args['projeto_id']?.toString();
    final selagemId = args['selagem_id']?.toString();
    final cadastroSocialId = args['cadastro_social_id']?.toString();
    final codigoSelo = args['codigo_selo']?.toString();
    final codigoLote = args['codigo_lote']?.toString();

    if (id != null && id.trim().isNotEmpty) {
      _vetorizacaoId = id.trim();
    } else if (codigoSelo != null && codigoSelo.trim().isNotEmpty) {
      _vetorizacaoId = 'vetorizacao_${codigoSelo.trim()}';
    } else if (codigoLote != null && codigoLote.trim().isNotEmpty) {
      _vetorizacaoId = 'vetorizacao_lote_${codigoLote.trim()}';
    }

    _projetoId = projetoId;
    _selagemId = selagemId;
    _cadastroSocialId = cadastroSocialId;
    _codigoSelo = codigoSelo;
    _codigoLote = codigoLote;
    _codigoSeloController.text = _codigoSelo ?? '';
    _codigoLoteController.text = _codigoLote ?? '';
  }

  Future<void> _carregarVetorizacaoSalva() async {
    final db = ref.read(appDatabaseProvider);

    final row = await db.buscarVetorizacaoLoteCidadao(
      id: _vetorizacaoId,
      codigoSelo: _codigoSelo,
      codigoLote: _codigoLote,
    );

    if (row == null) return;

    final geometria = row['geometria_geojson']?.toString();

    if (geometria == null || geometria.trim().isEmpty) return;

    final vertices = _verticesFromGeoJson(geometria);

    if (vertices.isEmpty) return;

    if (!mounted) return;

    setState(() {
      _vertices
        ..clear()
        ..addAll(vertices);

      _projetoId = row['projeto_id']?.toString();
      _selagemId = row['selagem_id']?.toString();
      _cadastroSocialId = row['cadastro_social_id']?.toString();
      _codigoSelo = row['codigo_selo']?.toString();
      _codigoLote = row['codigo_lote']?.toString();

      _selagemSelecionadaId = _selagemId;

      _codigoSeloController.text = _codigoSelo ?? '';
      _codigoLoteController.text = _codigoLote ?? '';
    });
  }

  List<LatLng> _verticesFromGeoJson(String value) {
    try {
      final decoded = jsonDecode(value);

      if (decoded is! Map) return [];

      if (decoded['type'] != 'Polygon') return [];

      final coordinates = decoded['coordinates'];

      if (coordinates is! List || coordinates.isEmpty) return [];

      final ring = coordinates.first;

      if (ring is! List) return [];

      final points = <LatLng>[];

      for (final item in ring) {
        if (item is! List || item.length < 2) continue;

        final lon = (item[0] as num).toDouble();
        final lat = (item[1] as num).toDouble();

        points.add(LatLng(lat, lon));
      }

      if (points.length >= 2 &&
          points.first.latitude == points.last.latitude &&
          points.first.longitude == points.last.longitude) {
        points.removeLast();
      }

      return points;
    } catch (_) {
      return [];
    }
  }

  String _toGeoJson() {
    final ring = _vertices.map((point) {
      return [
        point.longitude,
        point.latitude,
      ];
    }).toList();

    if (_vertices.length >= 3) {
      ring.add([
        _vertices.first.longitude,
        _vertices.first.latitude,
      ]);
    }

    return jsonEncode({
      'type': 'Polygon',
      'coordinates': [ring],
    });
  }

  Future<void> _centralizarGps({bool silent = false}) async {
    if (_loadingGps) return;

    if (!silent && mounted) {
      LoadingDialog.show(
        context,
        title: 'Capturando GPS',
        message: 'Atualizando sua posição no mapa...',
      );
    }

    try {
      setState(() {
        _loadingGps = true;
      });

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

      final nextCenter = LatLng(position.latitude, position.longitude);

      setState(() {
        _center = nextCenter;
      });

      _mapController.move(nextCenter, 20);
    } catch (e) {
      if (!mounted) return;

      if (!silent) {
        await _mostrarAviso(
          titulo: 'Erro no GPS',
          mensagem: 'Não foi possível capturar a localização.\n\nDetalhes: $e',
        );
      }
    } finally {
      if (!silent && mounted) {
        LoadingDialog.hide(context);
      }

      if (mounted) {
        setState(() {
          _loadingGps = false;
        });
      }
    }
  }

  void _forcarAtualizacaoMapa() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      try {
        final camera = _mapController.camera;
        _mapController.move(camera.center, camera.zoom);
      } catch (_) {
        // O mapa pode ainda não estar anexado ao controller no primeiro frame.
      }
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      try {
        final camera = _mapController.camera;
        _mapController.move(camera.center, camera.zoom);
      } catch (_) {}
    });
  }

  void _handleMapTap(LatLng point) {
    if (_ortomosaicoTileProvider == null) {
      _mostrarAviso(
        titulo: 'Ortomosaico obrigatório',
        mensagem:
            'Importe o ortomosaico MBTiles antes de iniciar a vetorização do lote.',
      );
      return;
    }

    final snappedPoint = _aplicarSnap(point);

    setState(() {
      _vertices.add(snappedPoint);
      _selectedVertexIndex = _vertices.length - 1;
    });
  }

  void _selecionarVertice(int index) {
    setState(() {
      _selectedVertexIndex = index;
    });
  }

  void _atualizarVertice(int index, LatLng point) {
    if (index < 0 || index >= _vertices.length) return;

    setState(() {
      _vertices[index] = point;
      _selectedVertexIndex = index;
    });
  }

  void _excluirUltimoVertice() {
    if (_vertices.isEmpty) return;

    setState(() {
      _vertices.removeLast();

      if (_selectedVertexIndex != null &&
          _selectedVertexIndex! >= _vertices.length) {
        _selectedVertexIndex = null;
      }
    });
  }

  Future<void> _limparVetorizacao() async {
    if (_vertices.isEmpty) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Limpar vetorização'),
          content: const Text(
            'Deseja remover todos os vértices desenhados neste lote?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Limpar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    setState(() {
      _vertices.clear();
      _selectedVertexIndex = null;
    });
  }

  Future<void> _importarOrtomosaicoMbtiles() async {
    LoadingDialog.show(
      context,
      title: 'Importar ortomosaico',
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

      final fileName = result.files.single.name;

      if (!fileName.toLowerCase().endsWith('.mbtiles')) {
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

      final bounds = _readMbTilesBounds(destino.path);

      final tileProvider = MbTilesTileProvider.fromPath(
        path: destino.path,
      );

      if (!mounted) return;

      setState(() {
        _ortomosaicoTileProvider = tileProvider;
        _forcarAtualizacaoMapa();
        _ortomosaicoNome = fileName;
        _ortomosaicoBounds = bounds;
      });

      LoadingDialog.hide(context);

      await Future.delayed(const Duration(milliseconds: 250));

      if (!mounted) return;

      if (_vertices.length >= 3) {
        _zoomNoLote();
      } else if (bounds != null) {
        _fitBounds(bounds);
      }

      await _mostrarAviso(
        titulo: 'Ortomosaico carregado',
        mensagem:
            'O ortomosaico foi carregado e será usado como base obrigatória da vetorização.',
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

  LatLngBounds? _readMbTilesBounds(String path) {
    try {
      final db = sqlite.sqlite3.open(path);

      final result = db.select(
        "SELECT value FROM metadata WHERE name = 'bounds' LIMIT 1",
      );

      if (result.isEmpty) {
        db.dispose();
        return null;
      }

      final raw = result.first['value']?.toString();

      db.dispose();

      if (raw == null || raw.trim().isEmpty) return null;

      final parts = raw.split(',').map((item) => double.parse(item)).toList();

      if (parts.length != 4) return null;

      final minLon = parts[0];
      final minLat = parts[1];
      final maxLon = parts[2];
      final maxLat = parts[3];

      return LatLngBounds(
        LatLng(minLat, minLon),
        LatLng(maxLat, maxLon),
      );
    } catch (_) {
      return null;
    }
  }

  Future<LotGeometrySyncResult> _sincronizarGeometriaAtual() async {
    final projectId = _projetoId;

    if (projectId == null || projectId.isEmpty) {
      return const LotGeometrySyncResult.empty();
    }

    final db = ref.read(appDatabaseProvider);

    await db.prepararVetorizacoesCidadaoParaSincronizacao(
      projectId: projectId,
    );

    return ref.read(lotGeometrySyncRepositoryProvider).synchronize(
          projectId: projectId,
          limit: 100,
          pullAfterPush: true,
        );
  }

  Future<void> _salvarRascunho() async {
    if (!_temSelagemVinculada()) {
      await _mostrarAviso(
        titulo: 'Selagem obrigatória',
        mensagem:
            'Selecione uma selagem cadastrada antes de salvar a vetorização do lote.',
      );
      return;
    }
    if (_vertices.length < 3) {
      await _mostrarAviso(
        titulo: 'Vetorização incompleta',
        mensagem:
            'Adicione pelo menos 3 pontos para formar o polígono do lote.',
      );
      return;
    }

    await _persistirVetorizacao(status: 'rascunho');
    final syncResult = await _sincronizarGeometriaAtual();
    await _carregarVetorizacoesSalvasParaMapa();

    await _mostrarAviso(
      titulo: 'Rascunho salvo',
      mensagem: syncResult.allAccepted
          ? 'A vetorização foi salva e sincronizada com o painel web.'
          : syncResult.offline
              ? 'A vetorização foi salva no aparelho e ficará aguardando conexão.'
              : 'A vetorização foi salva no aparelho e permanece na fila de sincronização.',
    );
  }

  Future<void> _concluirVetorizacao() async {
    if (!_temSelagemVinculada()) {
      await _mostrarAviso(
        titulo: 'Selagem obrigatória',
        mensagem:
            'Selecione uma selagem cadastrada antes de concluir a vetorização do lote.',
      );
      return;
    }
    if (_vertices.length < 3) {
      await _mostrarAviso(
        titulo: 'Vetorização incompleta',
        mensagem:
            'Para concluir, o lote precisa ter pelo menos 3 vértices desenhados.',
      );
      return;
    }

    final area = _areaM2();
    final perimetro = _perimetroM();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text('Concluir vetorização'),
          content: Text(
            'Confirma a pré-delimitação do lote?\n\n'
            'Área aproximada: ${_formatNumber(area)} m²\n'
            'Perímetro aproximado: ${_formatNumber(perimetro)} m\n\n'
            'Esta delimitação ficará salva no app e será exportada para validação na versão web.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Concluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    await _persistirVetorizacao(
      status: 'aguardando_validacao_tecnica',
    );
    final syncResult = await _sincronizarGeometriaAtual();
    await _carregarVetorizacoesSalvasParaMapa();

    if (!mounted) return;

    final syncMessage = syncResult.allAccepted
        ? 'A geometria foi enviada ao painel web.'
        : syncResult.offline
            ? 'A geometria ficou protegida no aparelho e será reenviada quando houver conexão.'
            : 'A geometria permanece na fila de sincronização.';

    await _mostrarAviso(
      titulo: 'Vetorização concluída',
      mensagem: 'A pré-delimitação do lote foi concluída.\n\n'
          'Status: aguardando validação técnica.\n\n'
          '$syncMessage',
    );
  }

  Future<void> _persistirVetorizacao({
    required String status,
  }) async {
    final codigoLoteInformado = _codigoLoteController.text.trim();

    _codigoLote =
        codigoLoteInformado.isEmpty ? _codigoLote : codigoLoteInformado;

    if (_selagemSelecionadaId != null && _selagemSelecionadaId!.isNotEmpty) {
      _selagemId = _selagemSelecionadaId;
    }

    final db = ref.read(appDatabaseProvider);

    await db.salvarVetorizacaoLoteCidadao(
      id: _vetorizacaoId,
      projetoId: _projetoId,
      selagemId: _selagemId,
      cadastroSocialId: _cadastroSocialId,
      codigoSelo: _codigoSelo,
      codigoLote: _codigoLote,
      geometriaGeojson: _toGeoJson(),
      areaM2: _areaM2(),
      perimetroM: _perimetroM(),
      origem: 'cidadao_assistido',
      status: status,
      observacoes:
          'Vetorização assistida pelo cidadão com apoio do cadastrador.',
      printPath: null,
    );
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
            borderRadius: BorderRadius.circular(20),
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

  double _perimetroM() {
    if (_vertices.length < 2) return 0;

    var total = 0.0;

    for (var i = 0; i < _vertices.length; i++) {
      final current = _vertices[i];
      final next = _vertices[(i + 1) % _vertices.length];

      total += _distanciaPlanaLocalM(current, next);
    }

    return total;
  }

  double _segmentoM(int index) {
    if (_vertices.length < 2) return 0;

    if (index < 0 || index >= _vertices.length) return 0;

    if (_vertices.length < 3 && index == _vertices.length - 1) {
      return 0;
    }

    final current = _vertices[index];
    final next = _vertices[(index + 1) % _vertices.length];

    return _distanciaPlanaLocalM(current, next);
  }

  double _distanciaPlanaLocalM(LatLng a, LatLng b) {
    const earthRadius = 6378137.0;

    final meanLat = ((a.latitude + b.latitude) / 2.0) * math.pi / 180.0;

    final dLat = (b.latitude - a.latitude) * math.pi / 180.0;
    final dLon = (b.longitude - a.longitude) * math.pi / 180.0;

    final dx = earthRadius * dLon * math.cos(meanLat);
    final dy = earthRadius * dLat;

    return math.sqrt((dx * dx) + (dy * dy));
  }

  double _areaM2() {
    if (_vertices.length < 3) return 0;

    final originLat = _vertices.first.latitude * math.pi / 180.0;
    final originLon = _vertices.first.longitude * math.pi / 180.0;

    const earthRadius = 6378137.0;

    final points = _vertices.map((point) {
      final lat = point.latitude * math.pi / 180.0;
      final lon = point.longitude * math.pi / 180.0;

      final x = earthRadius * (lon - originLon) * math.cos(originLat);
      final y = earthRadius * (lat - originLat);

      return math.Point<double>(x, y);
    }).toList();

    var area = 0.0;

    for (var i = 0; i < points.length; i++) {
      final current = points[i];
      final next = points[(i + 1) % points.length];

      area += current.x * next.y;
      area -= next.x * current.y;
    }

    return area.abs() / 2.0;
  }

  LatLng _midPoint(LatLng a, LatLng b) {
    return LatLng(
      (a.latitude + b.latitude) / 2,
      (a.longitude + b.longitude) / 2,
    );
  }

  String _formatNumber(double value, {int decimals = 2}) {
    final fixed = value.toStringAsFixed(decimals);
    final parts = fixed.split('.');

    final integer = parts[0];
    final decimal = parts.length > 1
        ? parts[1].padRight(decimals, '0')
        : ''.padRight(decimals, '0');

    final isNegative = integer.startsWith('-');
    final cleanInteger = isNegative ? integer.substring(1) : integer;

    final buffer = StringBuffer();

    for (var i = 0; i < cleanInteger.length; i++) {
      final reverseIndex = cleanInteger.length - i;

      buffer.write(cleanInteger[i]);

      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }

    final formattedInteger =
        isNegative ? '-${buffer.toString()}' : buffer.toString();

    if (decimals <= 0) {
      return formattedInteger;
    }

    return '$formattedInteger,$decimal';
  }

  LatLng? _globalOffsetToLatLng(Offset globalPosition) {
    final context = _mapKey.currentContext;

    if (context == null) return null;

    final renderBox = context.findRenderObject();

    if (renderBox is! RenderBox) return null;

    final local = renderBox.globalToLocal(globalPosition);
    final size = renderBox.size;

    final camera = _mapController.camera;
    final zoom = camera.zoom;
    final center = camera.center;

    final centerWorld = _latLngToWorldPixel(center, zoom);

    final dx = local.dx - size.width / 2;
    final dy = local.dy - size.height / 2;

    final targetWorld = math.Point<double>(
      centerWorld.x + dx,
      centerWorld.y + dy,
    );

    return _worldPixelToLatLng(targetWorld, zoom);
  }

  math.Point<double> _latLngToWorldPixel(LatLng point, double zoom) {
    final siny = math.sin(point.latitude * math.pi / 180.0).clamp(
          -0.9999,
          0.9999,
        );

    final scale = 256.0 * math.pow(2.0, zoom);

    final x = (point.longitude + 180.0) / 360.0 * scale;

    final y =
        (0.5 - math.log((1 + siny) / (1 - siny)) / (4.0 * math.pi)) * scale;

    return math.Point<double>(x, y);
  }

  LatLng _worldPixelToLatLng(math.Point<double> pixel, double zoom) {
    final scale = 256.0 * math.pow(2.0, zoom);

    final lng = pixel.x / scale * 360.0 - 180.0;

    final n = math.pi - 2.0 * math.pi * pixel.y / scale;

    final sinhN = (math.exp(n) - math.exp(-n)) / 2.0;
    final lat = 180.0 / math.pi * math.atan(sinhN);

    return LatLng(lat, lng);
  }

  void _arrastarVerticePorOffset(int index, Offset globalPosition) {
    if (index < 0 || index >= _vertices.length) return;

    final point = _globalOffsetToLatLng(globalPosition);

    if (point == null) return;

    final snappedPoint = _aplicarSnap(point);

    setState(() {
      _vertices[index] = snappedPoint;
      _selectedVertexIndex = index;
    });
  }

  List<Marker> _segmentMarkers() {
    if (!_mostrarSegmentos) return [];

    if (_vertices.length < 2) return [];

    final markers = <Marker>[];

    final count =
        _vertices.length >= 3 ? _vertices.length : _vertices.length - 1;

    for (var i = 0; i < count; i++) {
      final current = _vertices[i];
      final next = _vertices[(i + 1) % _vertices.length];

      final distance = _segmentoM(i);

      if (distance <= 0) continue;

      markers.add(
        Marker(
          point: _midPoint(current, next),
          width: 122,
          height: 36,
          child: _SegmentLabel(
            value: '${_formatNumber(distance, decimals: 3)} m',
          ),
        ),
      );
    }

    return markers;
  }

  List<Polyline> _edges() {
    if (_vertices.length < 2) return [];

    final points = [..._vertices];

    if (_vertices.length >= 3) {
      points.add(_vertices.first);
    }

    return [
      Polyline(
        points: points,
        strokeWidth: 4,
        color: _primary,
      ),
    ];
  }

  List<Polygon> _polygon() {
    if (!_mostrarPoligono) return [];

    if (_vertices.length < 3) return [];

    return [
      Polygon(
        points: _vertices,
        color: _primary.withValues(alpha: 0.22),
        borderColor: _primary,
        borderStrokeWidth: 3,
      ),
    ];
  }

  List<Marker> _vertexMarkers() {
    if (!_mostrarVertices) return [];

    return List.generate(_vertices.length, (index) {
      final point = _vertices[index];
      final selected = _selectedVertexIndex == index;

      return Marker(
        point: point,
        width: 76,
        height: 76,
        alignment: Alignment.center,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _selectedVertexIndex = index;
            });
          },
          onLongPressStart: (_) {
            setState(() {
              _arrastandoVertice = true;
              _selectedVertexIndex = index;
            });
          },
          onLongPressMoveUpdate: (details) {
            _arrastarVerticePorOffset(
              index,
              details.globalPosition,
            );
          },
          onLongPressEnd: (_) {
            setState(() {
              _arrastandoVertice = false;
              _selectedVertexIndex = index;
            });
          },
          onLongPressCancel: () {
            setState(() {
              _arrastandoVertice = false;
            });
          },
          child: _VertexHandle(
            index: index,
            selected: selected || _arrastandoVertice,
            dragging: _arrastandoVertice && selected,
          ),
        ),
      );
    });
  }

  void _fitBounds(LatLngBounds bounds) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.fromLTRB(44, 120, 44, 180),
          ),
        );
      } catch (_) {
        final center = bounds.center;
        _mapController.move(center, 19);
      }
    });
  }

  void _zoomNoLote() {
    if (_vertices.length < 3) return;

    final bounds = LatLngBounds.fromPoints(_vertices);

    _fitBounds(bounds);
  }

  void _abrirCamadas() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _LayersSheet(
          selagensDisponiveis: _selagensDisponiveis,
          selagemSelecionadaId: _selagemSelecionadaId,
          onSelagemChanged: _selecionarSelagemParaVetorizacao,
          codigoSeloController: _codigoSeloController,
          codigoLoteController: _codigoLoteController,
          mostrarVertices: _mostrarVertices,
          mostrarSegmentos: _mostrarSegmentos,
          mostrarPoligono: _mostrarPoligono,
          hasOrtomosaico: _ortomosaicoTileProvider != null,
          ortomosaicoNome: _ortomosaicoNome,
          onImportarOrto: () {
            Navigator.of(context).pop();
            _importarOrtomosaicoMbtiles();
          },
          onZoomOrto: () {
            Navigator.of(context).pop();

            if (_ortomosaicoBounds != null) {
              _fitBounds(_ortomosaicoBounds!);
            }
          },
          onZoomLote: () {
            Navigator.of(context).pop();
            _zoomNoLote();
          },
          onGps: () {
            Navigator.of(context).pop();
            _centralizarGps();
          },
          onExcluirUltimo: () {
            Navigator.of(context).pop();
            _excluirUltimoVertice();
          },
          onLimpar: () {
            Navigator.of(context).pop();
            _limparVetorizacao();
          },
          onToggleVertices: () {
            Navigator.of(context).pop();
            setState(() {
              _mostrarVertices = !_mostrarVertices;
            });
          },
          onToggleSegmentos: () {
            Navigator.of(context).pop();
            setState(() {
              _mostrarSegmentos = !_mostrarSegmentos;
            });
          },
          onTogglePoligono: () {
            Navigator.of(context).pop();
            setState(() {
              _mostrarPoligono = !_mostrarPoligono;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final area = _areaM2();
    final perimetro = _perimetroM();

    if (_loading) {
      return const Scaffold(
        backgroundColor: _surface,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: Stack(
          children: [
            if (_ortomosaicoTileProvider == null)
              _NoOrthomosaicView(
                onBack: () => Navigator.of(context).pop(),
                onImport: _importarOrtomosaicoMbtiles,
              )
            else
              KeyedSubtree(
                key: _mapKey,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _center,
                    initialZoom: 20,
                    maxZoom: 22,
                    interactionOptions: InteractionOptions(
                      flags: _arrastandoVertice
                          ? InteractiveFlag.none
                          : InteractiveFlag.all,
                    ),
                    onTap: (_, point) => _handleMapTap(point),
                  ),
                  children: [
                    TileLayer(
                      tileProvider: _ortomosaicoTileProvider!,
                      userAgentPackageName: 'com.example.biome_reurb',
                      maxZoom: 22,
                    ),
                    if (_polygonsVetorizacoesSalvas().isNotEmpty)
                      PolygonLayer(
                        polygons: _polygonsVetorizacoesSalvas(),
                      ),
                    if (_polygon().isNotEmpty)
                      PolygonLayer(
                        polygons: _polygon(),
                      ),
                    if (_edges().isNotEmpty)
                      PolylineLayer(
                        polylines: _edges(),
                      ),
                    if (_segmentMarkers().isNotEmpty)
                      MarkerLayer(
                        markers: _segmentMarkers(),
                      ),
                    if (_labelsVetorizacoesSalvas().isNotEmpty)
                      MarkerLayer(
                        markers: _labelsVetorizacoesSalvas(),
                      ),
                    if (_vertexMarkers().isNotEmpty)
                      MarkerLayer(
                        markers: _vertexMarkers(),
                      ),
                  ],
                ),
              ),
            Positioned(
              left: 14,
              right: 14,
              top: 14,
              child: _CompactVectorHeader(
                vertices: _vertices.length,
                hasOrtomosaico: _ortomosaicoTileProvider != null,
                onBack: () => Navigator.of(context).pop(),
                onLayers: _abrirCamadas,
              ),
            ),
            if (_ortomosaicoTileProvider != null)
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: _CompactVectorPanel(
                  expanded: _painelExpandido,
                  area: _formatNumber(area, decimals: 2),
                  perimetro: _formatNumber(perimetro, decimals: 3),
                  vertices: _vertices.length,
                  selectedVertexIndex: _selectedVertexIndex,
                  onToggle: () {
                    setState(() {
                      _painelExpandido = !_painelExpandido;
                    });
                  },
                  onSaveDraft: _salvarRascunho,
                  onFinish: _concluirVetorizacao,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NoOrthomosaicView extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onImport;

  const _NoOrthomosaicView({
    required this.onBack,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6FAF7),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x16063D1C),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5EC),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: const Icon(
                    Icons.image_rounded,
                    color: Color(0xFF0B5D2A),
                    size: 42,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Ortomosaico obrigatório',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF10251A),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'A vetorização do lote deve ser feita sobre o ortomosaico do drone para evitar deslocamentos e inconsistências.',
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
                    onPressed: onImport,
                    icon: const Icon(Icons.upload_file_rounded),
                    label: const Text('Importar MBTiles'),
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
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Voltar'),
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

class _CompactVectorHeader extends StatelessWidget {
  final int vertices;
  final bool hasOrtomosaico;
  final VoidCallback onBack;
  final VoidCallback onLayers;

  const _CompactVectorHeader({
    required this.vertices,
    required this.hasOrtomosaico,
    required this.onBack,
    required this.onLayers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFE2ECE6),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22063D1C),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _SmallIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: onBack,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vetorização do lote',
                  style: TextStyle(
                    color: Color(0xFF10251A),
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Ortomosaico + cidadão assistido',
                  style: TextStyle(
                    color: Color(0xFF68756D),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _HeaderMiniBadge(
            label: '$vertices pts',
            active: vertices >= 3,
          ),
          const SizedBox(width: 8),
          _HeaderMiniBadge(
            label: hasOrtomosaico ? 'Orto' : 'Sem orto',
            active: hasOrtomosaico,
          ),
          const SizedBox(width: 8),
          _SmallIconButton(
            icon: Icons.layers_rounded,
            onTap: onLayers,
          ),
        ],
      ),
    );
  }
}

class _CompactVectorPanel extends StatelessWidget {
  final bool expanded;
  final String area;
  final String perimetro;
  final int vertices;
  final int? selectedVertexIndex;
  final VoidCallback onToggle;
  final VoidCallback onSaveDraft;
  final VoidCallback onFinish;

  const _CompactVectorPanel({
    required this.expanded,
    required this.area,
    required this.perimetro,
    required this.vertices,
    required this.selectedVertexIndex,
    required this.onToggle,
    required this.onSaveDraft,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final canFinish = vertices >= 3;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFE2ECE6),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24063D1C),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(18),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Medição do lote',
                    style: TextStyle(
                      color: Color(0xFF10251A),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (selectedVertexIndex != null)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      'P${selectedVertexIndex! + 1}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_up_rounded,
                  color: const Color(0xFF0B5D2A),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _CleanMetric(
                  label: 'Área',
                  value: '$area m²',
                  icon: Icons.crop_square_rounded,
                  color: const Color(0xFF0B5D2A),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CleanMetric(
                  label: 'Perímetro',
                  value: '$perimetro m',
                  icon: Icons.straighten_rounded,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 10),
            _CleanStatusBox(
              ok: canFinish,
              text: canFinish
                  ? 'Polígono formado. Revise os vértices e segmentos antes de concluir.'
                  : 'Adicione pelo menos 3 vértices para formar o lote.',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSaveDraft,
                    icon: const Icon(Icons.save_alt_rounded),
                    label: const Text('Rascunho'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0B5D2A),
                      side: const BorderSide(
                        color: Color(0xFFD7E8DC),
                      ),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: canFinish ? onFinish : null,
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Concluir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B5D2A),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFD8E4DD),
                      disabledForegroundColor: const Color(0xFF849188),
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LayersSheet extends StatelessWidget {
  final List<Map<String, Object?>> selagensDisponiveis;
  final String? selagemSelecionadaId;
  final ValueChanged<String?> onSelagemChanged;

  final TextEditingController codigoSeloController;
  final TextEditingController codigoLoteController;

  final bool mostrarVertices;
  final bool mostrarSegmentos;
  final bool mostrarPoligono;
  final bool hasOrtomosaico;
  final String? ortomosaicoNome;

  final VoidCallback onImportarOrto;
  final VoidCallback onZoomOrto;
  final VoidCallback onZoomLote;
  final VoidCallback onGps;
  final VoidCallback onExcluirUltimo;
  final VoidCallback onLimpar;
  final VoidCallback onToggleVertices;
  final VoidCallback onToggleSegmentos;
  final VoidCallback onTogglePoligono;

  const _LayersSheet({
    required this.selagensDisponiveis,
    required this.selagemSelecionadaId,
    required this.onSelagemChanged,
    required this.codigoSeloController,
    required this.codigoLoteController,
    required this.mostrarVertices,
    required this.mostrarSegmentos,
    required this.mostrarPoligono,
    required this.hasOrtomosaico,
    required this.ortomosaicoNome,
    required this.onImportarOrto,
    required this.onZoomOrto,
    required this.onZoomLote,
    required this.onGps,
    required this.onExcluirUltimo,
    required this.onLimpar,
    required this.onToggleVertices,
    required this.onToggleSegmentos,
    required this.onTogglePoligono,
  });
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.45,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x30000000),
                blurRadius: 30,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDE7E1),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5EC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.layers_rounded,
                        color: Color(0xFF0B5D2A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Camadas e opções',
                            style: TextStyle(
                              color: Color(0xFF10251A),
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Ortomosaico, vínculo, medição e edição do lote',
                            style: TextStyle(
                              color: Color(0xFF68756D),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6FAF7),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFFE2ECE6),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.link_rounded,
                            color: Color(0xFF0B5D2A),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Vínculo do lote vetorizado',
                            style: TextStyle(
                              color: Color(0xFF10251A),
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selagemSelecionadaId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Selagem vinculada',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.qr_code_2_rounded),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFDDE7E1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF0B5D2A),
                              width: 2,
                            ),
                          ),
                        ),
                        hint: const Text('Selecione uma selagem cadastrada'),
                        items: selagensDisponiveis.map((item) {
                          final id = item['id']?.toString();
                          final codigo =
                              item['codigo_selo']?.toString() ?? 'Sem código';
                          final responsavel =
                              item['nome_responsavel']?.toString();
                          final lote =
                              item['codigo_lote_preliminar']?.toString();

                          final subtitleParts = <String>[];

                          if (responsavel != null &&
                              responsavel.trim().isNotEmpty) {
                            subtitleParts.add(responsavel);
                          }

                          if (lote != null && lote.trim().isNotEmpty) {
                            subtitleParts.add('Lote $lote');
                          }

                          final subtitle = subtitleParts.isEmpty
                              ? ''
                              : ' • ${subtitleParts.join(' • ')}';

                          return DropdownMenuItem<String>(
                            value: id,
                            child: Text(
                              '$codigo$subtitle',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: onSelagemChanged,
                      ),
                      const SizedBox(height: 10),
                      _SheetInputField(
                        controller: codigoLoteController,
                        label: 'Código do lote',
                        hint: 'Ex.: LOTE-04 ou 04',
                        icon: Icons.crop_square_rounded,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Selecione uma selagem já cadastrada. O código da selagem será usado para vincular esta vetorização ao cadastro do beneficiário, à exportação web e ao comprovante.',
                        style: TextStyle(
                          color: Color(0xFF68756D),
                          fontSize: 11.5,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ações rápidas',
                  style: TextStyle(
                    color: Color(0xFF10251A),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.06,
                  children: [
                    _ToolTile(
                      icon: Icons.upload_file_rounded,
                      label: 'Importar orto',
                      active: hasOrtomosaico,
                      onTap: onImportarOrto,
                    ),
                    _ToolTile(
                      icon: Icons.image_search_rounded,
                      label: 'Zoom orto',
                      active: hasOrtomosaico,
                      onTap: onZoomOrto,
                    ),
                    _ToolTile(
                      icon: Icons.crop_free_rounded,
                      label: 'Zoom lote',
                      onTap: onZoomLote,
                    ),
                    _ToolTile(
                      icon: Icons.my_location_rounded,
                      label: 'GPS',
                      onTap: onGps,
                    ),
                    _ToolTile(
                      icon: Icons.undo_rounded,
                      label: 'Excluir último',
                      onTap: onExcluirUltimo,
                    ),
                    _ToolTile(
                      icon: Icons.delete_outline_rounded,
                      label: 'Limpar',
                      danger: true,
                      onTap: onLimpar,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Exibição no mapa',
                  style: TextStyle(
                    color: Color(0xFF10251A),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                _SwitchRow(
                  title: 'Exibir polígono',
                  subtitle: 'Mostra o preenchimento do lote desenhado.',
                  value: mostrarPoligono,
                  onTap: onTogglePoligono,
                ),
                _SwitchRow(
                  title: 'Exibir vértices arrastáveis',
                  subtitle: 'Pressione e segure para mover cada ponto.',
                  value: mostrarVertices,
                  onTap: onToggleVertices,
                ),
                _SwitchRow(
                  title: 'Exibir medidas dos segmentos',
                  subtitle: 'Mostra a distância decimal de cada lado do lote.',
                  value: mostrarSegmentos,
                  onTap: onToggleSegmentos,
                ),
                if (hasOrtomosaico) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5EC),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.image_rounded,
                          color: Color(0xFF0B5D2A),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            ortomosaicoNome ?? 'Ortomosaico carregado',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF0B5D2A),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SheetInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const _SheetInputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.characters,
      style: const TextStyle(
        color: Color(0xFF10251A),
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFDDE7E1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF0B5D2A),
            width: 2,
          ),
        ),
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final bool danger;
  final VoidCallback onTap;

  const _ToolTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger
        ? Colors.red
        : active
            ? const Color(0xFF0B5D2A)
            : const Color(0xFF10251A);

    return Material(
      color: active
          ? const Color(0xFFE8F5EC)
          : danger
              ? Colors.red.withValues(alpha: 0.06)
              : const Color(0xFFF6FAF7),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final VoidCallback onTap;

  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF10251A),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF68756D),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                activeColor: const Color(0xFF0B5D2A),
                onChanged: (_) => onTap(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SmallIconButton({
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

class _HeaderMiniBadge extends StatelessWidget {
  final String label;
  final bool active;

  const _HeaderMiniBadge({
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE8F5EC) : const Color(0xFFF1F4F2),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? const Color(0xFF0B5D2A) : const Color(0xFF8B9890),
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CleanMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _CleanMetric({
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
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
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

class _CleanStatusBox extends StatelessWidget {
  final bool ok;
  final String text;

  const _CleanStatusBox({
    required this.ok,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final color = ok ? const Color(0xFF0B5D2A) : Colors.orange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            ok ? Icons.verified_rounded : Icons.info_outline_rounded,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                height: 1.3,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentLabel extends StatelessWidget {
  final String value;

  const _SegmentLabel({
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: const Color(0xFFD7E8DC),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22063D1C),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF0B5D2A),
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _VertexHandle extends StatelessWidget {
  final int index;
  final bool selected;
  final bool dragging;

  const _VertexHandle({
    required this.index,
    this.selected = false,
    this.dragging = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.orange : const Color(0xFF0B5D2A);
    final size = dragging
        ? 44.0
        : selected
            ? 38.0
            : 32.0;

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? color : Colors.white,
          border: Border.all(
            color: color,
            width: 3,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33063D1C),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: selected ? Colors.white : color,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _VetorizacaoLabel extends StatelessWidget {
  final String text;

  const _VetorizacaoLabel({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: Colors.orange,
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
