part of '../view/app_update_dialog.dart';

class _UpdateActionButtons extends StatelessWidget {
  const _UpdateActionButtons({
    required this.isHardUpdate,
    required this.onUpdateNow,
    this.onLater,
  });

  final bool isHardUpdate;
  final VoidCallback onUpdateNow;
  final VoidCallback? onLater;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: context.color.primary,
            foregroundColor: context.color.onPrimary,
            padding: EdgeInsets.symmetric(
              vertical: context.dimensions.spacing.s12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
            ),
          ),
          onPressed: onUpdateNow,
          child: Text(
            context.locale.updateNow,
            style: context.textStyle.labelLarge.copyWith(
              color: context.color.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (!isHardUpdate && onLater != null) ...[
          SizedBox(height: context.dimensions.spacing.s8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: context.color.text.secondary,
              side: BorderSide(color: context.color.borderSubtle),
              padding: EdgeInsets.symmetric(
                vertical: context.dimensions.spacing.s12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
              ),
            ),
            onPressed: onLater,
            child: Text(
              context.locale.later,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
