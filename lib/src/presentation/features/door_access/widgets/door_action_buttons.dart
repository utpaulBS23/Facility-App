part of '../view/door_control_page.dart';

class _DoorActionButtons extends StatelessWidget {
  const _DoorActionButtons({
    required this.canUnlock,
    required this.canLock,
    required this.isUnlockLoading,
    required this.isLockLoading,
    required this.onUnlock,
    required this.onLock,
  });

  final bool canUnlock;
  final bool canLock;
  final bool isUnlockLoading;
  final bool isLockLoading;
  final VoidCallback onUnlock;
  final VoidCallback onLock;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    // Use FilledButton for the primary action based on current lock state,
    // and OutlinedButton for the secondary action.
    return Row(
      children: [
        Expanded(
          child: canUnlock
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
                  onPressed: canUnlock && !isUnlockLoading ? onUnlock : null,
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
                ),
        ),
        Gap(dimensions.spacing.s12),
        Expanded(
          child: canLock
              ? FilledButton(
                  onPressed: isLockLoading ? null : onLock,
                  child: isLockLoading
                      ? const LoadingIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: dimensions.spacing.s20,
                            ),
                            Gap(dimensions.spacing.s8),
                            Text(context.locale.lockAction),
                          ],
                        ),
                )
              : OutlinedButton(
                  onPressed: canLock && !isLockLoading ? onLock : null,
                  child: isLockLoading
                      ? const LoadingIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: dimensions.spacing.s20,
                            ),
                            Gap(dimensions.spacing.s8),
                            Text(context.locale.lockAction),
                          ],
                        ),
                ),
        ),
      ],
    );
  }
}
