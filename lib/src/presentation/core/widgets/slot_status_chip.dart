import 'package:flutter/material.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';

/// Status pill for a shift slot.
///
/// WHY the raw-string fallback: backend enum is
/// 'open'|'in_progress'|'completed'|'missed'|'partial_miss'|'cancelled'|'full',
/// default 'open'. Unknown values fall back to the raw server string with
/// the neutral (open) styling rather than being hidden or mistranslated.
class SlotStatusChip extends StatelessWidget {
  /// Creates a [SlotStatusChip].
  const SlotStatusChip({super.key, required this.status});

  /// Raw backend slot-status string.
  final String status;

  String _label(BuildContext context) => switch (status) {
    'open' => context.locale.slotStatusOpen,
    'full' => context.locale.slotStatusFull,
    'in_progress' => context.locale.inProgress,
    'completed' => context.locale.slotStatusCompleted,
    'partial_miss' => context.locale.slotStatusPartialMiss,
    'missed' => context.locale.slotStatusMissed,
    'cancelled' => context.locale.slotStatusCancelled,
    _ => status,
  };

  Color _background(BuildContext context) => switch (status) {
    'in_progress' || 'partial_miss' => context.color.warningAlt,
    'completed' => context.color.successAlt,
    'missed' => context.color.errorAlt,
    'cancelled' => context.color.scaffoldBackground,
    _ => context.color.brandAccent,
  };

  Color _textColor(BuildContext context) => switch (status) {
    'in_progress' || 'partial_miss' => context.color.warning,
    'completed' => context.color.success,
    'missed' => context.color.error,
    'cancelled' => context.color.text.secondary,
    _ => context.color.text.primary,
  };

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.spacing.s8,
        vertical: dimensions.spacing.s2,
      ),
      decoration: BoxDecoration(
        color: _background(context),
        borderRadius: BorderRadius.circular(dimensions.radius.r6),
      ),
      child: Text(
        _label(context),
        style: context.textStyle.bodySmall.copyWith(color: _textColor(context)),
      ),
    );
  }
}
