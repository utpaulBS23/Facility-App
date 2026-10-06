import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import 'dashboard_icons.dart';
import 'dashboard_tone.dart';

/// One facility short of staff for a slot.
class StaffShortageRow {
  const StaffShortageRow({
    required this.facility,
    required this.slot,
    required this.when,
    required this.peopleText,
    this.assignLabel,
  });

  final String facility;
  final String slot;

  /// e.g. "Starts 8:00 AM".
  final String when;

  /// e.g. "2 person".
  final String peopleText;

  /// Accessibility label of the Assign button.
  final String? assignLabel;
}

/// Orange alert listing the facilities that are short of staff.
///
/// Two rows show at first; the rest sit behind "Show N more". With a single
/// row the full-width "Assign Staff" button replaces the per-row buttons.
class StaffShortageAlert extends StatefulWidget {
  const StaffShortageAlert({
    super.key,
    required this.totalText,
    required this.summary,
    required this.rows,
    this.onAssign,
  });

  /// The headline number, e.g. "3".
  final String totalText;

  /// e.g. "3 people short across 2 facilities".
  final String summary;
  final List<StaffShortageRow> rows;
  final ValueChanged<StaffShortageRow>? onAssign;

  @override
  State<StaffShortageAlert> createState() => _StaffShortageAlertState();
}

class _StaffShortageAlertState extends State<StaffShortageAlert> {
  static const _collapsedCount = 2;
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final rows = widget.rows;
    final multi = rows.length > 1;
    final shown = _open ? rows : rows.take(_collapsedCount).toList();
    final hidden = rows.length - _collapsedCount;
    final tone = DashboardTone.orange;
    final strong = tone.foreground(context);

    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        padding: EdgeInsets.all(spacing.s14),
        decoration: BoxDecoration(
          color: c.warningAlt,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r16),
          border: Border.all(color: tone.accent(context), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  constraints: const BoxConstraints(minWidth: 40),
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: spacing.s8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: strong,
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r10,
                    ),
                  ),
                  child: Text(
                    widget.totalText,
                    style: context.textStyle.titleLarge.copyWith(
                      color: c.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: spacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.locale.staffShortage,
                        style: context.textStyle.labelLarge.copyWith(
                          color: c.text.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.summary,
                        style: context.textStyle.bodySmall.copyWith(
                          color: c.text.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.s12),
            for (final row in shown) ...[
              _ShortageRow(
                row: row,
                showAssign: multi,
                onAssign: widget.onAssign,
              ),
              SizedBox(height: spacing.s8),
            ],
            if (rows.length > _collapsedCount)
              InkWell(
                onTap: () => setState(() => _open = !_open),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _open
                            ? context.locale.showLess
                            : context.locale.showMoreFacilities(hidden),
                        style: context.textStyle.labelMedium.copyWith(
                          color: strong,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: spacing.s6),
                      RotatedBox(
                        quarterTurns: _open ? 2 : 0,
                        child: DashboardIcon(
                          DashboardIconPaths.chevronDown,
                          color: strong,
                          size: 16,
                          strokeWidth: 2.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (!multi && rows.isNotEmpty)
              _AssignButton(
                label: context.locale.assignStaff,
                full: true,
                onTap: widget.onAssign == null
                    ? null
                    : () => widget.onAssign!(rows.first),
              ),
          ],
        ),
      ),
    );
  }
}

class _ShortageRow extends StatelessWidget {
  const _ShortageRow({
    required this.row,
    required this.showAssign,
    required this.onAssign,
  });

  final StaffShortageRow row;
  final bool showAssign;
  final ValueChanged<StaffShortageRow>? onAssign;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final tone = DashboardTone.orange;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s12,
        vertical: spacing.s10,
      ),
      decoration: BoxDecoration(
        color: c.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  row.facility,
                  style: context.textStyle.labelMedium.copyWith(
                    color: c.text.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: spacing.s8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.s10,
                  vertical: spacing.s4,
                ),
                decoration: BoxDecoration(
                  color: tone.background(context),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  row.peopleText,
                  style: context.textStyle.labelMedium12.copyWith(
                    color: tone.foreground(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.s8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.slot,
                      style: context.textStyle.bodySmall.copyWith(
                        color: c.text.primary,
                      ),
                    ),
                    if (row.when.isNotEmpty)
                      Text(
                        row.when,
                        style: context.textStyle.labelSmall.copyWith(
                          color: c.text.secondary,
                          letterSpacing: 0,
                        ),
                      ),
                  ],
                ),
              ),
              if (showAssign)
                _AssignButton(
                  label: context.locale.assign,
                  semanticLabel: row.assignLabel,
                  onTap: onAssign == null ? null : () => onAssign!(row),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssignButton extends StatelessWidget {
  const _AssignButton({
    required this.label,
    required this.onTap,
    this.semanticLabel,
    this.full = false,
  });

  final String label;
  final String? semanticLabel;
  final bool full;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final radius = BorderRadius.circular(context.dimensions.radius.r12);

    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          width: full ? double.infinity : null,
          constraints: BoxConstraints(minHeight: full ? 48 : 44),
          padding: EdgeInsets.symmetric(horizontal: spacing.s14),
          decoration: BoxDecoration(
            color: c.onPrimary,
            borderRadius: radius,
            border: Border.all(color: c.borderBrand, width: 1.5),
          ),
          child: Row(
            mainAxisSize: full ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AssignStaffIcon(
                color: c.text.brand,
                badge: c.onPrimary,
                size: full ? 24 : 18,
              ),
              SizedBox(width: full ? spacing.s10 : spacing.s6),
              Text(
                label,
                style:
                    (full
                            ? context.textStyle.labelXl
                            : context.textStyle.labelMedium)
                        .copyWith(
                          color: c.text.brand,
                          fontWeight: FontWeight.w700,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
