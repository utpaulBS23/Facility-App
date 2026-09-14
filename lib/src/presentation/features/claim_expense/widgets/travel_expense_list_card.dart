part of '../view/travel_expenses_page.dart';

class _TravelExpenseListCard extends StatelessWidget {
  const _TravelExpenseListCard({required this.expense});

  final TravelExpenseEntity expense;

  String? _submittedDateLabel() {
    final parsed = DateTime.tryParse(expense.submittedAt)?.toLocal();
    return parsed == null ? null : DateFormatter.shortDate(parsed);
  }

  String? _submittedTimeLabel() {
    final parsed = DateTime.tryParse(expense.submittedAt)?.toLocal();
    return parsed == null ? null : DateFormatter.timeOnly(parsed);
  }

  String get _transportModeLabel => expense.transportLines
      .map((line) => line.vehicleTypeLabel)
      .where((label) => label.isNotEmpty)
      .join(' + ');

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final dateLabel = _submittedDateLabel();
    final timeLabel = _submittedTimeLabel();

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  expense.facilityName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyle.bodyLarge.copyWith(
                    color: color.text.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Gap(spacing.s8),
              StatusDotTag(
                dotColor: expense.status.statusColor(context),
                label: expense.status.localizedName(context),
              ),
            ],
          ),
          if (dateLabel != null || timeLabel != null) ...[
            Gap(spacing.s8),
            Row(
              children: [
                if (dateLabel != null) ...[
                  Icon(
                    Icons.calendar_today_outlined,
                    size: spacing.s14,
                    color: color.text.secondary,
                  ),
                  Gap(spacing.s4),
                  Text(
                    dateLabel,
                    style: context.textStyle.bodySmall.copyWith(
                      color: color.text.secondary,
                    ),
                  ),
                ],
                if (timeLabel != null) ...[
                  Gap(spacing.s12),
                  Icon(
                    Icons.access_time_rounded,
                    size: spacing.s14,
                    color: color.text.secondary,
                  ),
                  Gap(spacing.s4),
                  Text(
                    timeLabel,
                    style: context.textStyle.bodySmall.copyWith(
                      color: color.text.secondary,
                    ),
                  ),
                ],
              ],
            ),
          ],
          Gap(spacing.s12),
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: spacing.s14,
                color: color.text.secondary,
              ),
              Gap(spacing.s4),
              Expanded(
                child: Text(
                  expense.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              ),
            ],
          ),
          if (expense.purpose.isNotEmpty || _transportModeLabel.isNotEmpty) ...[
            Gap(spacing.s4),
            Text(
              [
                if (expense.purpose.isNotEmpty) expense.purpose,
                if (_transportModeLabel.isNotEmpty)
                  if (expense.claimedDistanceKm > 0)
                    '${expense.claimedDistanceKm} km · $_transportModeLabel'
                  else
                    _transportModeLabel,
              ].join(' • '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyle.bodySmall.copyWith(
                color: color.text.secondary,
              ),
            ),
          ],
          Divider(height: spacing.s24, color: color.borderSubtle),
          Text(
            '৳${expense.claimedAmount.toStringAsFixed(0)}',
            style: context.textStyle.headlineSmall.copyWith(
                            color: color.primary,
            )
          ),
        ],
      ),
    );
  }
}
