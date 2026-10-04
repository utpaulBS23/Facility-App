import 'package:intl/intl.dart';

/// Dates and times exchanged with the backend.
///
/// WHY a fixed 'en' locale: a bare `DateFormat('yyyy-MM-dd')` follows
/// `Intl.defaultLocale`, which the app sets to the UI language. In Bangla it
/// writes `২০২৬-১০-০২`, which the backend rejects, and it can fail to parse
/// the backend's ASCII strings. Anything sent to or read from the API goes
/// through here; display formats keep following the UI language.
abstract final class ApiDate {
  static const _locale = 'en';

  static final _date = DateFormat('yyyy-MM-dd', _locale);
  static final _dateTime = DateFormat('yyyy-MM-dd HH:mm:ss', _locale);
  static final _month = DateFormat('yyyy-MM', _locale);
  static final _timeHms = DateFormat('HH:mm:ss', _locale);
  static final _timeHm = DateFormat('HH:mm', _locale);

  /// `yyyy-MM-dd`.
  static String date(DateTime d) => _date.format(d);

  /// `yyyy-MM-dd HH:mm:ss`.
  static String dateTime(DateTime d) => _dateTime.format(d);

  /// `yyyy-MM`.
  static String month(DateTime d) => _month.format(d);

  /// `yyyy-MM-dd` string → [DateTime]. Throws [FormatException] when invalid.
  static DateTime parseDate(String s) => _date.parse(s);

  /// `yyyy-MM-dd HH:mm:ss` string → [DateTime]. Throws [FormatException] when
  /// invalid.
  static DateTime parseDateTime(String s) => _dateTime.parse(s);

  /// `HH:mm:ss` or `HH:mm` string → [DateTime] on 1970-01-01. Throws
  /// [FormatException] when invalid.
  static DateTime parseTime(String s) {
    final trimmed = s.trim();

    return trimmed.split(':').length == 3
        ? _timeHms.parse(trimmed)
        : _timeHm.parse(trimmed);
  }
}
