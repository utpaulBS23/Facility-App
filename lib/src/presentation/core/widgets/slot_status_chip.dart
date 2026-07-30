import 'package:flutter/material.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';
import 'status_pill.dart';

/// Localized label for a raw backend slot-status string.
///
/// WHY the raw-string fallback: backend enum is
/// 'open'|'in_progress'|'completed'|'missed'|'partial_miss'|'cancelled'|'full',
/// default 'open'. Unknown values fall back to the raw server string rather
/// than being hidden or mistranslated.
String slotStatusLabel(BuildContext context, String status) => switch (status) {
  'open' => context.locale.slotStatusOpen,
  'full' => context.locale.slotStatusFull,
  'in_progress' => context.locale.inProgress,
  'completed' => context.locale.slotStatusCompleted,
  'partial_miss' => context.locale.slotStatusPartialMiss,
  'missed' => context.locale.slotStatusMissed,
  'cancelled' => context.locale.slotStatusCancelled,
  _ => status,
};

/// Accent for a slot status — the pill's text colour, and the dot colour
/// wherever a status renders as a marker instead of a pill.
Color slotStatusColor(BuildContext context, String status) => switch (status) {
  'in_progress' || 'partial_miss' => context.color.warning,
  'completed' || 'full' => context.color.success,
  'missed' => context.color.error,
  'cancelled' => context.color.text.secondary,
  'open' => context.color.primary,
  _ => context.color.text.primary,
};

/// Status pill for a shift slot.
class SlotStatusChip extends StatelessWidget {
  /// Creates a [SlotStatusChip].
  const SlotStatusChip({super.key, required this.status});

  /// Raw backend slot-status string.
  final String status;

  Color _background(BuildContext context) => switch (status) {
    'in_progress' || 'partial_miss' => context.color.warningAlt,
    'completed' || 'full' => context.color.successAlt,
    'missed' => context.color.errorAlt,
    'cancelled' => context.color.scaffoldBackground,
    _ => context.color.brandAccent,
  };

  @override
  Widget build(BuildContext context) {
    return StatusPill(
      label: slotStatusLabel(context, status),
      background: _background(context),
      foreground: slotStatusColor(context, status),
    );
  }
}
