import 'package:flutter/services.dart' show appFlavor;

enum Flavor { dev, stage }

/// Build-time environment. The flavor comes from `flutter run --flavor <name>`
/// (exposed to Dart as [appFlavor]); no extra defines are needed.
abstract final class AppConfig {
  static const String _devBaseUrl = 'http://3.108.132.91/api/backend';
  static const String _stageBaseUrl =
      'https://stage-api.bhumijosmartmanagement.com/api/backend';

  // WHY optional override: lets a build point at a local or tunnel server
  // without a code change (`--dart-define=API_BASE_URL=...`).
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');

  // WHY defaults to dev: `flutter test` and a run without --flavor have a
  // null appFlavor.
  static const Flavor flavor = appFlavor == 'stage' ? Flavor.stage : Flavor.dev;

  static const String apiBaseUrl = _baseUrlOverride != ''
      ? _baseUrlOverride
      : (flavor == Flavor.stage ? _stageBaseUrl : _devBaseUrl);

  /// Sent on every API request so the backend can tell this app apart from
  /// other clients.
  static const String clientTypeHeader = 'X-Client-Type';
  static const String clientType = 'bhumijo-facility-app';
}
