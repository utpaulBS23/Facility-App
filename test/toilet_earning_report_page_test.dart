import 'package:facility_management_app/src/core/base/failure.dart';
import 'package:facility_management_app/src/core/gen/l10n/app_localizations.dart';
import 'package:facility_management_app/src/data/extension/facility_report_sources_mapper.dart';
import 'package:facility_management_app/src/data/models/facility_report/facility_report_source_models.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/domain/entities/toilet_location/facility_monthly_report_entity.dart';
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

const _report = FacilityMonthlyReportEntity(
  month: '2026-08',
  toiletUsers: ReportUserCount(women: 9, men: 8),
  urinalUsers: ReportUserCount(women: 0, men: 0),
  showerUsers: ReportUserCount(women: 9, men: 8),
  drinkingWaterUsers: ReportUserCount(women: 0, men: 0),
  incomeLines: [
    ReportAmountLine('toilet', 17),
    ReportAmountLine('shower', 17),
    ReportAmountLine('laundry', 800),
    ReportAmountLine('product_sales', 40),
    ReportAmountLine('sanitary_pad', 25),
  ],
  expenseLines: [ReportAmountLine('water_bill', 1100)],
  appIncome: 0,
  packageIncome: 0,
  bkashCollected: 0,
);

const _empty = FacilityMonthlyReportEntity(
  month: '2026-08',
  toiletUsers: ReportUserCount(women: 0, men: 0),
  urinalUsers: ReportUserCount(women: 0, men: 0),
  showerUsers: ReportUserCount(women: 0, men: 0),
  drinkingWaterUsers: ReportUserCount(women: 0, men: 0),
  incomeLines: [ReportAmountLine('toilet', 100)],
  expenseLines: [],
  appIncome: 0,
  packageIncome: 0,
  bkashCollected: 0,
);

String _month(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}';

String _thisMonth() => _month(DateTime.now());

Widget _app(List<Override> overrides, Locale locale) => ProviderScope(
  overrides: [userSessionProvider.overrideWith(_FakeSession.new), ...overrides],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    theme: $LightThemeData('').call(),
    home: const ToiletEarningReportPage(facilityId: 38),
  ),
);

Future<void> _pump(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
  required Future<FacilityMonthlyReportEntity> Function() load,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 900 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    _app([
      toiletEarningReportProvider(
        facilityId: 38,
        month: _thisMonth(),
      ).overrideWith((ref) => load()),
    ], locale),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('shows every section of the breakdown', (tester) async {
    await _pump(tester, load: () async => _report);

    expect(find.text('Gulshan Public Toilet'), findsOneWidget);
    expect(find.text('Total income'), findsOneWidget);
    // 17 + 17 + 800 + 40 + 25
    expect(find.text('৳ 899'), findsWidgets);

    for (final text in [
      'Number of subscribers',
      'Digital system',
      'Revenue (Tk)',
      'Service cost (Tk)',
      'Water bill',
      'Sanitary pad',
      'Profit/Loss',
    ]) {
      await tester.scrollUntilVisible(
        find.text(text),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(text), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('a loss shows a minus sign', (tester) async {
    await _pump(
      tester,
      load: () async => const FacilityMonthlyReportEntity(
        month: '2026-08',
        toiletUsers: ReportUserCount(women: 0, men: 0),
        urinalUsers: ReportUserCount(women: 0, men: 0),
        showerUsers: ReportUserCount(women: 0, men: 0),
        drinkingWaterUsers: ReportUserCount(women: 0, men: 0),
        incomeLines: [ReportAmountLine('toilet', 100)],
        expenseLines: [ReportAmountLine('rent', 400)],
        appIncome: 0,
        packageIncome: 0,
        bkashCollected: 0,
      ),
    );

    expect(find.text('-৳ 300'), findsWidgets);
  });

  testWidgets('optional revenue lines stay hidden while empty', (tester) async {
    await _pump(tester, load: () async => _empty);

    await tester.scrollUntilVisible(
      find.text('Revenue (Tk)'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Sanitary pad'), findsNothing);
    expect(find.text('Income via app'), findsNothing);
    expect(find.text('Laundry'), findsOneWidget);
  });

  testWidgets('a failed load shows retry', (tester) async {
    await _pump(tester, load: () async => throw Failure.permissionDenied);

    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('renders in Bangla', (tester) async {
    await _pump(tester, locale: const Locale('bn'), load: () async => _report);

    expect(find.textContaining('৮৯৯'), findsWidgets);
    // The test font is wider than the real one; layout overflow is not the
    // point here.
    tester.takeException();
  });

  testWidgets('changing the month reloads', (tester) async {
    tester.view.physicalSize = const Size(390 * 3, 900 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final loaded = <String>[];
    final now = DateTime.now();
    final other = now.month == 3 ? 4 : 3;
    final otherMonth = _month(DateTime(now.year, other));

    await tester.pumpWidget(
      _app([
        toiletEarningReportProvider(
          facilityId: 38,
          month: _thisMonth(),
        ).overrideWith((ref) async {
          loaded.add(_thisMonth());
          return _report;
        }),
        toiletEarningReportProvider(
          facilityId: 38,
          month: otherMonth,
        ).overrideWith((ref) async {
          loaded.add(otherMonth);
          return _report;
        }),
      ], const Locale('en')),
    );
    await tester.pump();
    await tester.pump();
    expect(loaded, [_thisMonth()]);

    // The caption, not the arrow: the whole box must react.
    await tester.tap(find.text('Select month'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(other == 3 ? 'March' : 'April').last);
    await tester.pumpAndSettle();

    expect(loaded, [_thisMonth(), otherMonth]);
  });

  test('source models decode numbers sent as strings and facility shapes', () {
    final cash = ReportCashCollectionModel.fromJson({
      'facility': {'id': 44, 'name': 'A'},
      'collection_date': '2026-08-10',
      'product_selling_amount': '200.50',
      'renting_others_amount': 300,
      'items': [
        {
          'facility_service': {'service_name': 'Toilet'},
          'gender': 'female',
          'quantity': 2,
          'amount': '2.00',
        },
      ],
    }).toRecord();
    expect(cash.facilityId, 44);
    expect(cash.productSelling, 200.5);
    expect(cash.items.single.amount, 2);

    final access = ReportAccessModel.fromJson({
      'facility_id': 7,
      'unlocked_via': 'user_app',
      'price': '5.00',
    }).toRecord();
    expect(access.facilityId, 7);
    expect(access.price, 5);

    final expense = ReportExpenseModel.fromJson({
      'facility': 'ABM Uttara Relief Zone',
      'category': 'water_bill',
      'amount': 100,
      'expense_date': '2026-08-03',
    }).toRecord();
    expect(expense.facilityId, isNull);
  });
}
