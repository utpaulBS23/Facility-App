import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final class NumberFormatter {
  const NumberFormatter._();

  /// Converts any number (`num`, `int`, `double`) or numeric string into a
  /// localized number string based on the active locale in [BuildContext].
  ///
  /// Examples:
  /// - `NumberFormatter.format(context, 5)` → `"5"` (EN) / `"৫"` (BN)
  /// - `NumberFormatter.format(context, 1234)` → `"1,234"` (EN) / `"১,২৩৪"` (BN)
  static String format(BuildContext context, Object? value) {
    if (value == null) return '';
    final num? number = value is num ? value : num.tryParse(value.toString());
    if (number == null) return value.toString();
    final languageCode = Localizations.localeOf(context).languageCode;
    return NumberFormat.decimalPattern(languageCode).format(number);
  }
}
