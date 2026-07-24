part of '../app_navigation_drawer.dart';

class _DrawerHeaderSection extends StatelessWidget {
  const _DrawerHeaderSection({
    required this.name,
    required this.email,
    required this.role,
  });

  final String name;
  final String email;
  final String role;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(
        spacing.s16,
        topPadding + spacing.s16,
        spacing.s16,
        spacing.s16,
      ),
      color: color.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.onPrimary.withValues(alpha: 0.2),
                child: Icon(
                  Icons.person,
                  color: color.onPrimary,
                  size: 28,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: color.onPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Gap(spacing.s12),
          Text(
            name,
            style: textStyle.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: color.onPrimary,
            ),
          ),
          Gap(spacing.s4),
          Text(
            email,
            style: textStyle.bodyMedium.copyWith(
              color: color.onPrimary,
            ),
          ),
          Gap(spacing.s12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s12,
              vertical: spacing.s4,
            ),
            decoration: BoxDecoration(
              color: color.onPrimary,
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: Text(
              role.toUpperCase(),
              style: textStyle.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: color.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
