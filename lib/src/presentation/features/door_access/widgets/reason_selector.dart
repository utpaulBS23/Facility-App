part of '../view/door_control_page.dart';

class _ReasonSelector extends StatelessWidget {
  const _ReasonSelector({required this.selected, required this.onSelect});

  final _Reason? selected;
  final ValueChanged<_Reason>? onSelect;

  static const _icons = {
    _Reason.clean: Icons.cleaning_services_outlined,
    _Reason.toilet: Icons.wc_outlined,
    _Reason.repair: Icons.build_outlined,
    _Reason.inspect: Icons.visibility_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(context.locale.reason),
        Gap(dimensions.spacing.s4),
        Text(
          context.locale.whyOpeningDoor,
          style: context.textStyle.bodyMedium.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        Gap(dimensions.spacing.s12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: dimensions.spacing.s12,
          mainAxisSpacing: dimensions.spacing.s12,
          childAspectRatio: 1.35,
          children: [
            for (final reason in _Reason.values)
              _OptionCard(
                icon: _icons[reason]!,
                title: reason.label(context),
                subtitle: reason.subtitle(context),
                isSelected: selected == reason,
                onTap: onSelect == null ? null : () => onSelect!(reason),
              ),
          ],
        ),
      ],
    );
  }
}
