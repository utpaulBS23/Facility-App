part of '../view/apply_leave_page.dart';

class _SelectAttendantCard extends StatelessWidget {
  const _SelectAttendantCard({
    required this.selectedAttendant,
    required this.onTap,
  });

  final LeaveAttendantEntity? selectedAttendant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: color.onPrimary,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          border: Border.all(
            color: color.borderSubtle,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.locale.selectAttendant,
              style: textStyle.bodyMedium.copyWith(
                color: color.text.secondary,
              ),
            ),
            Gap(spacing.s12),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: color.text.primary,
                  size: spacing.s24,
                ),
                Gap(spacing.s8),
                Expanded(
                  child: Text(
                    selectedAttendant?.name ?? context.locale.attendant,
                    style: textStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color.text.primary,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      selectedAttendant != null
                          ? Icons.edit_outlined
                          : Icons.chevron_right,
                      color: color.text.secondary,
                      size: spacing.s20,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
