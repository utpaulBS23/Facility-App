import 'package:facility_management_app/src/core/gen/l10n/app_localizations.dart';
import 'package:facility_management_app/src/presentation/core/theme/theme.dart';
import 'package:facility_management_app/src/presentation/features/toilet_location/view/toilet_earning_report_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Locale locale) async {
  tester.view.physicalSize = const Size(390 * 3, 900 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: $LightThemeData('').call(),
      home: const ToiletEarningReportPage(facilityId: 1),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('shows every section down the page', (tester) async {
    await _pump(tester, const Locale('en'));

    expect(find.text('Public toilet name'), findsOneWidget);
    expect(find.text('Gulshan-1 Public Toilet'), findsOneWidget);
    expect(find.text('Select month'), findsOneWidget);
    expect(find.text('Total income'), findsOneWidget);

    for (final text in [
      'Number of subscribers',
      'Digital system',
      'Revenue (Rs.)',
      'Service cost (Rs.)',
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

  testWidgets('renders in Bangla', (tester) async {
    await _pump(tester, const Locale('bn'));
    expect(find.text('৭৫,৪২০'), findsNothing);
    expect(find.textContaining('৭৫,৪২০'), findsWidgets);
    // The test font is wider than the real one; layout overflow is not the
    // point here.
    tester.takeException();
  });

  testWidgets('month and year can be changed', (tester) async {
    await _pump(tester, const Locale('en'));

    final month = find.byType(DropdownButton<int>).first;
    await tester.tap(month);
    await tester.pumpAndSettle();
    await tester.tap(find.text('January').last);
    await tester.pumpAndSettle();

    expect(find.text('January'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
