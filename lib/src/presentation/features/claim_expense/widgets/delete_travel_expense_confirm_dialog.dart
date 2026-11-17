import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/theme/theme.dart';

/// Confirms permanently deleting a `waiting` travel expense claim.
///
/// Pops `true` to proceed, `false`/`null` to cancel.
class DeleteTravelExpenseConfirmDialog extends StatelessWidget {
  const DeleteTravelExpenseConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return AlertDialog(
      backgroundColor: context.color.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dimensions.radius.r16),
      ),
      icon: CircleAvatar(
        backgroundColor: context.color.error.withValues(alpha: 0.1),
        radius: spacing.s32,
        child: Assets.icons.warning.svg(
          colorFilter: ColorFilter.mode(context.color.error, BlendMode.srcIn),
          width: spacing.s32,
          height: spacing.s32,
        ),
      ),
      iconPadding: EdgeInsets.only(top: spacing.s8, bottom: spacing.s12),
      title: Text(
        context.locale.deleteClaimTitle,
        textAlign: TextAlign.center,
        style: context.textStyle.titleMedium.copyWith(
          color: context.color.text.primary,
        ),
      ),
      content: Text(
        context.locale.deleteClaimMessage,
        textAlign: TextAlign.center,
        style: context.textStyle.bodyRegular.copyWith(
          color: context.color.text.secondary,
        ),
      ),
      actionsPadding: EdgeInsets.fromLTRB(
        spacing.s20,
        spacing.s12,
        spacing.s20,
        spacing.s16,
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r6,
                    ),
                  ),
                  side: BorderSide(color: context.color.borderSubtle),
                ),
                child: Text(
                  context.locale.no,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: context.color.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r6,
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  context.locale.deleteClaim,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
