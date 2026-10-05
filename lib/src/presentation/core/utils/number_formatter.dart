import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/app_localization.dart';
import '../../../core/utils/digits.dart';

abstract final class NumberFormatter {
  /// Converts any number (`num`, `int`, `double`) or numeric `String` into a
  /// localized number string based on the active global locale.
  ///
  /// Prefer [AppNumbersContext.numbers]: it reads the locale from the widget
  /// tree, so the widget rebuilds when the language changes.
  ///
  /// Examples:
  /// - `NumberFormatter.format(5)` → `"5"` (EN) / `"৫"` (BN)
  /// - `NumberFormatter.format("1234")` → `"1,234"` (EN) / `"১,২৩৪"` (BN)
  static String format(Object? value, [String? locale]) {
    final number = _toNum(value);
    if (number == null) return value?.toString() ?? '';
    return NumberFormat.decimalPattern(locale).format(number);
  }

  static num? _toNum(Object? value) => switch (value) {
    final num n => n,
    final String s => num.tryParse(s),
    _ => null,
  };
}

/// Locale-aware number formatting for display.
///
/// Every method returns the original text for a non-numeric input, so a
/// missing or malformed value never throws in `build`.
class AppNumbers {
  const AppNumbers(this.languageCode);

  final String languageCode;

  String _fixed(Object? value, int fractionDigits, {int? maxFractionDigits}) {
    final number = NumberFormatter._toNum(value);
    if (number == null) return value?.toString() ?? '';
    final format = NumberFormat.decimalPatternDigits(
      locale: languageCode,
      decimalDigits: fractionDigits,
    );
    if (maxFractionDigits != null) {
      format.maximumFractionDigits = maxFractionDigits;
    }
    return format.format(number);
  }

  /// Whole number with grouping: `১২,৩৪,৫৬৭`.
  String integer(Object? value) => _fixed(value, 0);

  /// Exactly [fractionDigits] decimals: `১,২৩৪.৫০`.
  String decimal(Object? value, int fractionDigits) =>
      _fixed(value, fractionDigits);

  /// Money with the taka sign. Whole amounts show no decimals, others up to two.
  String currency(Object? value) => '৳${_fixed(value, 0, maxFractionDigits: 2)}';

  /// [value] already on a 0-100 scale, plus `%`.
  String percent(Object? value, {int fractionDigits = 0}) =>
      '${_fixed(value, fractionDigits)}%';

  /// A phone number (or any digit string) with its digits in the app language;
  /// `+`, spaces and leading zeros are kept.
  String phone(String? value) => Digits.localize(value ?? '', languageCode);
}

extension AppNumbersContext on BuildContext {
  AppNumbers get numbers => AppNumbers(languageCode);
}
