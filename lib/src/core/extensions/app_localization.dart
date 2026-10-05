import 'package:flutter/material.dart';

import '../gen/l10n/app_localizations.dart';

// WHY re-exported: `context.numbers` should be there wherever `context.locale` is.
export 'app_numbers.dart';

extension AppLocalizationExtension on AppLocalizations {
  String getLanguageName(String languageCode) {
    return switch (languageCode) {
      'en' => english,
      'bn' => bangla,
      'ar' => arabic,
      _ => languageCode,
    };
  }
}

extension BuildContextLocalizationExtension on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this);
}

extension BuildContextLanguageExtension on BuildContext {
  /// Active app language, e.g. `en` / `bn`.
  String get languageCode => Localizations.localeOf(this).languageCode;
}
