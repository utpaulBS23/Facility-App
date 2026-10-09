import 'package:facility_management_app/src/core/gen/l10n/app_localizations.dart';
import 'package:facility_management_app/src/presentation/features/notification/widgets/notification_data_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<Map<String, String>> _fields(
  WidgetTester tester,
  Map<String, dynamic> data, {
  String language = 'en',
}) async {
  late List<NotificationField> fields;
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(language),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          fields = notificationFields(context, data);

          return const SizedBox();
        },
      ),
    ),
  );

  return {for (final field in fields) field.label: field.value};
}

void main() {
  testWidgets('known values are worded by the app, in both languages', (
    tester,
  ) async {
    final english = await _fields(tester, {
      'attendance_type': 'check_in',
      'request_type': 'leave',
    });
    expect(english.values, ['Check in', 'Leave']);

    final bangla = await _fields(tester, {
      'attendance_type': 'check_out',
      'request_type': 'supply',
    }, language: 'bn');
    expect(bangla.values, ['চেক-আউট', 'সরবরাহ']);
  });

  testWidgets('an unlisted value is made readable, not dropped', (
    tester,
  ) async {
    final fields = await _fields(tester, {'sensor_type': 'hydrogen_sulfide'});

    expect(fields.values, ['Hydrogen sulfide']);
  });

  testWidgets('free text is shown exactly as sent', (tester) async {
    final fields = await _fields(tester, {
      'reason': 'late_bus: stuck in traffic',
      'shift_start_time': '09:00',
    });

    expect(fields.values, ['late_bus: stuck in traffic', '09:00']);
  });

  testWidgets('ids, nulls and unknown keys are left out', (tester) async {
    final fields = await _fields(tester, {
      'issue_id': 4,
      'facility_id': 12,
      'reason': null,
      'brand_new_key': 'x',
    });

    expect(fields, isEmpty);
  });
}
