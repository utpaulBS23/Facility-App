import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Round floating button used for the zoom and recenter controls on a map.
class MapControlButton extends StatelessWidget {
  const MapControlButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.color.onPrimary,
      shape: CircleBorder(side: BorderSide(color: context.color.borderSubtle)),
      elevation: 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(context.dimensions.spacing.s8),
          child: Icon(icon, size: 20, color: context.color.text.primary),
        ),
      ),
    );
  }
}
