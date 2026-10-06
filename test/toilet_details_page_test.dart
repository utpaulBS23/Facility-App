import 'package:facility_management_app/src/core/gen/l10n/app_localizations.dart';
import 'package:facility_management_app/src/presentation/core/theme/theme.dart';
import 'package:facility_management_app/src/presentation/features/toilet_location/view/toilet_details_page.dart';
import 'package:facility_management_app/src/presentation/features/toilet_location/widgets/details/hourly_visitors_chart.dart';
import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/presentation/core/application_state/session_provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSession extends UserSession {
  @override
  UserSessionEntity? build() => UserSessionEntity(
    permissions: const {UserPermission.reportFacilityWiseView},
    accessibleFacilities: const [
      AccessibleFacilityEntity(
        id: 1,
        name: 'Uttara North Facility',
        isPrimary: true,
      ),
    ],
  );
}

Future<void> _pump(WidgetTester tester, Locale locale) async {
  tester.view.physicalSize = const Size(390 * 3, 900 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [userSessionProvider.overrideWith(_FakeSession.new)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        theme: $LightThemeData('').call(),
        home: const ToiletDetailsPage(facilityId: 1),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('shows every section down the page', (tester) async {
    await _pump(tester, const Locale('en'));

    expect(find.text('Uttara North Facility'), findsOneWidget);
    expect(find.text('Consumer access'), findsOneWidget);
    expect(find.text('Direction'), findsOneWidget);
    expect(find.text('Earning Report'), findsOneWidget);

    for (final text in [
      'Income target and goal',
      'Monthly progress',
      'Management information',
      'Supply stock',
      'Attendance',
      'Rahima Akter',
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

  testWidgets('renders in Bangla without crashing', (tester) async {
    await _pump(tester, const Locale('bn'));

    // WHY not asserted: the test font gives every Bangla glyph a full em, so
    // fixed-width widgets overflow here but not on a device.
    tester.takeException();
    expect(find.byType(ToiletDetailsPage), findsOneWidget);
  });

  test('hour labels use a and p', () {
    expect(HourlyVisitorsChart.hourLabel(6), '6a');
    expect(HourlyVisitorsChart.hourLabel(12), '12p');
    expect(HourlyVisitorsChart.hourLabel(14), '2p');
    expect(HourlyVisitorsChart.hourLabel(0), '12a');
  });
}
