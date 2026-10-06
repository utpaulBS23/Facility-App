import 'package:facility_management_app/src/core/base/failure.dart';
import 'package:facility_management_app/src/core/gen/l10n/app_localizations.dart';
import 'package:facility_management_app/src/data/extension/facility_wise_report_mapper.dart';
import 'package:facility_management_app/src/data/models/toilet_location/facility_wise_report_model.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/domain/entities/toilet_location/facility_wise_report_entity.dart';
import 'package:facility_management_app/src/presentation/core/application_state/session_provider/session_provider.dart';
import 'package:facility_management_app/src/presentation/core/theme/theme.dart';
import 'package:facility_management_app/src/presentation/features/toilet_location/riverpod/toilet_earning_report_provider.dart';
import 'package:facility_management_app/src/presentation/features/toilet_location/view/toilet_earning_report_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSession extends UserSession {
  @override
  UserSessionEntity? build() => UserSessionEntity(
    permissions: const {UserPermission.reportFacilityWiseView},
    accessibleFacilities: const [
      AccessibleFacilityEntity(
        id: 38,
        name: 'Gulshan Public Toilet',
        isPrimary: true,
      ),
    ],
  );
}

const _row = FacilityWiseRowEntity(
  facilityId: 38,
  facilityName: 'Gulshan Public Toilet',
  income: 2600,
  accountsPaid: 980,
  operationDepartment: 0,
  expense: 980,
  toBkash: 0,
  toBank: 1600,
  cashBalance: 1600,
  profitLoss: 1620,
);

String _lastMonth() {
  final now = DateTime.now();
  final d = DateTime(now.year, now.month - 1);

  return '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}';
}

Future<void> _pump(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
  required Future<FacilityWiseReportEntity> Function() load,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 900 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userSessionProvider.overrideWith(_FakeSession.new),
        toiletEarningReportProvider(
          facilityId: 38,
          month: _lastMonth(),
        ).overrideWith((ref) => load()),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        theme: $LightThemeData('').call(),
        home: const ToiletEarningReportPage(facilityId: 38),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('shows the closed month figures', (tester) async {
    await _pump(
      tester,
      load: () async => const FacilityWiseReportEntity(facilities: [_row]),
    );

    expect(find.text('Gulshan Public Toilet'), findsOneWidget);
    expect(find.text('Total income'), findsOneWidget);
    expect(find.text('৳ 2,600'), findsOneWidget);
    expect(find.text('Service cost (Rs.)'), findsOneWidget);
    expect(find.text('Cash moved (Rs.)'), findsOneWidget);
    expect(find.text('Profit/Loss'), findsOneWidget);
    expect(find.text('৳ 1,620'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a month with nothing closed shows the empty state', (
    tester,
  ) async {
    await _pump(
      tester,
      load: () async => const FacilityWiseReportEntity(facilities: []),
    );

    expect(find.text('Nothing closed yet'), findsOneWidget);
    expect(find.text('Total income'), findsNothing);
  });

  testWidgets('a failed load shows retry', (tester) async {
    await _pump(tester, load: () async => throw Failure.permissionDenied);

    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('renders in Bangla', (tester) async {
    await _pump(
      tester,
      locale: const Locale('bn'),
      load: () async => const FacilityWiseReportEntity(facilities: [_row]),
    );

    expect(find.textContaining('২,৬০০'), findsWidgets);
    // The test font is wider than the real one; layout overflow is not the
    // point here.
    tester.takeException();
  });

  test('maps the API response', () {
    final report = FacilityWiseReportResponseModel.fromJson({
      'summary': {'total_income': 2600},
      'facilities': [
        {
          'facility_id': 38,
          'facility_name': 'Gulshan Public Toilet',
          'group_code': '—',
          'income': 2600,
          'accounts_paid': 980,
          'operation_department': 0,
          'expense': 980,
          'to_bkash': 0,
          'to_bank': 1600,
          'cash_balance': 1600,
          'profit_loss': -20.5,
          'month_closed': true,
        },
      ],
      'meta': {'current_page': 1},
    }).toEntity();

    final row = report.first!;
    expect(row.facilityId, 38);
    expect(row.income, 2600);
    expect(row.converted, 1600);
    expect(row.profitLoss, -20.5);
    expect(
      FacilityWiseReportResponseModel.fromJson({
        'facilities': [],
      }).toEntity().first,
      isNull,
    );
  });
}
