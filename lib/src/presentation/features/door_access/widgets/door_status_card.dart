part of '../view/door_control_page.dart';

class _DoorStatusCard extends StatelessWidget {
  const _DoorStatusCard({
    required this.isLocked,
    this.isCached = false,
    this.doorName,
  });

  final bool isLocked;
  final bool isCached;
  final String? doorName;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final statusColor = isLocked ? colors.error : colors.success;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: dimensions.padding.p24),
      decoration: BoxDecoration(
        color: colors.onPrimary,
        border: Border.all(color: colors.borderSubtle),
        borderRadius: BorderRadius.circular(dimensions.radius.r16),
      ),
      child: Column(
        children: [
          if (doorName != null) ...[
            Text(
              doorName!.toUpperCase(),
              style: context.textStyle.labelLarge.copyWith(
                color: colors.text.primary,
              ),
            ),
            Gap(dimensions.spacing.s8),
          ],
          Text(
            context.locale.currentDoorStatus.toUpperCase(),
            style: context.textStyle.bodySmallUppercase.copyWith(
              color: colors.text.secondary,
            ),
          ),
          Gap(dimensions.spacing.s16),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor.withValues(alpha: 0.1),
            ),
            child: Icon(
              isLocked
                  ? Icons.sensor_door_outlined
                  : Icons.meeting_room_outlined,
              size: dimensions.spacing.s40,
              color: statusColor,
            ),
          ),
          Gap(dimensions.spacing.s16),
          Text(
            isLocked
                ? context.locale.doorStatusClosed
                : context.locale.doorStatusOpen,
            style: context.textStyle.headlineSmall.copyWith(color: statusColor),
          ),
          Gap(dimensions.spacing.s4),
          Text(
            isLocked
                ? context.locale.doorIsLocked
                : context.locale.doorIsUnlocked,
            style: context.textStyle.bodyMedium.copyWith(
              color: colors.text.secondary,
            ),
          ),
          if (isCached) ...[
            Gap(dimensions.spacing.s12),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: dimensions.spacing.s8,
                vertical: dimensions.spacing.s4,
              ),
              decoration: BoxDecoration(
                color: colors.warningAlt,
                borderRadius: BorderRadius.circular(dimensions.radius.r12),
                border: Border.all(color: colors.warning, width: 0.5),
              ),
              child: Text(
                '(Cached - Last Known State)',
                style: context.textStyle.bodySmall.copyWith(
                  color: colors.warning,
                  fontSize: 11,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
