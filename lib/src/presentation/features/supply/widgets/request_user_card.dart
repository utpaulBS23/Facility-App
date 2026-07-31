part of '../view/request_details_page.dart';

class _RequestUserCard extends StatelessWidget {
  const _RequestUserCard({
    required this.headerLabel,
    required this.userName,
    required this.userRole,
    required this.timestampLabel,
  });

  final String headerLabel;
  final String userName;
  final String userRole;
  final String timestampLabel;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerLabel,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s12),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing.s10),
                decoration: BoxDecoration(
                  color: context.color.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: context.color.primary,
                  size: 20,
                ),
              ),
              Gap(spacing.s12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: context.textStyle.titleMedium.copyWith(
                      color: context.color.text.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(spacing.s2),
                  Text(
                    userRole,
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(spacing.s12),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 14,
                color: context.color.text.secondary,
              ),
              Gap(spacing.s4),
              Text(
                timestampLabel,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
