part of '../view/roster_list_page.dart';

/// Toggle chip for one weekday, keyed by [DateTime.weekday] (1=Mon..7=Sun) so
/// the selection maps directly onto [RosterEntity.offDays].
class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.dimensions.spacing.s12,
          vertical: context.dimensions.spacing.s8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.color.brandAccent : context.color.onPrimary,
          border: Border.all(
            color: isSelected
                ? context.color.primary
                : context.color.borderSubtle,
          ),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(
                Icons.check_rounded,
                size: 16,
                color: context.color.primary,
              ),
              Gap(context.dimensions.spacing.s4),
            ],
            Text(
              label,
              style: context.textStyle.labelMedium.copyWith(
                color: isSelected ? context.color.primary : context.color.text.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
