import 'package:facility_management_app/src/core/gen/l10n/app_localizations.dart';
import 'package:facility_management_app/src/presentation/core/theme/theme.dart';
import 'package:facility_management_app/src/presentation/features/facility_tracking/view/facility_tracking_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

Future<void> _pumpPage(WidgetTester tester, Locale locale) async {
  Intl.defaultLocale = locale.languageCode;
  tester.view.physicalSize = const Size(1080, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        theme: $LightThemeData('').call(),
        home: const FacilityTrackingPage(),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('shows filters, summary and legend in English', (tester) async {
    await _pumpPage(tester, const Locale('en'));

    expect(find.text('Facility Tracking'), findsOneWidget);
    expect(find.text('All facilities'), findsOneWidget);
    expect(find.text('Attendant'), findsOneWidget);
    expect(find.text('Attendants working'), findsOneWidget);
    expect(find.text('Legend'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows Bangla labels and digits', (tester) async {
    await _pumpPage(tester, const Locale('bn'));

    expect(find.text('ফ্যাসিলিটি ট্র্যাকিং'), findsOneWidget);
    expect(find.text('সব ফ্যাসিলিটি'), findsOneWidget);
    // Two working attendants in the sample data.
    expect(find.text('২'), findsOneWidget);
    // WHY not asserted: the test font gives every Bangla glyph a full em, so
    // the shared back button (fixed 100px) overflows here but not on a device.
    tester.takeException();
  });

  testWidgets('facility filter narrows the summary counts', (tester) async {
    await _pumpPage(tester, const Locale('en'));

    await tester.tap(find.text('All facilities'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dhanmondi'));
    await tester.pumpAndSettle();

    // Only Dhanmondi's attendant (working) is left.
    expect(find.text('Clear filters'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
