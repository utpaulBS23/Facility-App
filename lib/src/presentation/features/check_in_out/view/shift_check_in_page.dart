import 'dart:io';

import 'package:facility_management_app/src/domain/entities/attendance_entity.dart';
import 'package:facility_management_app/src/presentation/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/check_in_entity.dart';
import '../../../../domain/entities/check_in_info_entity.dart';
import '../../../../domain/entities/check_out_entity.dart';
import '../../../../domain/entities/manual_attendance_entity.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_dropdown_button_form_field.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../../shift/riverpod/shift_slots_provider.dart';
import '../riverpod/check_in_info_provider.dart';
import '../riverpod/check_in_provider.dart';
import '../riverpod/check_out_provider.dart';
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
  const ShiftCheckInPage({super.key, this.shiftSlotId});

  final int? shiftSlotId;

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
    final shiftSlotId = widget.shiftSlotId;
    if (shiftSlotId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.locale.noActiveShift)));
      return;
    }
    final checkInInfo = ref.read(checkInInfoProvider).valueOrNull;
    if (checkInInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.locationUnavailable)),
      );
      return;
    }
    // WHY: no upload-to-storage step exists yet — the captured photo's local
    // path is sent as-is in place of a hosted selfie_url, same value the
    // old face-validation endpoint sent as its multipart `image` field.
    ref
        .read(checkInProvider.notifier)
        .checkIn(
          shiftSlotId: shiftSlotId,
          lat: checkInInfo.latitude,
          lng: checkInInfo.longitude,
          selfieUrl: photoPath,
        );
  }

  void _onTakePhoto() {
    ref.read(selfiePickerProvider.notifier).pickSelfie();
  }

  // WHY: the shift tab's slots list is fetched once on mount, so a check-in
  // made from here would otherwise leave it showing pre-check-in state until
  // the user manually changes the date.
  void _refreshShiftSlots() {
    ref
        .read(shiftSlotsProvider.notifier)
        .fetch(date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  void _showWarnings(List<CheckInWarningEntity> warnings) {
    final messages = warnings
        .map((warning) => warning.message)
        .where((message) => message.isNotEmpty)
        .toList();
    if (messages.isEmpty) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(messages.join('\n'))));
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
        shiftSlotId: widget.shiftSlotId,
        withdrawRoute: Routes.shiftCheckIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(checkInProvider, (_, next) {
      if (next.hasValue && next.value != null) {
        final entity = (next.value as Success<CheckInEntity, Failure>).data;
        if (entity != null) _showWarnings(entity.warnings);
        _refreshShiftSlots();
        context.goNamed(Routes.shift);
      } else if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!.localizedMessage(context)),
            backgroundColor: context.color.error,
          ),
        );
      }
    });

    final selfieState = ref.watch(selfiePickerProvider);
    final photoPath = selfieState.valueOrNull;
    final validationState = ref.watch(checkInProvider);

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
