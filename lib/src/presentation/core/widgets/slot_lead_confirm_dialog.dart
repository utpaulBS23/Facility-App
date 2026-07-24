import 'package:flutter/material.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';

/// Confirms whether a newly assigned attendant should also lead the slot.
///
/// Pops `true`/`false` for lead/not-lead, or `null` if dismissed.
class SlotLeadConfirmDialog extends StatelessWidget {
  /// Creates a [SlotLeadConfirmDialog].
  const SlotLeadConfirmDialog({super.key, required this.staffName});

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
        context.locale.assignAsSlotLead,
        style: context.textStyle.titleMedium.copyWith(
          color: context.color.text.primary,
        ),
      ),
      content: Text(
        context.locale.assignAsSlotLeadMessage(staffName),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            context.locale.yes,
            style: context.textStyle.labelLarge.copyWith(
              color: context.color.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
