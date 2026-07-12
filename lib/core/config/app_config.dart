class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = 'https://biomereurb.com.br/api';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
