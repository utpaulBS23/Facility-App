part of '../view/menu_page.dart';

class _MenuItemTile extends StatelessWidget {
  const _MenuItemTile({
    required this.config,
    this.showDivider = true,
  });

  final MenuItemConfig config;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(config.route),
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
                    config.label(context),
                    style: context.textStyle.bodyLarge.copyWith(
                      color: context.color.text.primary,
                    ),
                  ),
                  Gap(context.spacing.s4),
                  Text(
                    config.subtitle(context),
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
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
