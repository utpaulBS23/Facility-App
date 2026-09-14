part of '../view/menu_page.dart';

class _MenuLanguageToggle extends ConsumerWidget {
  const _MenuLanguageToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localizationProvider);
    final notifier = ref.read(localizationProvider.notifier);
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final isBengali = state.languageCode == 'bn';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.color.borderSubtle),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.language_rounded, color: context.color.primary),
              SizedBox(width: spacing.s12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelLargeText('Language'),
                  SizedBox(height: spacing.s2),
                  BodySmallText(
                    context.locale.getLanguageName(state.languageCode),
                    color: context.color.text.secondary,
                  ),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: context.color.background.surface,
              borderRadius: BorderRadius.circular(radius.r20),
              border: Border.all(color: context.color.borderSubtle),
            ),
            padding: EdgeInsets.all(spacing.s2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LanguageToggleButton(
                  label: 'Bn',
                  isSelected: isBengali,
                  onTap: () => notifier.changeLocale(Locale('bn')),
                ),
                _LanguageToggleButton(
                  label: 'En',
                  isSelected: !isBengali,
                  onTap: () => notifier.changeLocale(Locale('en')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageToggleButton extends StatelessWidget {
  const _LanguageToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s12,
          vertical: spacing.s6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.color.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(radius.r16),
        ),
        child: Text(
          label,
          style: context.textStyle.labelMedium.copyWith(
            color: isSelected ? context.color.onPrimary : context.color.text.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
