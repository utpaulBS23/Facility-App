part of '../view/menu_page.dart';

class _MenuHeaderSection extends StatelessWidget {
  const _MenuHeaderSection({
    required this.name,
    required this.email,
    this.partnerName,
    this.appVersion,
    this.buildNumber,
  });

  final String name;
  final String email;
  final String? partnerName;
  final String? appVersion;
  final String? buildNumber;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final textStyle = context.textStyle;

    final headerHeight = MediaQuery.sizeOf(context).height * 0.25;

    return Container(
      height: headerHeight,
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.all(
          Radius.circular(radius.r20),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.s16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: spacing.s36,
                      backgroundColor: color.onPrimary.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.person,
                        color: color.onPrimary,
                        size: spacing.s32,
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
                          if (partnerName case final partner? when partner.isNotEmpty) ...[
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
            if (appVersion != null && appVersion!.isNotEmpty)
              Positioned(
                top: spacing.s12,
                right: spacing.s16,
                child: Container(
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
              ),
          ],
        ),
      ),
    );
  }
}
