import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';

class BackLeading extends StatelessWidget {
  const BackLeading({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? context.pop,
      child: Row(
        children: [
          Icon(
            Icons.chevron_left_rounded,
            color: context.color.primary,
            size: 28,
          ),
          Text(
            context.locale.back,
            style: context.textStyle.labelXl.copyWith(
              color: context.color.primary,
            ),
          ),
        ],
      ),
    );
  }
}
