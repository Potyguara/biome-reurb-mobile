import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../mobile/domain/mobile_project.dart';
import '../../mobile/presentation/active_project_controller.dart';
import '../../mobile/presentation/mobile_session_controller.dart';

class ProjetosPage extends ConsumerStatefulWidget {
  const ProjetosPage({super.key});

  @override
  ConsumerState<ProjetosPage> createState() => _ProjetosPageState();
}

class _ProjetosPageState extends ConsumerState<ProjetosPage> {
  static const Color _primary = Color(0xFF0B5D2A);
  static const Color _surface = Color(0xFFF6FAF7);
  static const Color _textDark = Color(0xFF10251A);
  static const Color _muted = Color(0xFF68756D);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mobileSessionControllerProvider.notifier).load();
    });
  }

  Future<void> _refresh() {
    return ref.read(mobileSessionControllerProvider.notifier).load(force: true);
  }

  Future<void> _selectProject(MobileProject project) async {
    await ref.read(activeProjectControllerProvider.notifier).select(project);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Projeto "${project.name}" selecionado para a coleta.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'em_execucao':
        return 'Em execução';
      case 'planejamento':
        return 'Planejamento';
      case 'concluido':
        return 'Concluído';
      case 'suspenso':
        return 'Suspenso';
      default:
        return status.replaceAll('_', ' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(mobileSessionControllerProvider);
    final activeProject = ref.watch(activeProjectControllerProvider);
    final session = sessionState.session;
    final projects = session?.projects ?? const <MobileProject>[];

    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        title: const Text('Projetos REURB'),
        backgroundColor: Colors.white,
        foregroundColor: _textDark,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Atualizar projetos',
            onPressed: sessionState.status == MobileSessionStatus.loading
                ? null
                : _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: _primary,
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
          children: [
            _InfoBanner(
              isOffline: session?.isOffline ?? false,
              projectsCount: projects.length,
            ),
            const SizedBox(height: 18),
            if (sessionState.status == MobileSessionStatus.loading &&
                projects.isEmpty)
              const _LoadingProjects()
            else if (sessionState.status == MobileSessionStatus.failure &&
                projects.isEmpty)
              _ErrorState(
                message: sessionState.message ??
                    'Não foi possível carregar os projetos.',
                onRetry: _refresh,
              )
            else if (projects.isEmpty)
              const _EmptyState()
            else ...[
              Text(
                activeProject == null
                    ? 'Selecione o projeto de trabalho'
                    : 'Projeto ativo',
                style: const TextStyle(
                  color: _textDark,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                activeProject == null
                    ? 'Todos os cadastros novos serão vinculados ao projeto selecionado.'
                    : 'Os próximos registros de campo serão associados a este projeto.',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              for (final project in projects)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _ProjectCard(
                    project: project,
                    selected: activeProject?.id == project.id,
                    statusLabel: _statusLabel(project.status),
                    onSelect: () => _selectProject(project),
                  ),
                ),
            ],
            if (sessionState.status == MobileSessionStatus.failure &&
                projects.isNotEmpty) ...[
              const SizedBox(height: 4),
              _InlineWarning(
                message: sessionState.message ??
                    'A lista exibida pode estar desatualizada.',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({
    required this.isOffline,
    required this.projectsCount,
  });

  final bool isOffline;
  final int projectsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOffline ? const Color(0xFFFFF8E8) : const Color(0xFFEAF7EE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOffline ? const Color(0xFFF2C96D) : const Color(0xFFB9DFC4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isOffline ? Icons.cloud_off_rounded : Icons.cloud_done_rounded,
            color:
                isOffline ? const Color(0xFF9A6500) : const Color(0xFF0B5D2A),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isOffline
                  ? '$projectsCount projeto(s) disponíveis na última sessão salva.'
                  : '$projectsCount projeto(s) autorizado(s) pelo painel web.',
              style: const TextStyle(
                color: Color(0xFF274234),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.project,
    required this.selected,
    required this.statusLabel,
    required this.onSelect,
  });

  final MobileProject project;
  final bool selected;
  final String statusLabel;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0B5D2A);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? primary : const Color(0xFFDDE7E0),
              width: selected ? 2 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: selected ? primary : const Color(0xFFEAF3ED),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      selected
                          ? Icons.check_circle_rounded
                          : Icons.folder_copy_rounded,
                      color: selected ? Colors.white : primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: const TextStyle(
                            color: Color(0xFF10251A),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${project.neighborhood} · '
                          '${project.municipality}/${project.state}',
                          style: const TextStyle(
                            color: Color(0xFF68756D),
                            fontSize: 13,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Chip(label: project.reurbType),
                  _Chip(label: statusLabel),
                  _Chip(label: project.role),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: selected
                    ? FilledButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Projeto ativo'),
                      )
                    : FilledButton.icon(
                        onPressed: onSelect,
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Selecionar para coleta'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF355345),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _LoadingProjects extends StatelessWidget {
  const _LoadingProjects();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando projetos autorizados...'),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(
            Icons.folder_off_rounded,
            size: 72,
            color: Color(0xFF9BA9A1),
          ),
          SizedBox(height: 16),
          Text(
            'Nenhum projeto autorizado',
            style: TextStyle(
              color: Color(0xFF10251A),
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Solicite ao administrador o vínculo do seu usuário a um projeto REURB.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF68756D),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 54),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 70,
            color: Color(0xFF9BA9A1),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF68756D),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}

class _InlineWarning extends StatelessWidget {
  const _InlineWarning({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFF9A6500),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF6E5200),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
