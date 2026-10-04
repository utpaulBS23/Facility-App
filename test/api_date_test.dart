import 'dart:io';

import 'package:facility_management_app/src/core/utils/api_date.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  final asciiOnly = RegExp(r'^[0-9 :\-]+$');

  setUpAll(() async {
    await initializeDateFormatting('bn');
  });

  tearDown(() => Intl.defaultLocale = null);

  group('ApiDate under the Bangla locale', () {
    setUp(() => Intl.defaultLocale = 'bn');

    test('bare DateFormat does write Bangla digits (the bug)', () {
      final out = DateFormat('yyyy-MM-dd').format(DateTime(2026, 10, 2));
      expect(asciiOnly.hasMatch(out), isFalse);
    });

    test('formats with ASCII digits', () {
      final d = DateTime(2026, 10, 2, 9, 5, 7);
      expect(ApiDate.date(d), '2026-10-02');
      expect(ApiDate.dateTime(d), '2026-10-02 09:05:07');
      expect(ApiDate.month(d), '2026-10');
      for (final s in [ApiDate.date(d), ApiDate.dateTime(d), ApiDate.month(d)]) {
        expect(asciiOnly.hasMatch(s), isTrue, reason: s);
      }
    });

    test('parses ASCII strings', () {
      expect(ApiDate.parseDate('2026-10-02'), DateTime(2026, 10, 2));
      expect(
        ApiDate.parseDateTime('2026-10-02 09:05:07'),
        DateTime(2026, 10, 2, 9, 5, 7),
      );
      expect(ApiDate.parseTime('14:30').hour, 14);
      expect(ApiDate.parseTime('14:30:15').second, 15);
    });
  });

  test('no API date pattern is built outside ApiDate', () {
    final pattern = RegExp(r'''DateFormat\(\s*['"]yyyy-MM''');
    final offenders = <String>[];
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final path = entity.path.replaceAll(r'\', '/');
      if (path.endsWith('core/utils/api_date.dart')) continue;
      if (pattern.hasMatch(entity.readAsStringSync())) {
        offenders.add(entity.path);
      }
    }
    expect(offenders, isEmpty, reason: 'use ApiDate instead: $offenders');
  });
}
