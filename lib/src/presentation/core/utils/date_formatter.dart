import 'package:intl/intl.dart';

final class DateFormatter {
  const DateFormatter._();

  /// UTC `HH:mm:ss` string → local `h:mm a`.
  static String shiftTime(String hms) {
    try {
      return DateFormat('h:mm a').format(
        DateFormat('HH:mm:ss').parse(hms, true).toLocal(),
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
}
