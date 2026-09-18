part of '../view/additional_income_page.dart';

enum IncomeListTab { rentAndOthers, monthlyProductRevenue }

class _IncomeListTabSwitch extends StatelessWidget {
  const _IncomeListTabSwitch({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final IncomeListTab selectedTab;
  final ValueChanged<IncomeListTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final textStyle = context.textStyle;

    return SegmentedButton<IncomeListTab>(
      segments: [
        ButtonSegment<IncomeListTab>(
          value: IncomeListTab.rentAndOthers,
          label: Text(context.locale.rentAndOthers),
        ),
        ButtonSegment<IncomeListTab>(
          value: IncomeListTab.monthlyProductRevenue,
          label: Text(context.locale.monthlyProductRevenue),
        ),
      ],
      selected: {selectedTab},
      showSelectedIcon: false,
      onSelectionChanged: (newSelection) {
        onTabChanged(newSelection.first);
      },
      style: SegmentedButton.styleFrom(
        backgroundColor: color.onPrimary,
        selectedBackgroundColor: color.primary.withValues(alpha: 0.15),
        selectedForegroundColor: color.primary,
        foregroundColor: color.text.secondary,
        textStyle: textStyle.labelLarge.copyWith(fontWeight: FontWeight.bold),
        side: BorderSide(color: color.borderSubtle),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
      ),
    );
  }
}
