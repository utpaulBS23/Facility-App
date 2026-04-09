// Author: Claude AI Assistant
// Created: 2026-04-08

part of '../view/shift_check_in_page.dart';

/// Error dialog shown when photo capture fails.
///
/// Matches the Figma design (node 13045:27357).
/// Bottom sheet modal with error illustration and message.
class _PhotoErrorDialog extends StatelessWidget {
  const _PhotoErrorDialog({required this.errorMessage, required this.onRetry});

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(dimensions.radius.r16),
          topRight: Radius.circular(dimensions.radius.r16),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(dimensions.padding.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: context.color.scaffoldBackground,
              radius: 32,
              child: Assets.icons.warning.svg(),
            ),
            Gap(dimensions.spacing.s12),
            LabelLargeText(
              context.locale.photoCaptureFailed,
              textAlign: TextAlign.center,
              color: context.color.scaffoldBackground,
            ),
            Gap(dimensions.spacing.s4),
            BodyLargeText(
              context.locale.cameraAccessRequiredMessage,
              textAlign: TextAlign.center,
              color: context.color.text.muted,
            ),
            Gap(dimensions.spacing.s12),
            ElevatedButton(
              onPressed: onRetry,
              style: ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size(38, 38)),
              ),
              child: Text(context.locale.retry),
            ),
            Gap(dimensions.spacing.s16),
          ],
        ),
      ),
    );
  }
}
