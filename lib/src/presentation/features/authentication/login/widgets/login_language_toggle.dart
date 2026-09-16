part of '../view/login_page.dart';

class _LoginLanguageToggle extends ConsumerWidget {
  const _LoginLanguageToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localizationProvider);
    final notifier = ref.read(localizationProvider.notifier);
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final isBengali = state.languageCode == 'bn';

    return Container(
      decoration: BoxDecoration(
        color: color.onPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radius.r20),
        border: Border.all(color: color.primary.withValues(alpha: 0.3)),
      ),
      padding: EdgeInsets.all(spacing.s2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LoginLanguageToggleButton(
            label: 'বাং',
            isSelected: isBengali,
            onTap: () => notifier.changeLocale(Locale('bn')),
            onPrimaryColor: color.primary,
            horizontalPadding: spacing.s12,
            verticalPadding: spacing.s6,
            borderRadius: radius.r16,
          ),
          _LoginLanguageToggleButton(
            label: 'En',
            isSelected: !isBengali,
            onTap: () => notifier.changeLocale(Locale('en')),
            onPrimaryColor: color.primary,
            horizontalPadding: spacing.s12,
            verticalPadding: spacing.s6,
            borderRadius: radius.r16,
          ),
        ],
      ),
    );
  }
}

class _LoginLanguageToggleButton extends StatelessWidget {
  const _LoginLanguageToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.onPrimaryColor,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color onPrimaryColor;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected ? onPrimaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          label,
          style: context.textStyle.bodyMedium.copyWith(
            color: isSelected ? context.color.onPrimary : onPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
