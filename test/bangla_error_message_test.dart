import 'package:dio/dio.dart';
import 'package:facility_management_app/src/core/base/failure.dart';
import 'package:facility_management_app/src/core/extensions/failure_localization.dart';
import 'package:facility_management_app/src/core/gen/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Failure failureFrom(int status, Object? body) {
  final options = RequestOptions(path: '/x');
  return Failure.mapExceptionToFailure(
    DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response(requestOptions: options, statusCode: status, data: body),
    ),
  );
}

Future<String> shown(WidgetTester tester, Failure failure, String lang) async {
  late String text;
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(lang),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          text = failure.localized(context);
          return const SizedBox();
        },
      ),
    ),
  );
  return text;
}

void main() {
  group('parsing', () {
    test('reads message_bn next to message', () {
      final f = failureFrom(422, {
        'message': 'Account deactivated.',
        'message_bn': 'bn text',
      });
      expect(f.message, 'Account deactivated.');
      expect(f.messageBn, 'bn text');
    });

    test('reads the first validation error in both languages', () {
      final f = failureFrom(422, {
        'message': 'The given data was invalid.',
        'message_bn': 'bn generic',
        'errors': {
          'amount': ['Amount is required.', 'Amount must be a number.'],
        },
        'errors_bn': {
          'amount': ['bn required', 'bn number'],
        },
      });
      expect(f.detail, 'Amount is required.');
      expect(f.detailBn, 'bn required');
    });

    test('tolerates missing and malformed keys', () {
      final f = failureFrom(422, {
        'message': 'Nope.',
        'message_bn': 42,
        'errors': 'oops',
        'errors_bn': {'a': 'not a list'},
      });
      expect(f.messageBn, isNull);
      expect(f.detail, isNull);
      expect(f.detailBn, isNull);
    });
  });

  group('shown text', () {
    testWidgets('Bangla locale shows message_bn', (tester) async {
      final f = failureFrom(422, {'message': 'English', 'message_bn': 'বাংলা'});
      expect(await shown(tester, f, 'bn'), 'বাংলা');
    });

    testWidgets('English locale shows message', (tester) async {
      final f = failureFrom(422, {'message': 'English', 'message_bn': 'বাংলা'});
      expect(await shown(tester, f, 'en'), 'English');
    });

    testWidgets('Bangla locale falls back to English without message_bn', (
      tester,
    ) async {
      final f = failureFrom(422, {'message': 'English'});
      expect(await shown(tester, f, 'bn'), 'English');
    });

    testWidgets('validation shows the first field error, not the generic', (
      tester,
    ) async {
      final f = failureFrom(422, {
        'message': 'The given data was invalid.',
        'message_bn': 'bn generic',
        'errors': {'a': ['Amount is required.']},
        'errors_bn': {'a': ['bn required']},
      });
      expect(await shown(tester, f, 'en'), 'Amount is required.');
      expect(await shown(tester, f, 'bn'), 'bn required');
    });

    testWidgets('validation Bangla falls back to English field error', (
      tester,
    ) async {
      final f = failureFrom(422, {
        'message': 'The given data was invalid.',
        'errors': {'a': ['Amount is required.']},
      });
      expect(await shown(tester, f, 'bn'), 'Amount is required.');
    });

    testWidgets('server 403 shows Bangla; client gate does not', (
      tester,
    ) async {
      final server = failureFrom(403, {
        'message': 'Insufficient permissions.',
        'message_bn': 'পর্যাপ্ত অনুমতি নেই।',
      });
      expect(await shown(tester, server, 'bn'), 'পর্যাপ্ত অনুমতি নেই।');
      expect(
        await shown(tester, Failure.permissionDenied, 'bn'),
        isNot('Client-side permission gate rejected the action.'),
      );
    });
  });
}
