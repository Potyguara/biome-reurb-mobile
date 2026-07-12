import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/session_gate.dart';

class BiomeReurbApp extends StatelessWidget {
  const BiomeReurbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BIOME REURB',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SessionGate(),
      routes: AppRoutes.routes,
    );
  }
}
