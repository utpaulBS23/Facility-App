part of '../view/menu_page.dart';

class _MenuItemTile extends StatelessWidget {
  const _MenuItemTile({
    required this.config,
    required this.title,
    this.subtitle,
    this.showDivider = true,
    this.onTap,
  });

  final MenuItemConfig config;
  final String title;
  final String? subtitle;
  final bool showDivider;

  /// Replaces the default navigation to [MenuItemConfig.route] — for rows
  /// that need work before they can open (Door Control picks a facility).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;

    return InkWell(
      onTap:
          onTap ??
          () => config.isShellRoute
              ? context.goNamed(config.route)
              : context.pushNamed(config.route),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.padding.p16,
          vertical: context.spacing.s16,
        ),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: showDivider
              ? Border(bottom: BorderSide(color: context.color.borderSubtle))
              : null,
        ),
        child: Row(
          children: [
            config.icon.svg(
              width: context.spacing.s20,
              height: context.spacing.s20,
              colorFilter: ColorFilter.mode(
                context.color.text.secondary,
                BlendMode.srcIn,
              ),
            ),
            Gap(context.spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: context.textStyle.bodyLarge.copyWith(
                      color: context.color.text.primary,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    Gap(context.spacing.s4),
                    Text(
                      subtitle,
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.color.text.muted,
              size: context.spacing.s20,
            ),
          ],
        ),
      ),
    );
  }
}
