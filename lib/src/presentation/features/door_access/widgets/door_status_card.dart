part of '../view/door_control_page.dart';

class _DoorStatusCard extends StatelessWidget {
  const _DoorStatusCard({
    required this.isLocked,
    this.isCached = false,
    this.doorName,
    this.doorStatus,
  });

  final bool isLocked;
  final bool isCached;
  final String? doorName;
  final DoorStatusModel? doorStatus;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final actuallyLocked = doorStatus?.isClosed ?? isLocked;
    final statusColor = actuallyLocked ? colors.error : colors.success;

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
              actuallyLocked
                  ? Icons.sensor_door_outlined
                  : Icons.meeting_room_outlined,
              size: dimensions.spacing.s40,
              color: statusColor,
            ),
          ),
          Gap(dimensions.spacing.s16),
          Text(
            actuallyLocked
                ? context.locale.doorStatusClosed
                : context.locale.doorStatusOpen,
            style: context.textStyle.headlineSmall.copyWith(color: statusColor),
          ),
          Gap(dimensions.spacing.s4),
          Text(
            actuallyLocked
                ? context.locale.doorIsLocked
                : context.locale.doorIsUnlocked,
            style: context.textStyle.bodyMedium.copyWith(
              color: colors.text.secondary,
            ),
          ),
          if (doorStatus != null && !isCached) ...[
            Gap(dimensions.spacing.s12),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: dimensions.spacing.s8,
                vertical: dimensions.spacing.s4,
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(dimensions.radius.r12),
                border: Border.all(color: Colors.green.shade600, width: 0.5),
              ),
              child: Text(
                '(Live from Pi)',
                style: context.textStyle.bodySmall.copyWith(
                  color: Colors.green.shade700,
                  fontSize: 11,
                ),
              ),
            ),
          ],
          if (isCached) ...[
            Gap(dimensions.spacing.s12),
            Container(
              padding: EdgeInsets.all(dimensions.padding.p12),
              decoration: BoxDecoration(
                color: colors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(dimensions.radius.r8),
                border: Border.all(color: colors.warning, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: dimensions.spacing.s16,
                        color: colors.warning,
                      ),
                      Gap(dimensions.spacing.s8),
                      Text(
                        'Last Known State (Offline)',
                        style: context.textStyle.bodySmall.copyWith(
                          color: colors.warning,
                          fontWeight: TextWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Gap(dimensions.spacing.s8),
                  Text(
                    'Gateway is offline. Status may not be current. Reconnect to get live status.',
                    style: context.textStyle.bodySmall.copyWith(
                      color: colors.warning,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
