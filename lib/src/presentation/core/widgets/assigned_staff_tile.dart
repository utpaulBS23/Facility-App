import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../theme/theme.dart';

/// Read-only row for one attendant already assigned to a shift slot.
class AssignedStaffTile extends StatelessWidget {
  /// Creates an [AssignedStaffTile].
  const AssignedStaffTile({super.key, required this.name, required this.phone});

  /// The attendant's display name.
  final String name;

  /// The attendant's phone number or staff code.
  final String phone;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.color.brandAccent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_outline_rounded,
            size: 24,
            color: context.color.text.primary,
          ),
        ),
        Gap(spacing.s16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.primary,
              ),
            ),
            Gap(spacing.s2),
            Text(
              phone,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
