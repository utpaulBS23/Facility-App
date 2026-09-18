import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

class ProfileInfoDivider extends StatelessWidget {
  const ProfileInfoDivider({super.key});
  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Padding(padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
      ),
      child: Divider(height: 1, color: context.color.borderSubtle),
    );
  }
}