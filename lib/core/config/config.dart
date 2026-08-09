class AppConfig {
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'dev',
  );

  static const String _devBetaApiUrl = 'https://skyage.co.in';
  static const String _prodApiUrl = 'https://skyage.in';

  static bool get isDev => environment == 'dev';

  static bool get isBeta => environment == 'beta';

  static bool get isProd => environment == 'prod';

  static String get baseUrl {
    return isProd ? _prodApiUrl : _devBetaApiUrl;
  }

  static String get appName {
    switch (environment) {
      case 'beta':
        return 'SkyAge BETA';
      case 'prod':
        return 'SkyAge';
      case 'dev':
      default:
        return 'SkyAge DEV';
    }
  }
}