// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../view/shift_check_in_page.dart';

class _ShiftCheckInBody extends ConsumerWidget {
  const _ShiftCheckInBody({
    required this.capturedPhotoPath,
    required this.isLoading,
    required this.onTakePhoto,
    required this.onSubmit,
  });

  final String? capturedPhotoPath;
  final bool isLoading;
  final VoidCallback onTakePhoto;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dimensions = context.dimensions;
    final state = ref.watch(selfiePickerProvider);
    final hasError = state.hasError;

    return SingleChildScrollView(
      padding: EdgeInsets.all(dimensions.padding.p16),
      child: Column(
        children: [
          _SelfieZone(capturedPhotoPath: capturedPhotoPath),
          Gap(dimensions.spacing.s12),
          if (hasError) ...[
            _SelfieErrorToast(
              onRequestSupervisor: () => _showBottomSheet(context),
            ),
          ] else ...[
            _TakePhotoButton(
              capturedPhotoPath: capturedPhotoPath,
              isLoading: isLoading,
              onTap: onTakePhoto,
            ),
          ],
          Gap(dimensions.spacing.s16),
          const _AutoDetectedInfoCard(),
          Gap(dimensions.spacing.s16),
          if (hasError) ...[
            OutlinedButton(
              onPressed: () => _showBottomSheet(context),
              child: Text(context.locale.requestSupervisor),
            ),
          ] else ...[
            _SubmitButton(onSubmit: onSubmit),
          ],
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.dimensions.radius.r12),
        ),
      ),
      builder: (_) => const _RequestSupervisorApprovalBottomSheet(),
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
