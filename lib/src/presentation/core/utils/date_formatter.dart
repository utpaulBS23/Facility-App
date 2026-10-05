import 'package:intl/intl.dart';

import '../../../core/utils/api_date.dart';

final class DateFormatter {
  const DateFormatter._();

  /// `h:mm` plus a meridiem in the active language.
  ///
  /// WHY not the `a` pattern: intl's `bn` data spells it `AM`/`PM` in Latin
  /// letters, which reads as untranslated next to Bangla digits.
  static String _clock(DateTime dt) {
    final isBangla = (Intl.defaultLocale ?? 'en').startsWith('bn');
    final meridiem = dt.hour < 12
        ? (isBangla ? 'এএম' : 'AM')
        : (isBangla ? 'পিএম' : 'PM');
    return '${DateFormat('h:mm').format(dt)} $meridiem';
  }

  /// Local `HH:mm:ss` or `HH:mm` string → `h:mm a`.
  static String shiftTime(String hms) {
    final trimmed = hms.trim();
    if (trimmed.isEmpty) return hms;
    try {
      return _clock(ApiDate.parseTime(trimmed));
    } catch (_) {
      return hms;
    }
  }

  /// Local [DateTime] → `MMM d, h:mm a`.
  static String timestamp(DateTime dt) =>
      '${DateFormat('MMM d').format(dt.toLocal())}, ${_clock(dt.toLocal())}';

  /// Local [DateTime] → `h:mm a`.
  static String timeOnly(DateTime dt) =>
      _clock(dt.toLocal());

  /// Local [DateTime] → `EEE, MMM d, y, h:mm a`.
  static String fullTimestamp(DateTime dt) =>
      '${DateFormat('EEE, MMM d, y').format(dt.toLocal())}, ${_clock(dt.toLocal())}';

  static String shiftDate(DateTime d) => DateFormat('EEE, MMM d').format(d);

  /// Date string (yyyy-MM-dd or datetime) → `EEE, MMM d`.
  static String formatDateOnly(String dateStr) {
    if (dateStr.isEmpty) return dateStr;
    try {
      final dt = DateTime.tryParse(dateStr.contains('T') ? dateStr : dateStr.replaceAll(' ', 'T'));
      if (dt != null) return shiftDate(dt);
    } catch (_) {}
    return dateStr;
  }

  /// Local [DateTime] → `MMM d, yyyy`.
  static String shortDate(DateTime d) => DateFormat('MMM d, yyyy').format(d);

  /// `yyyy-MM-dd` string → `dd/MM/yyyy`.
  static String dayMonthYear(String ymd) {
    try {
      return DateFormat('dd/MM/yyyy').format(ApiDate.parseDate(ymd));
    } catch (_) {
      return ymd;
    }
  }

  /// Formats raw due time string (24h `HH:mm`, `HH:mm:ss`, or datetime) → AM/PM format.
  static String formatDueTime(String raw) {
    if (raw.isEmpty) return raw;
    try {
      final dt = DateTime.tryParse(raw.contains('T') ? raw : raw.replaceAll(' ', 'T'));
      if (dt != null) return timestamp(dt);
    } catch (_) {}
    return shiftTime(raw);
  }

  /// Converts 24h time range (e.g. `14:00 - 18:00`) → `2:00 PM – 6:00 PM`.
  static String formatTimeRange(String rawRange) {
    final trimmed = rawRange.trim();
    if (trimmed.isEmpty) return rawRange;
    final parts = trimmed.split(RegExp(r'\s*(?:[-–—~]|\bto\b)\s*'));
    if (parts.length == 2) {
      final start = shiftTime(parts[0]);
      final end = shiftTime(parts[1]);
      return '$start – $end';
    }
    return shiftTime(trimmed);
  }
}
