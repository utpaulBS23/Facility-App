/// Converts Carbon/JS day numbering (0=Sunday...6=Saturday) from backend
/// to Flutter [DateTime]'s 1=Monday...7=Sunday.
int carbonToFlutterWeekday(int weekStartDay) {
  if (weekStartDay == 0) return 7; // Sunday
  return weekStartDay.clamp(1, 6); // Monday=1 ... Saturday=6
}

extension WeekDateExtension on DateTime {
  /// Returns the start date (at 00:00:00) of the week containing this [DateTime],
  /// aligned to the specified [weekStartDay] (Carbon 0=Sun..6=Sat).
  DateTime startOfWeek(int weekStartDay) {
    final normalized = DateTime(year, month, day);
    final targetWeekday = carbonToFlutterWeekday(weekStartDay);
    final diff = (normalized.weekday - targetWeekday + 7) % 7;
    return normalized.subtract(Duration(days: diff));
  }

  /// Returns the end date (at 23:59:59) of the week starting at [startOfWeek].
  DateTime endOfWeek(int weekStartDay) {
    return startOfWeek(weekStartDay).add(const Duration(days: 6));
  }
}
