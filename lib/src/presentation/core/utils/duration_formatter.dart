import 'package:flutter/widgets.dart';

import '../../../core/extensions/app_localization.dart';
import 'number_formatter.dart';

abstract final class DurationFormatter {
  /// Decimal hours (`num` or numeric `String`, e.g. `7.5`) → localized
  /// hours/minutes, dropping a zero part (`8h`, `7h 30m`, `45m`; Bangla
  /// `৮ ঘণ্টা`, `৭ ঘণ্টা ৩০ মিনিট`). `—` when not a number.
  static String localized(BuildContext context, Object? decimalHours) {
    final hours = switch (decimalHours) {
      final num n => n,
      final String s => num.tryParse(s),
      _ => null,
    };
    if (hours == null) return '—';

    final totalMinutes = (hours * 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    final l = context.locale;

    final parts = [
      if (h > 0) l.durationHours(NumberFormatter.format(h)),
      if (m > 0 || h == 0) l.durationMinutes(NumberFormatter.format(m)),
    ];
    return parts.join(' ');
  }
}
