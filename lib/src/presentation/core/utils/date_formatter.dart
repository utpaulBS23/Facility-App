import 'package:intl/intl.dart';

final class DateFormatter {
  const DateFormatter._();

  static String shiftTime(String hms) =>
      DateFormat('h:mm a').format(DateFormat('HH:mm:ss').parse(hms));

  static String isoTimestamp(String iso) =>
      DateFormat('MMM d, h:mm a').format(DateTime.parse(iso).toLocal());

  static String shiftDate(DateTime d) => DateFormat('EEE, MMM d').format(d);
}
