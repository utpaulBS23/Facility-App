import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';
import 'status_pill.dart';

part 'assigned_staff_tile_action_chip.dart';

/// Row for one attendant already assigned to a shift slot.
///
/// WHY [onRemove]/[onMakeLead] are nullable rather than separate widgets: most
/// callers only display the roster (the list card, other roles on the details
/// page) — only whoever holds the relevant permission gets an action, and
/// passing null keeps that a caller decision instead of extra constructors.
///
/// WHY actions are labelled, not bare icons: a star or a cross alone reads
/// clearly only to someone who already knows what it does, and tooltips don't
/// help on touch — they need a long-press, easy to never discover. A visible
/// word removes the guess without adding visual weight, since each action is
/// a small tonal chip that only appears when there's something to do.
class AssignedStaffTile extends StatelessWidget {
  /// Creates an [AssignedStaffTile].
  const AssignedStaffTile({
    super.key,
    required this.name,
    required this.phone,
    this.isSlotLead = false,
    this.onRemove,
    this.onMakeLead,
  });

  /// The attendant's display name.
  final String name;

  /// The attendant's phone number or staff code.
  final String phone;

  /// Highlights the row as the slot's lead.
  final bool isSlotLead;

  /// Shows a "Remove" action when set.
  final VoidCallback? onRemove;

  /// Shows a "Make Slot Lead" action when set. Never shown on the lead's own
  /// row regardless — there is nothing to promote them to.
  final VoidCallback? onMakeLead;

  bool get _showMakeLead => !isSlotLead && onMakeLead != null;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final hasActions = _showMakeLead || onRemove != null;

    return Container(
      padding: isSlotLead ? EdgeInsets.all(spacing.s8) : EdgeInsets.zero,
      decoration: isSlotLead
          ? BoxDecoration(
              color: context.color.warningAlt,
              borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: spacing.s40,
                height: spacing.s40,
                decoration: BoxDecoration(
                  color: context.color.brandAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: spacing.s24,
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
                          Gap(spacing.s6),
                          StatusPill(
                            label: context.locale.slotLead,
                            background: context.color.onPrimary,
                            foreground: context.color.warning,
                          ),
                        ],
                      ],
                    ),
                    Gap(spacing.s2),
                    Text(
                      phone,
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasActions) ...[
            Gap(spacing.s8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_showMakeLead)
                  _StaffTileActionChip(
                    icon: Icons.star_outline_rounded,
                    label: context.locale.makeSlotLead,
                    color: context.color.warning,
                    background: context.color.warningAlt,
                    onTap: onMakeLead!,
                  ),
                if (_showMakeLead && onRemove != null) Gap(spacing.s8),
                if (onRemove != null)
                  _StaffTileActionChip(
                    icon: Icons.close_rounded,
                    label: context.locale.remove,
                    color: context.color.error,
                    background: context.color.errorAlt,
                    onTap: onRemove!,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
