import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import 'dashboard_icons.dart';
import 'dashboard_tone.dart';

/// How serious a notification is.
enum NotificationSeverity { critical, high, medium, low }

/// A notification: icon tile, title, time, body, severity badge and, once
/// expanded, an action button.
class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.kind,
    required this.tone,
    required this.severity,
    required this.title,
    required this.body,
    required this.timeText,
    this.unread = false,
    this.expanded = false,
    this.actionLabel,
    this.actionIsAssign = false,
    this.onTap,
    this.onAction,
  });

  /// Icon key, e.g. "odour". See [DashboardIconPaths.byKind].
  final String kind;
  final DashboardTone tone;
  final NotificationSeverity severity;
  final String title;
  final String body;
  final String timeText;
  final bool unread;
  final bool expanded;

  /// Shown only when [expanded].
  final String? actionLabel;

  /// Draws the assign-staff icon before the label instead of an arrow after.
  final bool actionIsAssign;
  final VoidCallback? onTap;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final actionLabel = this.actionLabel;
    final showSeverity =
        expanded ||
        severity == NotificationSeverity.critical ||
        severity == NotificationSeverity.high;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: unread
            ? Color.alphaBlend(c.primary.withValues(alpha: 0.04), c.onPrimary)
            : c.onPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            button: true,
            expanded: expanded,
            child: InkWell(
              onTap: onTap,
              child: Container(
                constraints: const BoxConstraints(minHeight: 64),
                padding: EdgeInsets.all(spacing.s12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: tone.background(context),
                        borderRadius: BorderRadius.circular(radius.r10),
                      ),
                      child: DashboardIcon(
                        DashboardIconPaths.byKind[kind] ??
                            DashboardIconPaths.warning,
                        color: tone.foreground(context),
                        size: 18,
                      ),
                    ),
                    SizedBox(width: spacing.s10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              if (unread) ...[
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: c.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: spacing.s6),
                              ],
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: expanded ? null : 1,
                                  overflow: expanded
                                      ? null
                                      : TextOverflow.ellipsis,
                                  style: context.textStyle.labelMedium.copyWith(
                                    color: c.text.primary,
                                    fontWeight: unread
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              SizedBox(width: spacing.s8),
                              Text(
                                timeText,
                                style: context.textStyle.labelSmall.copyWith(
                                  color: c.text.secondary,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing.s4),
                          Text(
                            body,
                            maxLines: expanded ? null : 2,
                            overflow: expanded ? null : TextOverflow.ellipsis,
                            style: context.textStyle.bodySmall.copyWith(
                              color: c.text.secondary,
                              height: 1.45,
                            ),
                          ),
                          if (showSeverity) ...[
                            SizedBox(height: spacing.s4),
                            _SeverityBadge(severity: severity),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded && actionLabel != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.s12 + 36 + spacing.s10,
                0,
                spacing.s12,
                spacing.s12,
              ),
              child: InkWell(
                onTap: onAction,
                borderRadius: BorderRadius.circular(radius.r12),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 44),
                  decoration: BoxDecoration(
                    color: c.onPrimary,
                    borderRadius: BorderRadius.circular(radius.r12),
                    border: Border.all(color: c.borderBrand, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (actionIsAssign) ...[
                        AssignStaffIcon(
                          color: c.text.brand,
                          badge: c.onPrimary,
                        ),
                        SizedBox(width: spacing.s8),
                      ],
                      Text(
                        actionLabel,
                        style: context.textStyle.labelMedium.copyWith(
                          color: c.text.brand,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (!actionIsAssign) ...[
                        SizedBox(width: spacing.s8),
                        DashboardIcon(
                          DashboardIconPaths.arrowRight,
                          color: c.text.brand,
                          size: 16,
                          strokeWidth: 2.2,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({required this.severity});

  final NotificationSeverity severity;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final locale = context.locale;
    final (label, bg, fg) = switch (severity) {
      NotificationSeverity.critical => (
        locale.severityCritical,
        c.error,
        c.onPrimary,
      ),
      NotificationSeverity.high => (
        locale.high,
        DashboardTone.red.background(context),
        DashboardTone.red.foreground(context),
      ),
      NotificationSeverity.medium => (
        locale.medium,
        DashboardTone.orange.background(context),
        DashboardTone.orange.foreground(context),
      ),
      NotificationSeverity.low => (
        locale.low,
        DashboardTone.blue.background(context),
        DashboardTone.blue.foreground(context),
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimensions.spacing.s8,
        vertical: context.dimensions.spacing.s2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: context.textStyle.labelSmall.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
