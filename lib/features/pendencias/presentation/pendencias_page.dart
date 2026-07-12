import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/database_provider.dart';

class PendenciasPage extends ConsumerStatefulWidget {
  const PendenciasPage({super.key});

  @override
  ConsumerState<PendenciasPage> createState() => _PendenciasPageState();
}

class _PendenciasPageState extends ConsumerState<PendenciasPage> {
  late Future<List<Map<String, Object?>>> _futurePendencias;

  String _filtroCategoria = 'todas';

  @override
  void initState() {
    super.initState();
    _carregarPendencias();
  }

  void _carregarPendencias() {
    final db = ref.read(appDatabaseProvider);
    _futurePendencias = db.listarPendenciasValidacao();
  }

  List<Map<String, Object?>> _aplicarFiltro(
    List<Map<String, Object?>> pendencias,
  ) {
    if (_filtroCategoria == 'todas') {
      return pendencias;
    }

    return pendencias.where((p) {
      return p['categoria']?.toString() == _filtroCategoria;
    }).toList();
  }

  int _contarCategoria(
    List<Map<String, Object?>> pendencias,
    String categoria,
  ) {
    return pendencias.where((p) {
      return p['categoria']?.toString() == categoria;
    }).length;
  }

  Color _criticidadeColor(String? criticidade) {
    switch (criticidade) {
      case 'Alta':
        return Colors.red.shade700;
      case 'Média':
        return Colors.orange.shade800;
      case 'Baixa':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  IconData _categoriaIcon(String? categoria) {
    switch (categoria) {
      case 'Geoespacial':
        return Icons.gps_fixed;
      case 'Cadastro Físico':
        return Icons.home_work;
      case 'Cadastro Social':
        return Icons.people;
      case 'Documentos':
        return Icons.attach_file;
      case 'Lotes':
        return Icons.crop_square;
      default:
        return Icons.warning;
    }
  }

  Widget _resumoCard({
    required String titulo,
    required int total,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 6),
              Text(
                total.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filtroChip(String label, String value) {
    final selected = _filtroCategoria == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: selected,
        label: Text(label),
        onSelected: (_) {
          setState(() {
            _filtroCategoria = value;
          });
        },
      ),
    );
  }

  Widget _pendenciaCard(Map<String, Object?> pendencia) {
    final categoria = pendencia['categoria']?.toString();
    final criticidade = pendencia['criticidade']?.toString();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              _categoriaIcon(categoria),
              color: _criticidadeColor(criticidade),
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Chip(
                        label: Text(categoria ?? 'Pendência'),
                        visualDensity: VisualDensity.compact,
                      ),
                      Chip(
                        label: Text(criticidade ?? '-'),
                        visualDensity: VisualDensity.compact,
                        labelStyle: TextStyle(
                          color: _criticidadeColor(criticidade),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pendencia['descricao']?.toString() ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Lote: ${pendencia['codigo_lote'] ?? '-'} • '
                    'Selagem: ${pendencia['codigo_selo'] ?? '-'}',
                  ),
                  if (pendencia['responsavel'] != null)
                    Text('Responsável: ${pendencia['responsavel']}'),
                  Text(
                    'Projeto: ${pendencia['projeto'] ?? '-'} • '
                    'Bairro: ${pendencia['bairro'] ?? '-'}',
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ação recomendada: ${pendencia['acao_recomendada'] ?? '-'}',
                    style: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _atualizar() async {
    setState(_carregarPendencias);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendências / Validação'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _atualizar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, Object?>>>(
        future: _futurePendencias,
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
                      Text('Verificando pendências da coleta...'),
                    ],
                  ),
                ),
              ),
            );
          }

          final pendencias = snapshot.data ?? [];
          final filtradas = _aplicarFiltro(pendencias);

          final geo = _contarCategoria(pendencias, 'Geoespacial');
          final fisico = _contarCategoria(pendencias, 'Cadastro Físico');
          final social = _contarCategoria(pendencias, 'Cadastro Social');
          final docs = _contarCategoria(pendencias, 'Documentos');
          final lotes = _contarCategoria(pendencias, 'Lotes');

          return RefreshIndicator(
            onRefresh: _atualizar,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Resumo de Pendências',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _resumoCard(
                      titulo: 'Geo',
                      total: geo,
                      icon: Icons.gps_fixed,
                      color: Colors.red.shade700,
                    ),
                    _resumoCard(
                      titulo: 'Físico',
                      total: fisico,
                      icon: Icons.home_work,
                      color: Colors.orange.shade800,
                    ),
                    _resumoCard(
                      titulo: 'Social',
                      total: social,
                      icon: Icons.people,
                      color: Colors.blue.shade700,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _resumoCard(
                      titulo: 'Docs',
                      total: docs,
                      icon: Icons.attach_file,
                      color: Colors.purple.shade700,
                    ),
                    _resumoCard(
                      titulo: 'Lotes',
                      total: lotes,
                      icon: Icons.crop_square,
                      color: Colors.green.shade700,
                    ),
                    _resumoCard(
                      titulo: 'Total',
                      total: pendencias.length,
                      icon: Icons.warning,
                      color: Colors.black87,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filtroChip('Todas', 'todas'),
                      _filtroChip('Geoespacial', 'Geoespacial'),
                      _filtroChip('Físico', 'Cadastro Físico'),
                      _filtroChip('Social', 'Cadastro Social'),
                      _filtroChip('Documentos', 'Documentos'),
                      _filtroChip('Lotes', 'Lotes'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (pendencias.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Nenhuma pendência encontrada. A coleta está consistente para exportação.',
                      ),
                    ),
                  )
                else if (filtradas.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Nenhuma pendência encontrada para o filtro selecionado.',
                      ),
                    ),
                  )
                else
                  ...filtradas.map(_pendenciaCard),
              ],
            ),
          );
        },
      ),
    );
  }
}
