import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'text/typography.dart';

/// Shared loading placeholder for a [SelectionPickerSheet]/
/// [FacilityPickerSheet]-shaped bottom sheet while its options are still
/// being fetched.
class PickerSheetLoading extends StatelessWidget {
  const PickerSheetLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 160,
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

/// Shared error/empty placeholder for a picker bottom sheet — used both when
/// the options fetch failed and when it succeeded with an empty list.
class PickerSheetError extends StatelessWidget {
  const PickerSheetError({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimensions.spacing.s16,
          ),
          child: BodySmallText(
            message,
            color: context.color.text.secondary,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
