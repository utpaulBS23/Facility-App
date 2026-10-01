/// Picks the display text for [languageCode]: the Bangla sibling when the app
/// is in Bangla and the server sent one, else the base (English) value.
String localizedText(String languageCode, String base, String? bn) {
  if (languageCode == 'bn' && bn != null && bn.trim().isNotEmpty) return bn;

  return base;
}

/// Nullable-base variant for optional fields; stays null when both are empty.
String? localizedTextOrNull(String languageCode, String? base, String? bn) {
  if (languageCode == 'bn' && bn != null && bn.trim().isNotEmpty) return bn;

  return base;
}
