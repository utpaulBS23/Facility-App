import 'package:facility_management_app/src/core/gen/l10n/app_localizations.dart';
import 'package:facility_management_app/src/presentation/core/theme/theme.dart';
import 'package:facility_management_app/src/presentation/features/dashboard/view/dashboard_page.dart';
import 'package:facility_management_app/src/presentation/core/widgets/category_filter_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dashboard shows the sample content and filters facilities', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390 * 3, 900 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: $LightThemeData('').call(),
        home: const DashboardPage(),
      ),
    );
    await tester.pump();

    expect(find.text('Welcome, Rahim'), findsOneWidget);
    expect(find.text('Staff shortage'), findsOneWidget);
    expect(find.text('Today working'), findsOneWidget);
    // Owner and manager components are on the same page.
    await tester.scrollUntilVisible(
      find.text('Executive details'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Revenue by facility'), findsOneWidget);
    expect(find.text('Issues by status'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Facility summary'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('3 of 3 facilities'), findsOneWidget);

    final chip = find.descendant(
      of: find.byType(CategoryFilterChips<String>).last,
      matching: find.text('Gulshan-2 Market Toilet'),
    );
    await tester.ensureVisible(chip);
    await tester.tap(chip);
    await tester.pump();

    expect(find.text('1 of 3 facilities'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
