import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/form_selector_card.dart';
import '../../../../core/widgets/selection_picker_sheet.dart';

/// A card dropdown for the month and the year: the shared selector card that
/// opens the shared picker sheet.
class ReportDropdown<T> extends StatelessWidget {
  const ReportDropdown({
    super.key,
    required this.caption,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String caption;
  final IconData icon;
  final T value;

  /// Value to its display label.
  final Map<T, String> items;
  final ValueChanged<T> onChanged;

  Future<void> _pick(BuildContext context) async {
    final result = await showModalBottomSheet<({T value})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SelectionPickerSheet<T>(
        title: caption,
        options: [
          for (final e in items.entries) (value: e.key, label: e.value),
        ],
        isSelected: (v) => v == value,
      ),
    );
    if (result != null && result.value != value) onChanged(result.value);
  }

  @override
  Widget build(BuildContext context) {
    return FormSelectorCard.text(
      title: caption,
      icon: icon,
      value: items[value],
      placeholder: caption,
      onTap: () => _pick(context),
    );
  }
}

/// The white card that holds the month and year pickers.
class ReportFilterCard extends StatelessWidget {
  const ReportFilterCard({
    super.key,
    required this.title,
    required this.month,
    required this.year,
  });

  final String title;
  final Widget month;
  final Widget year;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: c.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r16),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textStyle.labelLarge.copyWith(
              color: c.text.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: spacing.s12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: month),
              SizedBox(width: spacing.s12),
              Expanded(child: year),
            ],
          ),
        ],
      ),
    );
  }
}
