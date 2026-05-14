part of '../view/shift_tab.dart';

class _ShiftDetailCheckInCard extends StatelessWidget {
  const _ShiftDetailCheckInCard({required this.entity});

  final ShiftEntity entity;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final checkIn = entity.checkInTime != null
        ? DateFormatter.isoTimestamp(entity.checkInTime!)
        : null;
    final checkOut = entity.checkOutTime != null
        ? DateFormatter.isoTimestamp(entity.checkOutTime!)
        : null;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.checkIn,
            style: context.textStyle.labelLarge.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s16),
          Row(
            children: [
              Expanded(
                child: _DateTimeTile(
                  icon: Icons.login_rounded,
                  label: context.locale.checkInTime,
                  value: checkIn ?? '—',
                ),
              ),
              Gap(spacing.s8),
              Expanded(
                child: _DateTimeTile(
                  icon: Icons.logout_rounded,
                  label: context.locale.checkOutTime,
                  value: checkOut ?? '—',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
