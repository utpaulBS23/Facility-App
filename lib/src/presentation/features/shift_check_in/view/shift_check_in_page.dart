import 'dart:io';

import 'package:facility_management_app/src/domain/entities/attendance_entity.dart';
import 'package:facility_management_app/src/presentation/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/check_in_info_provider.dart';
import '../riverpod/face_validation_provider.dart';
import '../riverpod/selfie_picker_provider.dart';

part '../widgets/approval_request_body.dart';
part '../widgets/approval_action_buttons.dart';
part '../widgets/auto_detected_info_card.dart';
part '../widgets/photo_error_dialog.dart';
part '../widgets/request_supervisor_approval_bottomsheet.dart';
part '../widgets/selfie_error_toast.dart';
part '../widgets/selfie_zone.dart';
part '../widgets/shift_check_in_body.dart';
part '../widgets/submit_button.dart';
part 'approval_request_page.dart';

class ShiftCheckInPage extends ConsumerStatefulWidget {
  const ShiftCheckInPage({super.key});

  @override
  ConsumerState<ShiftCheckInPage> createState() => _ShiftCheckInPageState();
}

class _ShiftCheckInPageState extends ConsumerState<ShiftCheckInPage> {
  void _onSubmit(String? photoPath) {
    if (photoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.locale.photoRequired),
          backgroundColor: context.color.error,
        ),
      );
      return;
    }
    final partnerId = ref.read(getCurrentUserUseCaseProvider).call()?.partnerId;
    if (partnerId == null) return;
    ref.read(faceValidationProvider.notifier).validate(
      partnerId: partnerId,
      imagePath: photoPath,
    );
  }

  void _onRequestSupervisor() {
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

  @override
  Widget build(BuildContext context) {
    ref.listen(faceValidationProvider, (_, next) {
      if (next.hasValue && next.value != null) {
        context.pushNamed(Routes.approvalRequest);
      } else if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error?.toString() ?? ''),
            backgroundColor: context.color.error,
          ),
        );
      }
    });

    final selfieState = ref.watch(selfiePickerProvider);
    final photoPath = selfieState.valueOrNull;
    final isValidating = ref.watch(faceValidationProvider).isLoading;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: Headline2xlTinyText(context.locale.shiftCheckIn),
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: _ShiftCheckInBody(
        capturedPhotoPath: photoPath,
        isLoading: selfieState.isLoading,
        isValidating: isValidating,
        hasError: selfieState.hasError,
        errorMessage: selfieState.error?.toString(),
        onTakePhoto: () => ref.read(selfiePickerProvider.notifier).pickSelfie(),
        onRequestSupervisor: _onRequestSupervisor,
        onSubmit: () => _onSubmit(photoPath),
      ),
    );
  }
}
