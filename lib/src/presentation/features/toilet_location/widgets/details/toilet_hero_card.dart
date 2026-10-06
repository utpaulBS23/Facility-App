import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// The coloured banner at the top of the toilet details: name, status, address
/// and a row of facts (rating, distance, code).
class ToiletHeroCard extends StatelessWidget {
  const ToiletHeroCard({
    super.key,
    required this.name,
    required this.statusLabel,
    required this.address,
    required this.ratingText,
    required this.distanceText,
    required this.codeText,
  });

  final String name;
  final String statusLabel;
  final String address;
  final String ratingText;
  final String distanceText;
  final String codeText;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final onColor = c.onPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: c.success,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: context.textStyle.titleLarge.copyWith(
                    color: onColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: spacing.s8),
              _Pill(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: onColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: spacing.s6),
                    Text(
                      statusLabel,
                      style: context.textStyle.labelMedium12.copyWith(
                        color: onColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.s8),
          Row(
            children: [
              Icon(Icons.place_outlined, size: 18, color: onColor),
              SizedBox(width: spacing.s8),
              Expanded(
                child: Text(
                  address,
                  style: context.textStyle.bodyMedium.copyWith(color: onColor),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.s12),
          Wrap(
            spacing: spacing.s8,
            runSpacing: spacing.s8,
            children: [
              _Fact(icon: Icons.star_rounded, text: ratingText),
              _Fact(icon: Icons.near_me_outlined, text: distanceText),
              _Fact(text: codeText),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s10,
        vertical: spacing.s4,
      ),
      decoration: BoxDecoration(
        color: context.color.onPrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: child,
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.text, this.icon});

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final onColor = context.color.onPrimary;

    return _Pill(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: onColor),
            SizedBox(width: context.dimensions.spacing.s4),
          ],
          Text(
            text,
            style: context.textStyle.labelMedium12.copyWith(
              color: onColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
