part of '../view/shift_page.dart';

class _ShiftDetailCheckInCard extends StatelessWidget {
  const _ShiftDetailCheckInCard({required this.data});

  final ShiftCardData data;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final checkIn = data.checkInTime;
    final checkOut = data.checkOutTime;

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
