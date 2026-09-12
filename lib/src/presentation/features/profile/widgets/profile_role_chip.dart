import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class ProfileRoleChip extends StatelessWidget {
  const ProfileRoleChip({super.key, required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final textStyle = context.textStyle;
    
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius; 

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s12,
        vertical: spacing.s6,
      ),
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radius.r20),
      ),
      child: Transform.translate(
        offset: const Offset(0, 1), 
        child: Text(
          role.toUpperCase(),
          style: textStyle.labelSmall.copyWith(
            color: color.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}