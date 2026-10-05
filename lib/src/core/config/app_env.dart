import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Values read from the bundled `.env` file (see `.env.example`).
abstract final class AppEnv {
  /// Loads `.env`. A missing or unreadable file is not fatal: every value then
  /// reads as empty and the feature that needs it falls back.
  static Future<void> load() async {
    try {
      await dotenv.load(isOptional: true);
    } catch (_) {
      // WHY swallowed: a broken .env must not stop the app from starting.
    }
  }

  static String get barikoiApiKey =>
      dotenv.maybeGet('BARIKOI_API_KEY')?.trim() ?? '';
}
