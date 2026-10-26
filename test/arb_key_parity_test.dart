import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Set<String> _keys(String path) {
  final json = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

  return json.keys.where((k) => !k.startsWith('@')).toSet();
}

void main() {
  // WHY: a key missing from the Bangla file silently renders in English for
  // Bangla users (the generated class falls back to the template), so a new
  // English string must come with its Bangla one.
  test('every English string has a Bangla translation', () {
    final en = _keys('lib/src/core/localization/intl_en.arb');
    final bn = _keys('lib/src/core/localization/intl_bn.arb');

    expect(en.difference(bn), isEmpty);
  });

  test('Bangla file has no keys the English template lacks', () {
    final en = _keys('lib/src/core/localization/intl_en.arb');
    final bn = _keys('lib/src/core/localization/intl_bn.arb');

    expect(bn.difference(en), isEmpty);
  });
}
