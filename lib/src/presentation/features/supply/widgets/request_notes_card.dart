import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';

class RequestNotesCard extends StatelessWidget {
  const RequestNotesCard({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.notes,
            style: context.textStyle.bodySmall.copyWith(
              color: color.text.secondary,
            ),
          ),
          Gap(spacing.s8),
          TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: context.locale.requestNotesHint,
              hintStyle: context.textStyle.bodyMedium.copyWith(
                color: color.text.secondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius.r10),
                borderSide: BorderSide(color: color.borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius.r10),
                borderSide: BorderSide(color: color.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius.r10),
                borderSide: BorderSide(color: color.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
