/// Whether a check-in or check-out is late, by the server's own rule.
///
/// WHY Asia/Dhaka wall clock: the server reads every shift time in Dhaka, so
/// "now" must be Dhaka's too, whatever timezone the phone is set to. Dhaka has
/// no daylight saving, so it is always UTC+6. A wall clock is held in a
/// DateTime flagged UTC, only so two of them compare without the phone's zone
/// getting in.
library;

const _dhakaOffset = Duration(hours: 6);

/// The Dhaka wall clock at [instant] (now by default).
DateTime dhakaWallClock([DateTime? instant]) =>
    (instant ?? DateTime.now()).toUtc().add(_dhakaOffset);

/// A shift's [date] (`yyyy-MM-dd`) and [time] (`HH:mm` or `HH:mm:ss`) as a
/// Dhaka wall clock, or null when either does not parse.
DateTime? shiftMoment(String date, String time) {
  final d = date.split('-').map(int.tryParse).toList();
  final t = time.split(':').map(int.tryParse).toList();
  if (d.length < 3 || t.length < 2 || d.contains(null) || t.contains(null)) {
    return null;
  }

  return DateTime.utc(d[0]!, d[1]!, d[2]!, t[0]!, t[1]!);
}

/// The last minute of an on-time check-in: shift start plus [graceMinutes].
DateTime? checkInDeadline({
  required String date,
  required String startTime,
  required int graceMinutes,
}) => shiftMoment(date, startTime)?.add(Duration(minutes: graceMinutes));

/// The last minute of an on-time check-out: shift end plus [graceMinutes].
DateTime? checkOutDeadline({
  required String date,
  required String endTime,
  required int graceMinutes,
}) => shiftMoment(date, endTime)?.add(Duration(minutes: graceMinutes));

/// True once [at] (the Dhaka wall clock now, by default) is past [deadline].
/// False when the deadline is unknown: nothing is claimed about a late one.
bool isPast(DateTime? deadline, [DateTime? at]) =>
    deadline != null && (at ?? dhakaWallClock()).isAfter(deadline);

/// `HH:mm` of a wall clock, for messages.
String wallClockHm(DateTime wall) =>
    '${wall.hour.toString().padLeft(2, '0')}:${wall.minute.toString().padLeft(2, '0')}';
