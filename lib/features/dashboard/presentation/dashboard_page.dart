// ignore_for_file: prefer_const_constructors, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

import '../../../core/routes/app_routes.dart';
import '../../../data/local/database_provider.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../mobile/presentation/mobile_session_controller.dart';
import '../../mobile/presentation/active_project_controller.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  late Future<Map<String, int>> _futureResumo;

  static const Color _primary = Color(0xFF0B5D2A);
  static const Color _primaryDark = Color(0xFF063D1C);
  static const Color _surface = Color(0xFFF6FAF7);
  static const Color _textDark = Color(0xFF10251A);
  static const Color _muted = Color(0xFF68756D);

  @override
  void initState() {
    super.initState();

    _futureResumo = _buscarResumo();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _atualizarResumo();
        ref.read(mobileSessionControllerProvider.notifier).load();
      }
    });
  }

  Future<Map<String, int>> _buscarResumo() async {
    final db = ref.read(appDatabaseProvider);
    return db.obterResumoDashboard();
  }

  Future<void> _atualizarResumo() async {
    setState(() {
      _futureResumo = _buscarResumo();
    });
  }

  Future<void> _abrirRota(
    String routeName, {
    bool requiresActiveProject = false,
  }) async {
    if (requiresActiveProject &&
        ref.read(activeProjectControllerProvider) == null) {
      final selectNow = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Selecione um projeto'),
            content: const Text(
              'Escolha o projeto de trabalho antes de iniciar a coleta de campo.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                icon: const Icon(Icons.folder_copy_rounded),
                label: const Text('Selecionar projeto'),
              ),
            ],
          );
        },
      );

      if (selectNow == true && mounted) {
        await Navigator.pushNamed(context, AppRoutes.projetos);
      }
      return;
    }

    await Navigator.pushNamed(context, routeName);

    if (!mounted) return;

    await _atualizarResumo();
  }

  Future<void> _sair() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Encerrar sessão'),
          content: const Text(
            'Deseja sair do BIOME REURB CAMPO neste dispositivo?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    await ref.read(authControllerProvider.notifier).logout();
    ref.read(mobileSessionControllerProvider.notifier).clear();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mobileState = ref.watch(mobileSessionControllerProvider);
    final session = mobileState.session;
    final authState = ref.watch(authControllerProvider);
    final user = session?.user ?? authState.user;
    final activeProject = ref.watch(activeProjectControllerProvider);

    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: RefreshIndicator(
          color: _primary,
          onRefresh: _atualizarResumo,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _Header(
                  onLogout: _sair,
                  onRefresh: () async {
                    await _atualizarResumo();
                    await ref
                        .read(mobileSessionControllerProvider.notifier)
                        .load(force: true);
                  },
                  userName: user?.name ?? 'Cadastrador',
                  roleLabel: session?.primaryRole ??
                      user?.roleLabel ??
                      'CAMPO',
                  isOffline: session?.isOffline ?? authState.isOffline,
                  projectsCount: session?.projects.length ?? 0,
                  activeProjectName: activeProject?.name,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                  child: FutureBuilder<Map<String, int>>(
                    future: _futureResumo,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const _LoadingSummaryCard();
                      }

                      final resumo = snapshot.data ??
                          const {
                            'selagens': 0,
                            'pendencias': 0,
                            'sync': 0,
                          };

                      return _StatsPanel(
                        selagens: resumo['selagens'] ?? 0,
                        pendencias: resumo['pendencias'] ?? 0,
                        sync: resumo['sync'] ?? 0,
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(18, 24, 18, 10),
                  child: _SectionTitle(
                    title: 'Fluxo operacional',
                    subtitle:
                        'Execute a coleta em campo seguindo a ordem recomendada.',
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _PremiumModuleCard(
                        step: '01',
                        icon: Icons.folder_copy_rounded,
                        title: 'Projetos REURB',
                        subtitle: activeProject == null
                            ? 'Selecione o projeto autorizado para iniciar a coleta.'
                            : 'Projeto ativo: ${activeProject.name}',
                        color: const Color(0xFF0B5D2A),
                        onTap: () => _abrirRota(AppRoutes.projetos),
                      ),
                      _PremiumModuleCard(
                        step: '02',
                        icon: Icons.layers_rounded,
                        title: 'Base Cartográfica',
                        subtitle:
                            'Importar lotes preliminares KML/GeoJSON do aerolevantamento.',
                        color: const Color(0xFF1565C0),
                        onTap: () => _abrirRota(
                          AppRoutes.baseCartografica,
                          requiresActiveProject: true,
                        ),
                      ),
                      _PremiumModuleCard(
                        step: '03',
                        icon: Icons.qr_code_2_rounded,
                        title: 'Selagem',
                        subtitle:
                            'Identificação inicial, status do imóvel, GPS e observações.',
                        color: const Color(0xFF2E7D32),
                        onTap: () => _abrirRota(
                          AppRoutes.selagem,
                          requiresActiveProject: true,
                        ),
                      ),
                      _PremiumModuleCard(
                        step: '04',
                        icon: Icons.people_alt_rounded,
                        title: 'Cadastro Social',
                        subtitle:
                            'Responsável familiar, renda, composição e dados socioeconômicos.',
                        color: const Color(0xFF00897B),
                        onTap: () => _abrirRota(
                          AppRoutes.cadastroSocial,
                          requiresActiveProject: true,
                        ),
                      ),
                      _PremiumModuleCard(
                        step: '05',
                        icon: Icons.home_work_rounded,
                        title: 'Cadastro Físico',
                        subtitle:
                            'Edificação, uso, infraestrutura, materiais e habitabilidade.',
                        color: const Color(0xFF6A1B9A),
                        onTap: () => _abrirRota(
                          AppRoutes.cadastroFisico,
                          requiresActiveProject: true,
                        ),
                      ),
                      _PremiumModuleCard(
                        step: '06',
                        icon: Icons.attach_file_rounded,
                        title: 'Documentos e Fotos',
                        subtitle:
                            'Fachada, documento do imóvel, RG, CPF e comprovantes.',
                        color: const Color(0xFF455A64),
                        onTap: () => _abrirRota(
                          AppRoutes.documentos,
                          requiresActiveProject: true,
                        ),
                      ),
                      _PremiumModuleCard(
                        step: '07',
                        icon: Icons.send_rounded,
                        title: 'Envio ao Cidadão',
                        subtitle:
                            'Gerar e compartilhar comprovante PDF com QR Code.',
                        color: const Color(0xFF1B5E20),
                        onTap: () => _abrirRota(
                          AppRoutes.comprovantesCidadao,
                          requiresActiveProject: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(18, 20, 18, 10),
                  child: _SectionTitle(
                    title: 'Ferramentas técnicas',
                    subtitle:
                        'Mapa, pendências, validações e pacote de sincronização.',
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _TechnicalCard(
                        icon: Icons.map_rounded,
                        title: 'Mapa da Coleta',
                        subtitle:
                            'Visualizar lotes, selagens, perímetros, ortomosaico e posição GPS.',
                        action: 'Abrir mapa',
                        onTap: () => _abrirRota(
                          AppRoutes.mapa,
                          requiresActiveProject: true,
                        ),
                      ),
                      _TechnicalCard(
                        icon: Icons.edit_location_alt_rounded,
                        title: 'Vetorização do Lote',
                        subtitle:
                            'Delimitação assistida do lote com apoio do cidadão e cadastrador.',
                        action: 'Abrir',
                        locked: false,
                        onTap: () => _abrirRota(
                          AppRoutes.vetorizacaoLote,
                          requiresActiveProject: true,
                        ),
                      ),
                      _TechnicalCard(
                        icon: Icons.warning_amber_rounded,
                        title: 'Pendências / Validação',
                        subtitle:
                            'Conferir inconsistências sociais, documentais e geoespaciais.',
                        action: 'Conferir',
                        onTap: () => _abrirRota(
                          AppRoutes.pendencias,
                          requiresActiveProject: true,
                        ),
                      ),
                      _TechnicalCard(
                        icon: Icons.sync_rounded,
                        title: 'Sincronização',
                        subtitle:
                            'Sincronizar dados com o servidor e manter exportação de contingência.',
                        action: 'Sincronizar',
                        onTap: () => _abrirRota(AppRoutes.sync),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onRefresh;
  final String userName;
  final String roleLabel;
  final bool isOffline;
  final int projectsCount;
  final String? activeProjectName;

  const _Header({
    required this.onLogout,
    required this.onRefresh,
    required this.userName,
    required this.roleLabel,
    required this.isOffline,
    required this.projectsCount,
    required this.activeProjectName,
  });

  static const Color _primary = Color(0xFF0B5D2A);
  static const Color _primaryDark = Color(0xFF063D1C);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _primaryDark,
            _primary,
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33063D1C),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _HeaderLogo(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BIOME REURB CAMPO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFDFF4E6),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      roleLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFBFE8CA),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activeProjectName == null
                          ? '$projectsCount projeto(s) · nenhum ativo'
                          : activeProjectName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFD7F2DF),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Atualizar',
                onPressed: onRefresh,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.refresh_rounded),
              ),
              const SizedBox(width: 6),
              IconButton.filledTonal(
                tooltip: 'Sair',
                onPressed: onLogout,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.logout_rounded),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Coleta REURB em campo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              height: 1.08,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Os dados de campo serão sincronizados com o painel web e permanecerão protegidos localmente quando não houver conexão.',
            style: TextStyle(
              color: Color(0xFFE7F6EB),
              fontSize: 14,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.14)),
            ),
            child: Row(
              children: [
                Icon(
                  isOffline ? Icons.cloud_off_rounded : Icons.cloud_done_rounded,
                  color: Color(0xFFC8F3D4),
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isOffline
                        ? 'Modo offline · usando a última sessão disponível'
                        : 'Sincronização online ativa · contingência offline disponível',
                    style: TextStyle(
                      color: Color(0xFFE7F6EB),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
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

class _HeaderLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          'assets/images/logomarca.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Image.asset(
              'assets/icons/logomarca.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.eco_rounded,
                  color: Color(0xFF0B5D2A),
                  size: 34,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _LoadingSummaryCard extends StatelessWidget {
  const _LoadingSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12063D1C),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        children: [
          LinearProgressIndicator(
            minHeight: 6,
            borderRadius: BorderRadius.all(Radius.circular(99)),
          ),
          SizedBox(height: 14),
          Text(
            'Atualizando resumo da coleta...',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF68756D),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  final int selagens;
  final int pendencias;
  final int sync;

  const _StatsPanel({
    required this.selagens,
    required this.pendencias,
    required this.sync,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Selados',
            value: selagens,
            icon: Icons.qr_code_2_rounded,
            color: const Color(0xFF0B5D2A),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            title: 'Pendências',
            value: pendencias,
            icon: Icons.warning_amber_rounded,
            color: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            title: 'Sincronizar',
            value: sync,
            icon: Icons.sync_rounded,
            color: const Color(0xFF1565C0),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE4EEE8),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10063D1C),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const Spacer(),
          Text(
            value.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF10251A),
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF68756D),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF10251A),
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF68756D),
            fontSize: 13,
            height: 1.35,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PremiumModuleCard extends StatelessWidget {
  final String step;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _PremiumModuleCard({
    required this.step,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(26),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: const Color(0xFFE4EEE8),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D063D1C),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 29,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$step · $title',
                        style: const TextStyle(
                          color: Color(0xFF10251A),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF68756D),
                          fontSize: 12.5,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF8B9890),
                  size: 17,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TechnicalCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String action;
  final bool locked;
  final VoidCallback? onTap;

  const _TechnicalCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.action,
    this.locked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = locked ? const Color(0xFF8B9890) : const Color(0xFF0B5D2A);

    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        child: InkWell(
          onTap: locked ? null : onTap,
          borderRadius: BorderRadius.circular(26),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color:
                    locked ? const Color(0xFFE7ECE9) : const Color(0xFFE4EEE8),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: locked
                              ? const Color(0xFF6D7871)
                              : const Color(0xFF10251A),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF68756D),
                          fontSize: 12.5,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    action,
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
        ),
      ),
    );
  }
}
