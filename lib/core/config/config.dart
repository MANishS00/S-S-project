import 'package:flutter/material.dart';

class AppConfig {
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'dev',
  );

  static const String devBetaApiUrl = 'https://skyage.co.in';

  static const String prodApiUrl = 'https://skyage.in';

  static bool get isDev => environment == 'dev';

  static bool get isBeta => environment == 'beta';

  static bool get isProd => environment == 'prod';

  static String get baseUrl {
    return isProd ? prodApiUrl : devBetaApiUrl;
  }

  static void printConfig() {
    debugPrint('================================');
    debugPrint('ENVIRONMENT: $environment');
    debugPrint('BASE URL: $baseUrl');
    debugPrint('APP NAME: $appName');
    debugPrint('================================');
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
