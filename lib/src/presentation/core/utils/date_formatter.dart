import 'package:intl/intl.dart';

final class DateFormatter {
  const DateFormatter._();

  /// UTC `HH:mm:ss` or `HH:mm` string → local `h:mm a`.
  static String shiftTime(String hms) {
    final pattern = hms.split(':').length == 3 ? 'HH:mm:ss' : 'HH:mm';
    try {
      return DateFormat('h:mm a').format(
        DateFormat(pattern).parse(hms, true).toLocal(),
      );
    } catch (_) {
      return hms;
    }
  }

  /// Local [DateTime] → `MMM d, h:mm a`.
  static String timestamp(DateTime dt) =>
      DateFormat('MMM d, h:mm a').format(dt);

  /// Local [DateTime] → `h:mm a`.
  static String timeOnly(DateTime dt) => DateFormat('h:mm a').format(dt);

  static String shiftDate(DateTime d) => DateFormat('EEE, MMM d').format(d);

  /// Local [DateTime] → `MMM d, yyyy`.
  static String shortDate(DateTime d) => DateFormat('MMM d, yyyy').format(d);
}
