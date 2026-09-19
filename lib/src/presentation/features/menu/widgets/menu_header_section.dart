part of '../view/menu_page.dart';

class _MenuHeaderSection extends ConsumerWidget {
  const _MenuHeaderSection({
    required this.name,
    required this.email,
    this.partnerName,
    this.avatarUrl,
    this.appVersion,
    this.buildNumber,
  });

  final String name;
  final String email;
  final String? partnerName;
  final String? avatarUrl;
  final String? appVersion;
  final String? buildNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final textStyle = context.textStyle;
    final localeState = ref.watch(localizationProvider);
    final localeNotifier = ref.read(localizationProvider.notifier);
    final isBengali = localeState.languageCode == 'bn';

    final headerHeight = MediaQuery.sizeOf(context).height * 0.22;

    return Container(
      height: headerHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.primary,
            Color.alphaBlend(
              Colors.black.withValues(alpha: 0.40),
              color.primary,
            ),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(radius.r20),
          bottomRight: Radius.circular(radius.r20),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: spacing.s24, left: spacing.s16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 72,
                        height: 72,
                        color: color.onPrimary.withValues(alpha: 0.2),
                        child: avatarUrl != null && avatarUrl!.isNotEmpty
                            ? Image.network(
                                avatarUrl!,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Shimmer.fromColors(
                                    baseColor:
                                        color.onPrimary.withValues(alpha: 0.2),
                                    highlightColor:
                                        color.onPrimary.withValues(alpha: 0.4),
                                    child: Container(
                                      width: 72,
                                      height: 72,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                errorBuilder: (_, _, _) =>
                                    _buildFallbackAvatar(context),
                              )
                            : _buildFallbackAvatar(context),
                      ),
                    ),
                    Gap(spacing.s16),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: textStyle.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color.onPrimary,
                            ),
                          ),
                          if (email.isNotEmpty) ...[
                            Gap(spacing.s4),
                            Text(
                              email,
                              style: textStyle.bodyMedium.copyWith(
                                color: color.onPrimary,
                              ),
                            ),
                          ],
                          if (partnerName case final partner?
                              when partner.isNotEmpty) ...[
                            Gap(spacing.s8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: spacing.s12,
                                vertical: spacing.s4,
                              ),
                              decoration: BoxDecoration(
                                color: color.onPrimary,
                                borderRadius: BorderRadius.circular(radius.r16),
                              ),
                              child: Text(
                                partner.toUpperCase(),
                                style: textStyle.bodySmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: color.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: spacing.s12,
              right: spacing.s16,
              child: Column(
                spacing: spacing.s8,
                children: [
                  if (appVersion != null && appVersion!.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.s12,
                        vertical: spacing.s4,
                      ),
                      decoration: BoxDecoration(
                        color: color.onPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(radius.r16),
                      ),
                      child: Text(
                        'v$appVersion${buildNumber != null && buildNumber!.isNotEmpty ? ' ($buildNumber)' : ''}',
                        style: textStyle.labelSmall.copyWith(
                          color: color.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: color.onPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(radius.r16),
                      border: Border.all(color: color.onPrimary.withValues(alpha: 0.2)),
                    ),
                    padding: EdgeInsets.all(spacing.s2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _HeaderLanguageToggleButton(
                          label: 'বাং',
                          isSelected: isBengali,
                          onTap: () => localeNotifier.changeLocale(Locale('bn')),
                          onPrimaryColor: color.onPrimary,
                          horizontalPadding: spacing.s8,
                          verticalPadding: spacing.s4,
                          borderRadius: radius.r12,
                        ),
                        _HeaderLanguageToggleButton(
                          label: 'En',
                          isSelected: !isBengali,
                          onTap: () => localeNotifier.changeLocale(Locale('en')),
                          onPrimaryColor: color.onPrimary,
                          horizontalPadding: spacing.s8,
                          verticalPadding: spacing.s4,
                          borderRadius: radius.r12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(BuildContext context) {
    final color = context.color;
    final textStyle = context.textStyle;
    final spacing = context.dimensions.spacing;

    if (name.trim().isNotEmpty) {
      return Center(
        child: Text(
          name.trim()[0].toUpperCase(),
          style: textStyle.titleLarge.copyWith(
            color: color.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return Center(
      child: Icon(
        Icons.person,
        color: color.onPrimary,
        size: spacing.s32,
      ),
    );
  }
}

class _HeaderLanguageToggleButton extends StatelessWidget {
  const _HeaderLanguageToggleButton({
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
          color: isSelected ? onPrimaryColor.withValues(alpha: 0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          label,
          style: context.textStyle.labelSmall.copyWith(
            color: onPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
