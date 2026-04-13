part of '../view/attendance_page.dart';

class _AttendanceDetailSupervisorCard extends StatelessWidget {
  const _AttendanceDetailSupervisorCard({required this.approval});

  final SupervisorApprovalEntity approval;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.locale.supervisorApproved,
                style: context.textStyle.titleSmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              _CheckTypeChip(
                label: approval.isCheckOut
                    ? context.locale.checkOut
                    : context.locale.checkIn,
                icon: approval.isCheckOut
                    ? Icons.logout_rounded
                    : Icons.login_rounded,
              ),
            ],
          ),
          Gap(spacing.s16),
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
                      approval.name,
                      style: context.textStyle.headline2xlTiny.copyWith(
                        color: context.color.text.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      approval.phone,
                      style: context.textStyle.titleSmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (approval.reason != null) ...[
            Gap(spacing.s16),
            Container(
              padding: EdgeInsets.all(spacing.s16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.color.onPrimary,
                border: Border.all(color: context.color.borderSubtle),
                borderRadius: BorderRadius.circular(radius.r12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.locale.reasonLabel,
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    approval.reason!,
                    style: context.textStyle.bodyLarge.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
