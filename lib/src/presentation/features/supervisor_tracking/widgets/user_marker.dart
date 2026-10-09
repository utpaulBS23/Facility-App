import 'package:flutter/material.dart';

import '../../../../domain/entities/user_tracking_entity.dart';
import '../../../core/theme/theme.dart';
import 'user_tracking_style.dart';

/// Map marker for a user: their initials in a circle ringed by the status.
class UserMarker extends StatelessWidget {
  const UserMarker({
    super.key,
    required this.position,
    required this.selected,
    required this.onTap,
  });

  final UserPositionEntity position;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = position.statusColor(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: selected ? 4 : 2),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        alignment: Alignment.center,
        child: Text(
          userInitials(position.name),
          style: context.textStyle.labelSmall.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
