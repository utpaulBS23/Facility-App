part of '../view/attendance_page.dart';

class _AttendanceDetailApproverCard extends StatelessWidget {
  const _AttendanceDetailApproverCard({required this.approver});

  final AttendanceApproverEntity approver;

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
      child: Row(
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
                  context.locale.approvedBy,
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
                Gap(spacing.s4),
                Text(
                  approver.name,
                  style: context.textStyle.headline2xlTiny.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
