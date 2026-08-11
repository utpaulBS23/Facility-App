part of '../view/door_control_page.dart';

class _ServiceTypeSelector extends StatelessWidget {
  const _ServiceTypeSelector({required this.selected, required this.onSelect});

  final _ServiceType? selected;
  final ValueChanged<_ServiceType>? onSelect;

  static const _icons = {
    _ServiceType.urine: Icons.water_drop_outlined,
    _ServiceType.toilet: Icons.wc_outlined,
    _ServiceType.shower: Icons.shower_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(context.locale.serviceType),
        Gap(dimensions.spacing.s4),
        Text(
          context.locale.whatDoesCustomerNeed,
          style: context.textStyle.bodyMedium.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        Gap(dimensions.spacing.s12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final type in _ServiceType.values) ...[
                if (type != _ServiceType.values.first)
                  Gap(dimensions.spacing.s12),
                Expanded(
                  child: _ServiceSelectionCard(
                    icon: _icons[type]!,
                    title: type.label(context),
                    priceText: '৳${type.price}',
                    isSelected: selected == type,
                    onTap: onSelect == null ? null : () => onSelect!(type),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ServiceSelectionCard extends StatelessWidget {
  const _ServiceSelectionCard({
    required this.title,
    required this.priceText,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String priceText;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              top: dimensions.spacing.s8,
              right: dimensions.spacing.s4,
            ),
            padding: EdgeInsets.fromLTRB(
              dimensions.spacing.s12,
              dimensions.spacing.s16,
              dimensions.spacing.s12,
              dimensions.spacing.s12,
            ),
            decoration: BoxDecoration(
              color: colors.onPrimary,
              border: Border.all(
                color: isSelected ? colors.primary : colors.borderSubtle,
                width: isSelected ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(dimensions.radius.r16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(dimensions.spacing.s12),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary : colors.subtle,
                    borderRadius: BorderRadius.circular(dimensions.radius.r12),
                  ),
                  child: Icon(
                    icon,
                    size: dimensions.spacing.s24,
                    color: isSelected ? colors.onPrimary : colors.icon,
                  ),
                ),
                Gap(dimensions.spacing.s8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.textStyle.labelLarge.copyWith(
                    color: colors.text.primary,
                    fontWeight: isSelected
                        ? TextWeight.bold
                        : TextWeight.semibold,
                  ),
                ),
                Gap(dimensions.spacing.s8),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    size: dimensions.spacing.s24,
                    color: colors.primary,
                  )
                else
                  SizedBox(height: dimensions.spacing.s24),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: dimensions.spacing.s12,
                vertical: dimensions.spacing.s4,
              ),
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : colors.brandSubtle,
                borderRadius: BorderRadius.circular(dimensions.radius.r20),
              ),
              child: Text(
                priceText,
                style: context.textStyle.bodySmall.copyWith(
                  color: isSelected ? colors.onPrimary : colors.primary,
                  fontWeight: TextWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
