import 'package:facility_management_app/src/core/gen/l10n/app_localizations.dart';
import 'package:facility_management_app/src/presentation/core/theme/theme.dart';
import 'package:facility_management_app/src/presentation/core/widgets/form_selector_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Widget card) => tester.pumpWidget(
  MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: $LightThemeData('').call(),
    home: Scaffold(body: Center(child: card)),
  ),
);

void main() {
  testWidgets('shows the title, the value and a chevron', (tester) async {
    await _pump(
      tester,
      FormSelectorCard.text(
        title: 'Facility',
        icon: Icons.location_on_outlined,
        value: 'Uttara North',
        placeholder: 'Select facility',
        onTap: () {},
      ),
    );

    expect(find.text('Facility'), findsOneWidget);
    expect(find.text('Uttara North'), findsOneWidget);
    expect(find.text('Select facility'), findsNothing);
    expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
  });

  testWidgets('shows the placeholder while nothing is picked', (tester) async {
    await _pump(
      tester,
      FormSelectorCard.text(
        title: 'Facility',
        value: null,
        placeholder: 'Select facility',
        onTap: () {},
      ),
    );

    expect(find.text('Select facility'), findsOneWidget);
  });

  testWidgets('the icon is optional', (tester) async {
    await _pump(
      tester,
      FormSelectorCard.text(
        title: 'Facility',
        value: 'A',
        placeholder: '',
        onTap: () {},
      ),
    );

    // Only the chevron.
    expect(find.byType(Icon), findsOneWidget);
  });

  testWidgets('tapping opens, unless there is no onTap', (tester) async {
    var taps = 0;
    await _pump(
      tester,
      FormSelectorCard.text(
        title: 'Facility',
        value: 'A',
        placeholder: '',
        onTap: () => taps++,
      ),
    );
    await tester.tap(find.byType(FormSelectorCard));
    expect(taps, 1);

    await _pump(
      tester,
      FormSelectorCard.text(
        title: 'Facility',
        value: 'A',
        placeholder: '',
        onTap: null,
      ),
    );
    await tester.tap(find.byType(FormSelectorCard));
    expect(taps, 1);
  });

  testWidgets('an error shows under the card', (tester) async {
    await _pump(
      tester,
      FormSelectorCard.text(
        title: 'Facility',
        value: null,
        placeholder: 'Select facility',
        errorText: 'Required',
        onTap: () {},
      ),
    );

    expect(find.text('Required'), findsOneWidget);
  });
}
