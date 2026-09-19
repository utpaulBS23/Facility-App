/// Parses UTC ISO-8601 or datetime strings (with or without 'Z'/offset) and
/// converts them to local device timezone using [.toLocal()].
DateTime? parseLocalIso(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  try {
    final trimmed = raw.trim().replaceAll(' ', 'T');
    final hasOffset = trimmed.endsWith('Z') ||
        trimmed.contains('+') ||
        (trimmed.lastIndexOf('-') > 10);
    final iso = hasOffset ? trimmed : '${trimmed}Z';
    return DateTime.parse(iso).toLocal();
  } catch (_) {
    return null;
  }
}
