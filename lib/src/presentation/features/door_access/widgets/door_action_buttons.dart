part of '../view/door_control_page.dart';

class _DoorActionButtons extends StatelessWidget {
  const _DoorActionButtons({
    required this.canUnlock,
    required this.isUnlockLoading,
    required this.onUnlock,
    this.isOffline = false,
  });

  final bool canUnlock;
  final bool isUnlockLoading;
  final bool isOffline;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    if (isOffline) {
      return Column(
        children: [
          OutlinedButton(
            onPressed: null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_open_outlined,
                  size: dimensions.spacing.s20,
                ),
                Gap(dimensions.spacing.s8),
                Text(context.locale.unlockAction),
              ],
            ),
          ),
          Gap(dimensions.spacing.s12),
          Container(
            padding: EdgeInsets.all(dimensions.padding.p16),
            decoration: BoxDecoration(
              color: context.color.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(dimensions.radius.r12),
              border: Border.all(color: context.color.warning, width: 0.5),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: dimensions.spacing.s16,
                  color: context.color.warning,
                ),
                Gap(dimensions.spacing.s8),
                Expanded(
                  child: Text(
                    'Gateway offline. Unlock disabled.',
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return canUnlock
        ? FilledButton(
            onPressed: isUnlockLoading ? null : onUnlock,
            child: isUnlockLoading
                ? const LoadingIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_open_outlined,
                        size: dimensions.spacing.s20,
                      ),
                      Gap(dimensions.spacing.s8),
                      Text(context.locale.unlockAction),
                    ],
                  ),
          )
        : OutlinedButton(
            onPressed: null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_open_outlined,
                  size: dimensions.spacing.s20,
                ),
                Gap(dimensions.spacing.s8),
                Text(context.locale.unlockAction),
              ],
            ),
          );
  }
}
