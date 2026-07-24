import 'package:flutter/material.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';

/// Full-width call to action for assigning staff to a shift slot.
///
/// Shows a disabled "Slot full" state when [isSlotFull] is true.
class AssignStaffButton extends StatelessWidget {
  /// Creates an [AssignStaffButton].
  const AssignStaffButton({
    super.key,
    required this.onTap,
    this.isSlotFull = false,
  });

  /// Called when tapped, unless [isSlotFull] is true.
  final VoidCallback onTap;

  /// Disables the button and swaps the label to "Slot full".
  final bool isSlotFull;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SizedBox(
      width: double.infinity,
      height: spacing.s44,
      child: OutlinedButton.icon(
        onPressed: isSlotFull ? null : onTap,
        icon: const Icon(Icons.person_add_outlined),
        label: Text(
          isSlotFull ? context.locale.slotFull : context.locale.assignStaff,
        ),
      ),
    );
  }
}
