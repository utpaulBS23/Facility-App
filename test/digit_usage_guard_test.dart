import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Keeps number display and parsing going through the shared helpers, so
/// Bangla mode never shows Latin digits and Bangla-typed digits always parse.
void main() {
  final dartFiles = Directory('lib/src/presentation')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  List<String> offenders(Pattern pattern, {Set<String> allow = const {}}) {
    final found = <String>[];
    for (final file in dartFiles) {
      final path = file.path.replaceAll(Platform.pathSeparator, '/');
      if (allow.any(path.endsWith)) continue;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].trimLeft().startsWith('//')) continue;
        if (lines[i].contains(pattern)) found.add('$path:${i + 1}');
      }
    }
    return found;
  }

  test('no toStringAsFixed in UI code', () {
    // Allowed: seeds an editable field, which must stay Latin.
    expect(
      offenders(
        'toStringAsFixed(',
        allow: {'update_stock/widgets/update_stock_form_entry.dart'},
      ),
      isEmpty,
      reason: 'use context.numbers.decimal / currency / percent',
    );
  });

  test('no static NumberFormatter in UI code', () {
    expect(
      offenders(
        'NumberFormatter.',
        allow: {'core/utils/number_formatter.dart'},
      ),
      isEmpty,
      reason: 'use context.numbers so the widget follows the app language',
    );
  });

  test('no raw tryParse on typed text', () {
    expect(
      offenders(RegExp(r'(int|double|num)\.tryParse\([^)]*\.text')),
      isEmpty,
      reason: 'use Digits.parseInt / parseDouble',
    );
  });
}
