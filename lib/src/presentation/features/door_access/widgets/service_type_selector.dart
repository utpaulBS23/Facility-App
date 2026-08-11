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
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final type in _ServiceType.values) ...[
              if (type != _ServiceType.values.first)
                Gap(dimensions.spacing.s12),
              Expanded(
                child: _OptionCard(
                  icon: _icons[type]!,
                  title: type.label(context),
                  badge: '৳${type.price}',
                  isSelected: selected == type,
                  onTap: onSelect == null ? null : () => onSelect!(type),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
