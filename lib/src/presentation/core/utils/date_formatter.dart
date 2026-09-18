import 'package:intl/intl.dart';

final class DateFormatter {
  const DateFormatter._();

  /// Local `HH:mm:ss` or `HH:mm` string → `h:mm a`.
  static String shiftTime(String hms) {
    final trimmed = hms.trim();
    if (trimmed.isEmpty) return hms;
    final pattern = trimmed.split(':').length == 3 ? 'HH:mm:ss' : 'HH:mm';
    try {
      return DateFormat('h:mm a').format(DateFormat(pattern).parse(trimmed));
    } catch (_) {
      return hms;
    }
  }

  /// Local [DateTime] → `MMM d, h:mm a`.
  static String timestamp(DateTime dt) =>
      DateFormat('MMM d, h:mm a').format(dt.toLocal());

  /// Local [DateTime] → `h:mm a`.
  static String timeOnly(DateTime dt) =>
      DateFormat('h:mm a').format(dt.toLocal());

  static String shiftDate(DateTime d) => DateFormat('EEE, MMM d').format(d);

  /// Local [DateTime] → `MMM d, yyyy`.
  static String shortDate(DateTime d) => DateFormat('MMM d, yyyy').format(d);

  /// `yyyy-MM-dd` string → `dd/MM/yyyy`.
  static String dayMonthYear(String ymd) {
    try {
      return DateFormat('dd/MM/yyyy').format(DateFormat('yyyy-MM-dd').parse(ymd));
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
