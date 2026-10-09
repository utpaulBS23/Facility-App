import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'dashboard_icons.dart';

/// Greeting row: avatar initial, welcome text, role pill, date and a bell
/// with an unread badge.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.greeting,
    required this.initial,
    required this.role,
    required this.dateText,
    this.unreadText,
    this.onBellTap,
    this.bellLabel,
  });

  final String greeting;
  final String initial;
  final String role;
  final String dateText;

  /// Badge text; null hides the badge.
  final String? unreadText;
  final VoidCallback? onBellTap;
  final String? bellLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: c.onPrimary,
        border: Border(bottom: BorderSide(color: c.borderSubtle)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
            child: Text(
              initial,
              style: context.textStyle.labelXl.copyWith(
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
                  greeting,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyle.labelXl.copyWith(
                    color: c.text.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: spacing.s4),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.s8,
                        vertical: spacing.s2,
                      ),
                      decoration: BoxDecoration(
                        color: c.brandAccent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        role,
                        style: context.textStyle.labelMedium12.copyWith(
                          color: c.text.brand,
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.s8),
                    Flexible(
                      child: Text(
                        dateText,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyle.bodySmall.copyWith(
                          color: c.text.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: spacing.s12),
          Semantics(
            button: true,
            label: bellLabel,
            child: InkWell(
              onTap: onBellTap,
              borderRadius: BorderRadius.circular(radius.r12),
              child: SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: c.onPrimary,
                        borderRadius: BorderRadius.circular(radius.r12),
                        border: Border.all(color: c.borderSubtle),
                      ),
                      alignment: Alignment.center,
                      child: DashboardIcon(
                        DashboardIconPaths.bell,
                        color: c.text.primary,
                      ),
                    ),
                    if (unreadText != null)
                      Positioned(
                        top: -6,
                        right: -6,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 20),
                          height: 20,
                          padding: EdgeInsets.symmetric(horizontal: spacing.s4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: c.primary,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: c.onPrimary, width: 2),
                          ),
                          child: Text(
                            unreadText!,
                            style: context.textStyle.labelSmall.copyWith(
                              color: c.onPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
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
