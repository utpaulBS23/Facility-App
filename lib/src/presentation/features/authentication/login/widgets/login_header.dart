part of '../view/login_page.dart';

/// Language toggle, optional back link, logo and app name shared by the form
/// and the welcome-back card.
class _LoginHeader extends StatelessWidget {
  const _LoginHeader({required this.canGoBack, required this.onBack});

  final bool canGoBack;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    return Column(
      children: [
        Row(
          children: [
            if (canGoBack)
              TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.chevron_left),
                label: Text(context.locale.accountsBack),
              ),
            const Spacer(),
            _LoginLanguageToggle(),
          ],
        ),
        Gap(dimensions.spacing.s40),
        ApplicationLogo(height: dimensions.spacing.s80),
        Gap(dimensions.spacing.s6),
        HeadlineLargeText(context.locale.appName, textAlign: TextAlign.center),
        Gap(dimensions.spacing.s4),
        BodyRegularText(
          context.locale.appSubtitle,
          color: colors.text.secondary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
