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
    final colors = context.color;
    final dimensions = context.dimensions;

    return Row(
      children: [
        Expanded(
          child: _PillButton(
            label: context.locale.unlockAction,
            icon: Icons.lock_open_outlined,
            color: colors.success,
            enabled: canUnlock,
            isLoading: isUnlockLoading,
            onTap: onUnlock,
          ),
        ),
        Gap(dimensions.spacing.s12),
        Expanded(
          child: _PillButton(
            label: context.locale.lockAction,
            icon: Icons.lock_outline,
            color: colors.error,
            enabled: canLock,
            isLoading: isLockLoading,
            onTap: onLock,
          ),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.enabled,
    required this.isLoading,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    return FilledButton(
      onPressed: enabled ? onTap : null,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: colors.subtle,
        foregroundColor: colors.onPrimary,
        disabledForegroundColor: colors.disabled,
        padding: EdgeInsets.symmetric(vertical: dimensions.padding.p16),
        shape: const StadiumBorder(),
      ),
      child: isLoading
          ? const LoadingIndicator()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: dimensions.spacing.s20),
                Gap(dimensions.spacing.s8),
                Text(
                  label,
                  style: context.textStyle.labelLarge.copyWith(
                    fontWeight: TextWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }
}
