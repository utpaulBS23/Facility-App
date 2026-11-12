// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../view/shift_check_in_page.dart';

class _ShiftCheckInBody extends StatelessWidget {
  const _ShiftCheckInBody({
    required this.capturedPhotoPath,
    required this.isLoading,
    required this.isValidating,
    required this.hasCameraError,
    required this.hasError,
    this.errorMessage,
    this.faceValidationError,
    required this.onTakePhoto,
    required this.onRequestSupervisor,
    required this.onSubmit,
    this.supervisorName,
    required this.reasonController,
    this.reasonMode = _ReasonMode.optional,
    this.lateNotice,
  });

  final String? capturedPhotoPath;
  final bool isLoading;
  final bool isValidating;
  // WHY camera-only, not failureType.any: a location failure shouldn't make
  // the selfie zone show "photo capture failed" and swap away the retake
  // button when the camera itself is fine.
  final bool hasCameraError;
  // WHY: hasError is passed from the parent rather than re-watched here
  // to avoid duplicating provider observation in a child widget. Drives the
  // bottom CTA only: any failure (camera or location) routes to the
  // supervisor fallback there.
  final bool hasError;
  final String? errorMessage;
  final String? faceValidationError;
  final VoidCallback onTakePhoto;
  final VoidCallback onRequestSupervisor;
  final VoidCallback onSubmit;
  final String? supervisorName;
  final TextEditingController reasonController;
  final _ReasonMode reasonMode;
  final String? lateNotice;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              dimensions.padding.p16,
              dimensions.padding.p16,
              dimensions.padding.p16,
              0,
            ),
            child: SafeArea(
              top: false,
              bottom: false,
              child: Column(
                children: [
                  _SelfieZone(
                    capturedPhotoPath: capturedPhotoPath,
                    hasError: hasCameraError,
                    errorMessage: errorMessage,
                    faceValidationError: faceValidationError,
                    onRetry: onTakePhoto,
                  ),
                  Gap(dimensions.spacing.s12),
                  if (hasCameraError) ...[
                    _SelfieErrorToast(onRequestSupervisor: onRequestSupervisor),
                  ] else ...[
                    _TakePhotoButton(
                      capturedPhotoPath: capturedPhotoPath,
                      isLoading: isLoading,
                      onTap: onTakePhoto,
                    ),
                  ],
                  Gap(dimensions.spacing.s16),
                  _AutoDetectedInfoCard(supervisorName: supervisorName),
                  Gap(dimensions.spacing.s16),
                  _ReasonSection(
                    mode: reasonMode,
                    controller: reasonController,
                    lateNotice: lateNotice,
                  ),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              dimensions.padding.p16,
              dimensions.spacing.s8,
              dimensions.padding.p16,
              dimensions.spacing.s16,
            ),
            child: hasError
                ? SizedBox(
                    width: double.infinity,
                    height: dimensions.spacing.s44,
                    child: FilledButton(
                      onPressed: onRequestSupervisor,
                      child: Text(context.locale.requestSupervisor),
                    ),
                  )
                : ListenableBuilder(
                    listenable: reasonController,
                    builder: (context, _) => _SubmitButton(
                      onSubmit: onSubmit,
                      isLoading: isValidating,
                      canSubmit:
                          reasonMode != _ReasonMode.required ||
                          reasonController.text.trim().isNotEmpty,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _TakePhotoButton extends StatelessWidget {
  const _TakePhotoButton({
    required this.capturedPhotoPath,
    required this.isLoading,
    required this.onTap,
  });

  final String? capturedPhotoPath;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;
    final label = capturedPhotoPath == null
        ? context.locale.takePhoto
        : context.locale.retake;

    return SizedBox(
      width: double.infinity,
      height: dimensions.spacing.s44,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        child: switch (isLoading) {
          true => const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          false => Text(
            label,
            style: context.textStyle.titleMedium.copyWith(
              color: context.color.primary,
            ),
          ),
        },
      ),
    );
  }
}
