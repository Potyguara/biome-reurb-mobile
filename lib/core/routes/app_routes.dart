import 'package:biome_reurb/features/base_cartografica/presentation/base_cartografica_page.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/projetos/presentation/projetos_page.dart';
import '../../features/selagem/presentation/selagem_page.dart';
import '../../features/cadastro_social/presentation/cadastro_social_page.dart';
import '../../features/cadastro_fisico/presentation/cadastro_fisico_page.dart';
import '../../features/mapa/presentation/mapa_page.dart';
import '../../features/sync/presentation/sync_page.dart';
import '../../features/beneficiario/presentation/beneficiario_consulta_page.dart';
import '../../features/documentos/presentation/documentos_page.dart';
import '../../features/pendencias/presentation/pendencias_page.dart';
import '../../features/comprovantes/presentation/comprovantes_cidadao_page.dart';
import '../../features/mapa/presentation/vetorizacao_lote_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String projetos = '/projetos';
  static const String selagem = '/selagem';
  static const String cadastroSocial = '/cadastro-social';
  static const String cadastroFisico = '/cadastro-fisico';
  static const String mapa = '/mapa';
  static const String sync = '/sync';
  static const String beneficiario = '/beneficiario';
  static const String documentos = '/documentos';
  static const String baseCartografica = '/base-cartografica';
  static const String pendencias = '/pendencias';
  static const String comprovantesCidadao = '/comprovantes-cidadao';
  static const String vetorizacaoLote = '/vetorizacao-lote';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginPage(),
        dashboard: (_) => const DashboardPage(),
        projetos: (_) => const ProjetosPage(),
        selagem: (_) => const SelagemPage(),
        cadastroSocial: (_) => const CadastroSocialPage(),
        cadastroFisico: (_) => const CadastroFisicoPage(),
        mapa: (_) => const MapaPage(),
        sync: (_) => const SyncPage(),
        beneficiario: (_) => const BeneficiarioConsultaPage(),
        documentos: (_) => const DocumentosPage(),
        baseCartografica: (_) => const BaseCartograficaPage(),
        pendencias: (_) => const PendenciasPage(),
        comprovantesCidadao: (_) => const ComprovantesCidadaoPage(),
        vetorizacaoLote: (_) => const VetorizacaoLotePage(),
      };
}
