part of '../app_navigation_drawer.dart';

class _DrawerMenuItem extends StatelessWidget {
  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showTrailing = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final textStyle = context.textStyle;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s16,
          vertical: spacing.s12,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(spacing.s12),
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(radius.r12),
              ),
              child: Icon(
                icon,
                color: color.primary,
                size: spacing.s24,
              ),
            ),
            Gap(spacing.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color.text.primary,
                    ),
                  ),
                  Gap(spacing.s4),
                  Text(
                    subtitle,
                    style: textStyle.bodySmall.copyWith(
                      color: color.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
            if (showTrailing) ...[
              Icon(
                Icons.chevron_right,
                color: color.text.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
