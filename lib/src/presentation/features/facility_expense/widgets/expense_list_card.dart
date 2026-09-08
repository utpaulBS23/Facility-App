part of '../view/facility_expense_page.dart';

class _ExpenseListCard extends StatelessWidget {
  const _ExpenseListCard({required this.expense});

  final FacilityExpenseEntity expense;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final note = expense.note;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: context.color.text.secondary,
              ),
              Gap(spacing.s4),
              BodySmallText(
                DateFormatter.shortDate(expense.expenseDate),
                color: context.color.text.secondary,
              ),
            ],
          ),
          Gap(spacing.s4),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: context.color.text.secondary,
              ),
              Gap(spacing.s4),
              Expanded(
                child: BodySmallText(
                  expense.facilityName,
                  color: context.color.text.secondary,
                ),
              ),
            ],
          ),
          Gap(spacing.s12),
          LabelLargeText(expense.categoryName),
          if (note != null && note.isNotEmpty) ...[
            Gap(spacing.s2),
            BodySmallText(note, color: context.color.text.secondary),
          ],
          Gap(spacing.s8),
          Text(
            '৳${NumberFormatter.format(expense.amount)}',
            style: context.textStyle.headline2xlTiny.copyWith(
              color: context.color.error,
            ),
          ),
          Gap(spacing.s12),
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 14,
                color: context.color.text.secondary,
              ),
              Gap(spacing.s4),
              BodySmallText(
                '${context.locale.recordedBy}: ${expense.recordedByName}',
                color: context.color.text.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
