import 'dart:io';

import 'package:facility_management_app/src/domain/entities/attendance_entity.dart';
import 'package:facility_management_app/src/presentation/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/check_in_info_entity.dart';
import '../../../../domain/entities/manual_attendance_entity.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/check_in_info_provider.dart';
import '../riverpod/check_out_provider.dart';
import '../riverpod/face_validation_provider.dart';
import '../riverpod/manual_attendance_provider.dart';
import '../riverpod/selfie_picker_provider.dart';

part '../widgets/approval_action_buttons.dart';
part '../widgets/approval_request_body.dart';
part '../widgets/auto_detected_info_card.dart';
part '../widgets/manual_attendance_bottom_sheet.dart';
part '../widgets/photo_error_dialog.dart';
part '../widgets/request_supervisor_approval_bottomsheet.dart';
part '../widgets/selfie_error_toast.dart';
part '../widgets/selfie_zone.dart';
part '../widgets/shift_check_in_body.dart';
part '../widgets/submit_button.dart';
part 'approval_request_page.dart';
part 'shift_check_out_page.dart';

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
    final checkInInfo = ref.read(checkInInfoProvider).valueOrNull;
    if (checkInInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.locationUnavailable)),
      );
      return;
    }
    ref.read(faceValidationProvider.notifier).validate(
      partnerId: partnerId,
      imagePath: photoPath,
      lat: checkInInfo.latitude,
      lng: checkInInfo.longitude,
      address: checkInInfo.location,
    );
  }

  void _onTakePhoto() {
    ref.read(selfiePickerProvider.notifier).pickSelfie();
  }

  void _onManualAttendance() {
    final checkInInfo = ref.read(checkInInfoProvider).valueOrNull;
    if (checkInInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.locationUnavailable)),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.dimensions.radius.r12),
        ),
      ),
      builder: (_) => _ManualAttendanceBottomSheet(
        checkInInfo: checkInInfo,
        withdrawRoute: Routes.shiftCheckIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(faceValidationProvider, (_, next) {
      if (next.hasValue && next.value != null) {
        context.goNamed(Routes.shift);
      } else if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: context.color.error,
          ),
        );
      }
    });

    final selfieState = ref.watch(selfiePickerProvider);
    final photoPath = selfieState.valueOrNull;
    final validationState = ref.watch(faceValidationProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Headline2xlTinyText(context.locale.shiftCheckIn),
        ),
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: _ShiftCheckInBody(
        capturedPhotoPath: photoPath,
        isLoading: selfieState.isLoading,
        isValidating: validationState.isLoading,
        hasError: selfieState.hasError,
        errorMessage: selfieState.error?.toString(),
        faceValidationError: validationState.error?.toString(),
        onTakePhoto: _onTakePhoto,
        onRequestSupervisor: _onManualAttendance,
        onSubmit: () => _onSubmit(photoPath),
      ),
    );
  }
}
