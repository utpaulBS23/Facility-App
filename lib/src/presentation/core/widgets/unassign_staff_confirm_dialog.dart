import 'package:flutter/material.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';

/// Confirms removing one attendant from a shift slot.
///
/// Pops `true` to proceed, `false`/`null` to cancel.
class UnassignStaffConfirmDialog extends StatelessWidget {
  /// Creates an [UnassignStaffConfirmDialog].
  const UnassignStaffConfirmDialog({super.key, required this.staffName});

  /// The attendant's display name, shown in the confirmation message.
  final String staffName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.color.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      title: Text(
        context.locale.unassignStaff,
        style: context.textStyle.titleMedium.copyWith(
          color: context.color.text.primary,
        ),
      ),
      content: Text(
        context.locale.unassignStaffMessage(staffName),
        style: context.textStyle.bodyRegular.copyWith(
          color: context.color.text.secondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            context.locale.no,
            style: context.textStyle.labelLarge.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: context.color.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            context.locale.remove,
            style: context.textStyle.labelLarge.copyWith(
              color: context.color.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
