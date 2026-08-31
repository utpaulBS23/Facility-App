// WHY: API sends check-in/check-out/shift timestamps as Dhaka-local
// ISO-8601 strings with no 'Z'/offset suffix (e.g. "2026-08-31T08:30:00").
// Dart's DateTime.parse already treats such a bare string as local time,
// so no offset math or .toLocal() is needed — doing so double-shifts it.
DateTime? parseLocalIso(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    return DateTime.parse(raw);
  } catch (_) {
    return null;
  }
}
