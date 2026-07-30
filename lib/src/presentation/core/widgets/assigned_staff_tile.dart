import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';

/// Row for one attendant already assigned to a shift slot.
///
/// WHY [onRemove] is nullable rather than a second widget: most callers only
/// display the roster (the list card, other roles on the details page) — only
/// whoever holds `shift.unassign_attendant` gets the action, and passing null
/// keeps that a caller decision instead of a second constructor.
class AssignedStaffTile extends StatelessWidget {
  /// Creates an [AssignedStaffTile].
  const AssignedStaffTile({
    super.key,
    required this.name,
    required this.phone,
    this.isSlotLead = false,
    this.onRemove,
  });

  /// The attendant's display name.
  final String name;

  /// The attendant's phone number or staff code.
  final String phone;

  /// Highlights the row as the slot's lead.
  final bool isSlotLead;

  /// Shows a trailing remove button when set.
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: isSlotLead ? EdgeInsets.all(spacing.s8) : EdgeInsets.zero,
      decoration: isSlotLead
          ? BoxDecoration(
              color: context.color.brandAccent,
              borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
            )
          : null,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.color.brandAccent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              size: 24,
              color: context.color.text.primary,
            ),
          ),
          Gap(spacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: context.textStyle.labelLarge.copyWith(
                          color: context.color.text.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSlotLead) ...[
                      Gap(spacing.s4),
                      Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: context.color.warning,
                      ),
                    ],
                  ],
                ),
                Gap(spacing.s2),
                Text(
                  isSlotLead ? '$phone · ${context.locale.slotLead}' : phone,
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
          if (onRemove != null)
            IconButton(
              onPressed: onRemove,
              icon: Icon(Icons.close_rounded, color: context.color.primary),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
