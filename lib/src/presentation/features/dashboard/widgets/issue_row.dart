import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'dashboard_icons.dart';
import 'dashboard_tone.dart';

/// One issue: warning icon, title, facility and a status dot, tinted by tone.
class IssueRow extends StatelessWidget {
  const IssueRow({
    super.key,
    required this.title,
    required this.facility,
    required this.status,
    this.tone = DashboardTone.blue,
    this.onTap,
  });

  final String title;
  final String facility;
  final String status;
  final DashboardTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final fg = tone.foreground(context);
    final accent = tone.accent(context);

    return Material(
      color: tone.background(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.r12),
        side: BorderSide(color: accent.withValues(alpha: 0.25)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius.r12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 60),
          padding: EdgeInsets.all(spacing.s12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.onPrimary,
                  borderRadius: BorderRadius.circular(radius.r10),
                ),
                child: DashboardIcon(
                  DashboardIconPaths.warning,
                  color: fg,
                  size: 18,
                ),
              ),
              SizedBox(width: spacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textStyle.labelMedium.copyWith(
                        color: c.text.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      facility,
                      style: context.textStyle.bodySmall.copyWith(
                        color: c.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing.s8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: spacing.s6),
                  Text(
                    status,
                    style: context.textStyle.labelMedium12.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
