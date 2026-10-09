import 'package:facility_management_app/src/core/gen/l10n/app_localizations.dart';
import 'package:facility_management_app/src/domain/entities/menu_configuration_entity.dart';
import 'package:facility_management_app/src/domain/entities/user_route_entity.dart';
import 'package:facility_management_app/src/domain/entities/user_tracking_entity.dart';
import 'package:facility_management_app/src/presentation/core/application_state/menu_configuration_provider/menu_configuration_provider.dart';
import 'package:facility_management_app/src/presentation/core/map/app_map.dart';
import 'package:facility_management_app/src/presentation/core/theme/theme.dart';
import 'package:facility_management_app/src/presentation/features/supervisor_tracking/riverpod/user_route_provider.dart';
import 'package:facility_management_app/src/presentation/features/supervisor_tracking/riverpod/user_tracking_provider.dart';
import 'package:facility_management_app/src/presentation/features/supervisor_tracking/view/supervisor_tracking_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

class _FakeMenuConfig extends MenuConfig {
  @override
  MenuConfigurationEntity? build() => null;
}

final _today = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
);

final _data = UserTrackingEntity(
  positions: [
    UserPositionEntity(
      userId: 1,
      name: 'Shakib Hasan',
      lat: 23.81,
      lng: 90.41,
      facilityName: 'Brainstation 23',
      accuracyMeters: 12.5,
      batteryLevel: 77,
      recordedAt: DateTime.utc(2026, 10, 5, 10, 15),
      online: true,
      activity: UserActivity.onSite,
      withinGeofence: true,
    ),
    UserPositionEntity(
      userId: 2,
      name: 'Shahin Bashar',
      lat: 23.78,
      lng: 90.27,
      recordedAt: DateTime.utc(2026, 10, 5, 9, 40),
      online: false,
      activity: UserActivity.idle,
    ),
  ],
);

Future<void> _pumpPage(WidgetTester tester, Locale locale) async {
  Intl.defaultLocale = locale.languageCode;
  tester.view.physicalSize = const Size(1080, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appMapBuilderProvider.overrideWithValue(
          (context, controller, markers, lines) => const SizedBox.expand(),
        ),
        menuConfigProvider.overrideWith(_FakeMenuConfig.new),
        userTrackingProvider.overrideWith((ref) async => _data),
        userRouteProvider(userId: 1, date: _today).overrideWith(
          (ref) async => const UserRouteEntity(
            legs: [
              RouteLegEntity(
                id: 10,
                fromName: 'Brainstation 23',
                toName: 'Gulshan Toilet',
                trail: [
                  RoutePointEntity(lat: 23.78, lng: 90.41),
                  RoutePointEntity(lat: 23.79, lng: 90.42),
                ],
                hasTravelExpense: true,
              ),
            ],
          ),
        ),
        userRouteProvider(
          userId: 2,
          date: _today,
        ).overrideWith((ref) async => const UserRouteEntity()),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        theme: $LightThemeData('').call(),
        home: const SupervisorTrackingPage(),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('shows the summary, chips and a card per user', (tester) async {
    await _pumpPage(tester, const Locale('en'));

    expect(find.text('1 of 2 users online'), findsOneWidget);
    expect(find.text('All (2)'), findsOneWidget);
    expect(find.text('Online (1)'), findsOneWidget);
    expect(find.text('Offline (1)'), findsOneWidget);
    expect(find.text('Shakib Hasan'), findsOneWidget);
    expect(find.text('Shahin Bashar'), findsOneWidget);
    // No facility on the second user.
    expect(find.text('Unassigned'), findsOneWidget);
    expect(find.text('On-site — checked in'), findsOneWidget);
    expect(find.text('Inside'), findsOneWidget);
    expect(find.text('N/A'), findsOneWidget);
    expect(find.text('77%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the Online chip keeps only online users', (tester) async {
    await _pumpPage(tester, const Locale('en'));

    await tester.tap(find.text('Online (1)'));
    await tester.pumpAndSettle();

    expect(find.text('Shakib Hasan'), findsOneWidget);
    expect(find.text('Shahin Bashar'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows Bangla digits', (tester) async {
    await _pumpPage(tester, const Locale('bn'));

    expect(find.text('২ জনের মধ্যে ১ জন অনলাইন'), findsOneWidget);
    expect(find.text('৭৭%'), findsOneWidget);
    // WHY not asserted: the test font gives every Bangla glyph a full em, so
    // fixed-width widgets overflow here but not on a device.
    tester.takeException();
  });

  testWidgets('Visited route tab shows legs of the picked user', (
    tester,
  ) async {
    await _pumpPage(tester, const Locale('en'));

    await tester.tap(find.text('Visited route'));
    await tester.pumpAndSettle();
    expect(find.text('Select a user to see their route'), findsOneWidget);

    await tester.tap(find.byType(DropdownButton<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shakib Hasan').last);
    await tester.pumpAndSettle();

    expect(find.text('Brainstation 23 → Gulshan Toilet'), findsOneWidget);
    expect(find.text('2 GPS points'), findsOneWidget);
    expect(find.text('Travel claim filed'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Visited route tab says so when a day has no travel', (
    tester,
  ) async {
    await _pumpPage(tester, const Locale('en'));

    await tester.tap(find.text('Visited route'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shahin Bashar').last);
    await tester.pumpAndSettle();

    expect(find.text('No travel data for this day'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
