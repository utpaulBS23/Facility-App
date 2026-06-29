part of '../view/attendance_page.dart';

class _AttendanceSelfieSection extends StatelessWidget {
  const _AttendanceSelfieSection({required this.detail});

  final AttendanceItemEntity detail;

  @override
  Widget build(BuildContext context) {
    final hasCheckIn = detail.checkInSelfie != null;
    final hasCheckOut = detail.checkOutSelfie != null;
    if (!hasCheckIn && !hasCheckOut) return const SizedBox.shrink();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.selfieVerification,
            style: context.textStyle.headline2xlTiny.copyWith(
              color: context.color.text.primary,
            ),
          ),
          Gap(spacing.s12),
          Row(
            children: [
              if (hasCheckIn)
                Expanded(
                  child: _SelfieImage(
                    url: detail.checkInSelfie!,
                    label: context.locale.checkIn,
                    icon: Icons.login_rounded,
                  ),
                ),
              if (hasCheckIn && hasCheckOut) Gap(spacing.s12),
              if (hasCheckOut)
                Expanded(
                  child: _SelfieImage(
                    url: detail.checkOutSelfie!,
                    label: context.locale.checkOut,
                    icon: Icons.logout_rounded,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelfieImage extends StatelessWidget {
  const _SelfieImage({
    required this.url,
    required this.label,
    required this.icon,
  });

  final String url;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radius.r12),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                            : null,
                      ),
                    ),
              errorBuilder: (_, _, _) => Container(
                color: context.color.subtle,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: context.color.text.muted,
                  size: spacing.s40,
                ),
              ),
            ),
          ),
        ),
        Gap(spacing.s8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: context.color.text.secondary),
            Gap(spacing.s4),
            Text(
              label,
              style: context.textStyle.labelSmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
