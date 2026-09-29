abstract final class DurationFormatter {
  /// Decimal hours (`num` or numeric `String`, e.g. `0.63`) → zero-padded
  /// `HH:MM` (e.g. `"00:38"`).
  static String hoursToHm(Object? decimalHours) {
    final hours = switch (decimalHours) {
      final num n => n,
      final String s => num.tryParse(s),
      _ => null,
    };
    if (hours == null) return '—';

    final totalMinutes = (hours * 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return '${h.toString().padLeft(2, '0')}h ${m.toString().padLeft(2, '0')}m';
  }
}
