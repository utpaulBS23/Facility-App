part of '../view/menu_page.dart';

class _MenuHeaderSection extends StatelessWidget {
  const _MenuHeaderSection({
    required this.name,
    required this.email,
    this.partnerName,
  });

  final String name;
  final String email;
  final String? partnerName;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final textStyle = context.textStyle;

    return Container(
      color: color.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(spacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: spacing.s24,
                backgroundColor: color.onPrimary.withValues(alpha: 0.2),
                child: Icon(
                  Icons.person,
                  color: color.onPrimary,
                  size: spacing.s24,
                ),
              ),
              Gap(spacing.s12),
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
                  style: textStyle.bodyMedium.copyWith(color: color.onPrimary),
                ),
              ],
              if (partnerName case final partner? when partner.isNotEmpty) ...[
                Gap(spacing.s12),
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
      ),
    );
  }
}
