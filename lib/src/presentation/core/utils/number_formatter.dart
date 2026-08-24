import 'package:intl/intl.dart';

abstract final class NumberFormatter {
  /// Converts any number (`num`, `int`, `double`) or numeric `String` into a
  /// localized number string based on the active global locale.
  ///
  /// Examples:
  /// - `NumberFormatter.format(5)` → `"5"` (EN) / `"৫"` (BN)
  /// - `NumberFormatter.format("1234")` → `"1,234"` (EN) / `"১,২৩৪"` (BN)
  static String format(Object? value, [String? locale]) {
    final number = switch (value) {
      final num n => n,
      final String s => num.tryParse(s),
      _ => null,
    };

    if (number == null) return value?.toString() ?? '';
    return NumberFormat.decimalPattern(locale).format(number);
  }
}
