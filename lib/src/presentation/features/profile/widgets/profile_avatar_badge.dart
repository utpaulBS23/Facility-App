import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';

/// Circular avatar showing user initials, with a small status badge
/// overlaid at the bottom-right.
///
/// Pass [badgeIcon] and [badgeColor] to control what the badge shows:
/// - green check for My Profile view
/// - red camera for Edit Profile
class ProfileAvatarBadge extends StatelessWidget {
  const ProfileAvatarBadge({
    super.key,
    required this.initials,
    required this.badgeIcon,
    required this.badgeColor,
    this.radius = 44,
  });

  final String initials;
  final IconData badgeIcon;
  final Color badgeColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final badgeSize = radius * 0.55;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: color.primary.withValues(alpha: 0.1),
          child: Text(
            initials.isNotEmpty ? initials.substring(0, 1).toUpperCase() : '?',
            style: context.textStyle.headlineLarge.copyWith(
              color: color.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
              border: Border.all(color: color.onPrimary, width: 2),
            ),
            child: Icon(
              badgeIcon,
              color: color.onPrimary,
              size: badgeSize * 0.55,
            ),
          ),
        ),
      ],
    );
  }
}

/// Convenience widget — avatar + "Change picture" label below, for Edit Profile.
class ProfileAvatarWithLabel extends StatelessWidget {
  const ProfileAvatarWithLabel({
    super.key,
    required this.initials,
    required this.badgeIcon,
    required this.badgeColor,
    required this.label,
  });

  final String initials;
  final IconData badgeIcon;
  final Color badgeColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileAvatarBadge(
          initials: initials,
          badgeIcon: badgeIcon,
          badgeColor: badgeColor,
        ),
        Gap(context.dimensions.spacing.s8),
        Text(
          label,
          style: context.textStyle.bodySmall.copyWith(
            color: context.color.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
