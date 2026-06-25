import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';

void showTaskProofBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ProofRequiredBottomSheet(),
  );
}

class _ProofRequiredBottomSheet extends StatelessWidget {
  const _ProofRequiredBottomSheet();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        spacing.s24,
        spacing.s12,
        spacing.s24,
        spacing.s24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.color.border,
              borderRadius: .circular(2),
            ),
          ),
          Gap(spacing.s24),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: context.color.brandSubtle,
              shape: .circle,
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              size: 32,
              color: context.color.primary,
            ),
          ),
          Gap(spacing.s16),
          Text(
            context.locale.proofRequired,
            style: context.textStyle.titleMedium.copyWith(
              color: context.color.text.primary,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(spacing.s8),
          Text(
            context.locale.proofRequiredSubtitle,
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.text.secondary,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(spacing.s24),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.locale.takePhoto),
          ),
          Gap(spacing.s12),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.color.primary,
              side: BorderSide(color: context.color.primary),
            ),
            child: Text(context.locale.gallery),
          ),
        ],
      ),
    );
  }
}
