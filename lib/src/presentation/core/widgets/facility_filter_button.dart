import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// AppBar action for the facility filter — an icon button with a small dot
/// badge when a specific facility (not "All") is selected. Shared shape
/// behind every list page's facility filter trigger.
class FacilityFilterButton extends StatelessWidget {
  const FacilityFilterButton({
    super.key,
    required this.hasSelection,
    required this.onTap,
  });

  /// True when a specific facility (not "All"/none) is selected.
  final bool hasSelection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return IconButton(
      onPressed: onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.apartment_outlined, size: 18),
          if (hasSelection)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: spacing.s8,
                height: spacing.s8,
                decoration: BoxDecoration(
                  color: context.color.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
