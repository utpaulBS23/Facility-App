part of '../view/shift_page.dart';

class _ShiftDetailSupervisorCard extends StatelessWidget {
  const _ShiftDetailSupervisorCard({required this.data});

  final ShiftCardData data;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

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
            context.locale.assignedSupervisor,
            style: context.textStyle.titleSmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s20),
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: context.color.brandAccent,
                child: Icon(
                  Icons.person_rounded,
                  color: context.color.text.primary,
                  size: 28,
                ),
              ),
              Gap(spacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.supervisorName,
                      style: context.textStyle.headline2xlTiny.copyWith(
                        color: context.color.text.primary,
                      ),
                    ),
                    Gap(spacing.s4),
                    Text(
                      data.supervisorPhone,
                      style: context.textStyle.titleSmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
