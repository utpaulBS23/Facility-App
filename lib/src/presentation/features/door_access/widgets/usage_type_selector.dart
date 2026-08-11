part of '../view/door_control_page.dart';

/// Small uppercase section heading shared by the usage/service/reason
/// selectors below.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: context.textStyle.bodySmallUppercase.copyWith(
        color: context.color.text.secondary,
      ),
    );
  }
}

/// Selectable card shared by the usage-type, service-type and reason
/// pickers — an icon badge, a title/subtitle pair, and a selection state
/// shown via border colour, a trailing price [badge], or a check mark.
class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback? onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final accent = isSelected ? colors.text.primary : colors.text.secondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(dimensions.padding.p16),
        decoration: BoxDecoration(
          color: colors.onPrimary,
          border: Border.all(
            color: isSelected ? colors.text.primary : colors.borderSubtle,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(dimensions.radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: dimensions.spacing.s40,
                  height: dimensions.spacing.s40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? colors.text.primary : colors.subtle,
                  ),
                  child: Icon(
                    icon,
                    size: dimensions.spacing.s20,
                    color: isSelected
                        ? colors.onPrimary
                        : colors.text.secondary,
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: dimensions.spacing.s8,
                      vertical: dimensions.spacing.s2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? colors.text.primary : colors.subtle,
                      borderRadius: BorderRadius.circular(dimensions.radius.r6),
                    ),
                    child: Text(
                      badge!,
                      style: context.textStyle.bodySmall.copyWith(
                        color: isSelected
                            ? colors.onPrimary
                            : colors.text.secondary,
                        fontWeight: TextWeight.semibold,
                      ),
                    ),
                  )
                else if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    size: dimensions.spacing.s20,
                    color: accent,
                  ),
              ],
            ),
            Gap(dimensions.spacing.s12),
            Text(
              title,
              style: context.textStyle.labelLarge.copyWith(
                color: colors.text.primary,
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              Gap(dimensions.spacing.s2),
              Text(
                subtitle!,
                style: context.textStyle.bodySmall.copyWith(
                  color: colors.text.secondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UsageTypeSelector extends StatelessWidget {
  const _UsageTypeSelector({required this.selected, required this.onSelect});

  final _UsageType selected;
  final ValueChanged<_UsageType>? onSelect;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(context.locale.usageType),
        Gap(dimensions.spacing.s4),
        Text(
          context.locale.selectWhoWillUse,
          style: context.textStyle.bodyMedium.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        Gap(dimensions.spacing.s12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _OptionCard(
                icon: Icons.person_outline,
                title: context.locale.personal,
                subtitle: context.locale.staffUse,
                isSelected: selected == _UsageType.personal,
                onTap: onSelect == null
                    ? null
                    : () => onSelect!(_UsageType.personal),
              ),
            ),
            Gap(dimensions.spacing.s12),
            Expanded(
              child: _OptionCard(
                icon: Icons.groups_outlined,
                title: context.locale.customer,
                subtitle: context.locale.publicUse,
                isSelected: selected == _UsageType.customer,
                onTap: onSelect == null
                    ? null
                    : () => onSelect!(_UsageType.customer),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
