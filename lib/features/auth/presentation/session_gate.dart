import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashboard/presentation/dashboard_page.dart';
import 'auth_controller.dart';
import 'login_page.dart';

class SessionGate extends ConsumerStatefulWidget {
  const SessionGate({super.key});

  @override
  ConsumerState<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends ConsumerState<SessionGate> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(authControllerProvider.notifier).restoreSession(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    switch (auth.status) {
      case AuthStatus.initial:
      case AuthStatus.loading:
        return const _SessionLoadingPage();
      case AuthStatus.authenticated:
        return const DashboardPage();
      case AuthStatus.unauthenticated:
        return const LoginPage();
    }
  }
}

class _SessionLoadingPage extends StatelessWidget {
  const _SessionLoadingPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF6FAF7),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF0B5D2A)),
            SizedBox(height: 18),
            Text(
              'Verificando acesso...',
              style: TextStyle(
                color: Color(0xFF10251A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
