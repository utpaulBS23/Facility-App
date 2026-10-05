/// Digit conversion between Latin (`0-9`) and Bangla (`০-৯`) numerals.
///
/// WHY a character map, not `NumberFormat`: phone numbers and other
/// digit strings must keep their `+`, spaces and leading zeros, which a numeric
/// format would drop.
abstract final class Digits {
  const Digits._();

  static const _latin = '0123456789';
  static const _bangla = '০১২৩৪৫৬৭৮৯';
  static const _arabicIndic = '٠١٢٣٤٥٦٧٨٩';

  /// Every Bangla / Arabic-Indic digit in [input] → its Latin digit.
  ///
  /// Use before parsing text a user typed, and for anything sent to the API:
  /// `double.tryParse('৫০০')` is null, and the backend expects Latin digits.
  static String toLatin(String input) {
    final out = StringBuffer();
    for (final rune in input.runes) {
      final ch = String.fromCharCode(rune);
      var i = _bangla.indexOf(ch);
      if (i < 0) i = _arabicIndic.indexOf(ch);
      out.write(i < 0 ? ch : _latin[i]);
    }
    return out.toString();
  }

  /// Every Latin digit in [input] → its Bangla digit. Other characters stay.
  static String toBangla(String input) {
    final out = StringBuffer();
    for (final rune in input.runes) {
      final ch = String.fromCharCode(rune);
      final i = _latin.indexOf(ch);
      out.write(i < 0 ? ch : _bangla[i]);
    }
    return out.toString();
  }

  /// [input] with its digits in the script of [languageCode] (`bn` → Bangla,
  /// anything else → unchanged).
  static String localize(String input, String languageCode) =>
      languageCode == 'bn' ? toBangla(input) : input;

  /// Parses a number a user may have typed with Bangla digits or thousands
  /// commas. Null when it isn't a number.
  static num? parseNum(String? input) {
    if (input == null) return null;
    final cleaned = toLatin(input).trim().replaceAll(',', '');
    return num.tryParse(cleaned);
  }

  static double? parseDouble(String? input) => parseNum(input)?.toDouble();

  static int? parseInt(String? input) {
    final n = parseNum(input);
    return n is int ? n : n?.toInt();
  }
}
