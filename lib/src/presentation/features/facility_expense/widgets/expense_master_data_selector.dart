part of '../view/add_facility_expense_page.dart';

/// Card-style picker for a short list of [MasterDataItemEntity] options —
/// shared by the expense-category and payment-method pickers, both of which
/// are now "pick one master-data item from a short list."
class _MasterDataOptionSelector extends StatelessWidget {
  const _MasterDataOptionSelector({
    required this.options,
    required this.selected,
    required this.hasError,
    required this.onChanged,
  });

  final List<MasterDataItemEntity> options;
  final MasterDataItemEntity? selected;
  final bool hasError;
  final ValueChanged<MasterDataItemEntity> onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    if (options.isEmpty) {
      return BodySmallText(
        context.locale.selectExpenseCategory,
        color: context.color.text.secondary,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: spacing.s12,
          runSpacing: spacing.s12,
          children: [
            for (final option in options)
              _MasterDataOptionCard(
                option: option,
                isSelected: selected?.id == option.id,
                hasError: hasError,
                onTap: () => onChanged(option),
              ),
          ],
        ),
        if (hasError) ...[
          Gap(spacing.s4),
          BodySmallText(
            context.locale.fieldRequired,
            color: context.color.error,
          ),
        ],
      ],
    );
  }
}

class _MasterDataOptionCard extends StatelessWidget {
  const _MasterDataOptionCard({
    required this.option,
    required this.isSelected,
    required this.hasError,
    required this.onTap,
  });

  final MasterDataItemEntity option;
  final bool isSelected;
  final bool hasError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        constraints: BoxConstraints(
          minWidth: (MediaQuery.sizeOf(context).width - spacing.s16 * 2 - spacing.s12) / 2,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s16,
          vertical: spacing.s12,
        ),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          borderRadius: BorderRadius.circular(radius.r12),
          border: Border.all(
            color: hasError && !isSelected
                ? context.color.error
                : isSelected
                ? context.color.primary
                : context.color.borderSubtle,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          option.label,
          textAlign: TextAlign.center,
          style: context.textStyle.bodySmall.copyWith(
            color: isSelected
                ? context.color.primary
                : context.color.text.secondary,
          ),
        ),
      ),
    );
  }
}
