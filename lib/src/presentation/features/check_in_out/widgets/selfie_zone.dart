// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../view/shift_check_in_page.dart';

/// Dark gradient selfie capture zone with a circular face ring.
///
/// Matches the Figma "Selfie zone" component (node 13045:27225).
class _SelfieZone extends StatelessWidget {
  const _SelfieZone({
    required this.capturedPhotoPath,
    required this.hasError,
    this.errorMessage,
    this.faceValidationError,
    required this.onRetry,
  });

  final String? capturedPhotoPath;
  final bool hasError;
  final String? errorMessage;
  final String? faceValidationError;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.4,
      padding: EdgeInsets.symmetric(
        vertical: dimensions.spacing.s32,
        horizontal: dimensions.padding.p16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dimensions.radius.r16),
        gradient: LinearGradient(
          begin: const Alignment(-0.5, -0.87),
          end: const Alignment(0.5, 0.87),
          colors: [
            colors.selfieZoneGradientStart,
            colors.selfieZoneGradientEnd,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasError) ...[
            _PhotoErrorDialog(
              errorMessage: errorMessage ?? '',
              onRetry: onRetry,
            ),
          ] else ...[
            _FaceRing(capturedPhotoPath: capturedPhotoPath),
            if (faceValidationError != null) ...[
              Gap(dimensions.spacing.s16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: dimensions.padding.p16,
                  vertical: dimensions.spacing.s12,
                ),
                decoration: BoxDecoration(
                  color: colors.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(dimensions.radius.r12),
                  border: Border.all(color: colors.error.withOpacity(0.5)),
                ),
                child: Text(
                  faceValidationError!,
                  textAlign: TextAlign.center,
                  style: context.textStyle.bodyRegular.copyWith(
                    color: colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ] else if (capturedPhotoPath == null) ...[
              Gap(dimensions.spacing.s24),
              Text(
                context.locale.shiftCheckInPhotoInstructions,
                textAlign: TextAlign.center,
                style: context.textStyle.bodyRegular.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _FaceRing extends StatelessWidget {
  const _FaceRing({required this.capturedPhotoPath});

  final String? capturedPhotoPath;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;
    final brandColor = context.color.primary;
    final innerSize = dimensions.spacing.s180 - dimensions.spacing.s4;

    return Container(
      width: dimensions.spacing.s180,
      height: dimensions.spacing.s180,
      padding: EdgeInsets.all(dimensions.spacing.s2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // TODO: Replace with dimension token if available instead of width: 2
        border: Border.all(color: brandColor, width: 2),
      ),
      child: ClipOval(
        child: capturedPhotoPath != null
            ? Image.file(
                File(capturedPhotoPath!),
                width: innerSize,
                height: innerSize,
                fit: BoxFit.cover,
              )
            : const _Placeholder(),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.selfieZonePlaceholderBg,
        // TODO: Replace with dimension token if available instead of width: 2
        border: Border.all(color: colors.selfieZonePlaceholderBorder, width: 2),
      ),
      child: Icon(
        Icons.person_outline,
        size: dimensions.spacing.s40,
        color: colors.selfieZonePlaceholderIcon,
      ),
    );
  }
}
