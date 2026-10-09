part of '../view/add_additional_income_page.dart';

enum IncomeEntryType { rentAndOthers, productSell, manualIncome }

class _IncomeEntryTypeSwitch extends StatelessWidget {
  const _IncomeEntryTypeSwitch({
    required this.selectedType,
    required this.onTypeChanged,
    required this.showManualIncome,
  });

  /// Manual income is a cash-collection feature, shown only to users who can
  /// view it.
  final bool showManualIncome;
  final IncomeEntryType selectedType;
  final ValueChanged<IncomeEntryType> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final textStyle = context.textStyle;

    return SegmentedButton<IncomeEntryType>(
      segments: [
        ButtonSegment<IncomeEntryType>(
          value: IncomeEntryType.rentAndOthers,
          label: Text(context.locale.rentAndOthers),
        ),
        ButtonSegment<IncomeEntryType>(
          value: IncomeEntryType.productSell,
          label: Text(context.locale.productSell),
        ),
        if (showManualIncome)
          ButtonSegment<IncomeEntryType>(
            value: IncomeEntryType.manualIncome,
            label: Text(context.locale.manualIncome),
          ),
      ],
      selected: {selectedType},
      showSelectedIcon: false,
      onSelectionChanged: (newSelection) {
        onTypeChanged(newSelection.first);
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
