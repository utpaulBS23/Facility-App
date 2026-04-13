part of '../view/attendance_page.dart';

class _AttendanceDetailSelfieCard extends StatelessWidget {
  const _AttendanceDetailSelfieCard({required this.selfieUrl});

  final String? selfieUrl;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(radius.r12),
        boxShadow: [
          BoxShadow(
            color: context.color.shadow,
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.locale.selfieVerification,
                style: context.textStyle.headline2xlTiny.copyWith(
                  color: context.color.text.primary,
                ),
              ),
              _CheckTypeChip(
                label: context.locale.checkIn,
                icon: Icons.login_rounded,
              ),
            ],
          ),
          Gap(spacing.s12),
          // WHY: CircleAvatar as placeholder — real implementation fetches
          // image from the network via the selfieUrl.
          CircleAvatar(
            radius: 20,
            backgroundColor: context.color.brandAccent,
            child: Icon(
              Icons.person_rounded,
              color: context.color.primary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckTypeChip extends StatelessWidget {
  const _CheckTypeChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: context.color.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: context.textStyle.labelMedium12.copyWith(
            color: context.color.text.primary,
          ),
        ),
      ],
    );
  }
}
