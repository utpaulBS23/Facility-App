import 'dart:io';

import 'package:facility_management_app/src/domain/entities/attendance_entity.dart';
import 'package:facility_management_app/src/presentation/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/check_in_entity.dart';
import '../../../../domain/entities/check_in_info_entity.dart';
import '../../../../domain/entities/check_out_entity.dart';
import '../../../../domain/entities/manual_attendance_entity.dart';
import '../../../../core/utils/shift_lateness.dart';
import '../../../../domain/entities/shift_slot_entity.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_dropdown_button_form_field.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_time_field.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../../shift/riverpod/shift_slots_provider.dart';
import '../riverpod/check_in_failure_provider.dart';
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
part '../widgets/reason_section.dart';
part '../widgets/request_supervisor_approval_bottomsheet.dart';
part '../widgets/selfie_error_toast.dart';
part '../widgets/selfie_zone.dart';
part '../widgets/shift_check_in_body.dart';
part '../widgets/submit_button.dart';
part 'approval_request_page.dart';
part 'shift_check_out_page.dart';

class ShiftCheckInPage extends ConsumerStatefulWidget {
  const ShiftCheckInPage({super.key, this.shiftSlotId, this.supervisorName});

  final int? shiftSlotId;

  /// The active slot's supervisor, from the shift-slots payload. Overrides
  /// the logged-in user's own supervisor field (see [_AutoDetectedInfoCard])
  /// when present.
  final String? supervisorName;

  @override
  ConsumerState<ShiftCheckInPage> createState() => _ShiftCheckInPageState();
}

class _ShiftCheckInPageState extends ConsumerState<ShiftCheckInPage> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  /// The moment on-time check-in ends for this slot, or null when the slot
  /// is not in the loaded shifts.
  DateTime? get _deadline {
    final data = ref.read(shiftSlotsProvider).valueOrNull;
    final slotId = widget.shiftSlotId;
    final slot = slotId == null ? null : data?.findSlot(slotId);
    if (data == null || slot == null) return null;

    return checkInDeadline(
      date: data.date,
      startTime: slot.startTime,
      graceMinutes: slot.checkInWindowAfterMinutes,
    );
  }

  _ReasonMode get _reasonMode {
    final deadline = _deadline;
    if (deadline == null) return _ReasonMode.optional;

    return isPast(deadline) ? _ReasonMode.required : _ReasonMode.hidden;
  }

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
    if (checkInInfo == null || !checkInInfo.hasLocation) {
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
          lat: checkInInfo.latitude!,
          lng: checkInInfo.longitude!,
          selfieUrl: photoPath,
          lateCheckInReason:
              _reasonMode == _ReasonMode.hidden ||
                  _reasonController.text.trim().isEmpty
              ? null
              : _reasonController.text.trim(),
        );
  }

  Future<void> _onTakePhoto() async {
    final path = await context.pushNamed<String?>(Routes.selfieCamera);
    if (path == null || !mounted) return;
    ref.read(selfiePickerProvider.notifier).capturePhoto(path);
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
    // WHY no hasLocation check: this is the fallback for when detection
    // itself failed — location or camera — so requiring location here would
    // strand anyone whose location is the thing that's broken.
    if (checkInInfo == null) return;
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
        failureType: ref.read(checkInFailureTypeProvider),
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
    final selfieError = selfieState.error;
    final isNoFace = selfieError is Failure && selfieError.code == 'no_face_detected';
    final locationFailure = ref
        .watch(checkInInfoProvider)
        .valueOrNull
        ?.locationFailure;
    final failureType = ref.watch(checkInFailureTypeProvider);
    // WHY watched: the slot (and its grace period) come from the shifts
    // payload; the page rebuilds if that loads or refreshes.
    ref.watch(shiftSlotsProvider);
    final deadline = _deadline;
    final reasonMode = _reasonMode;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.shiftCheckIn),
      body: _ShiftCheckInBody(
        capturedPhotoPath: photoPath,
        isLoading: selfieState.isLoading,
        isValidating: validationState.isLoading,
        hasError: failureType.any,
        errorMessage:
            selfieError?.localizedMessage(context) ??
            locationFailure?.localizedMessage(context),
        faceValidationError: isNoFace ? context.locale.noFaceDetected : null,
        onTakePhoto: _onTakePhoto,
        onRequestSupervisor: _onManualAttendance,
        onSubmit: () => _onSubmit(photoPath),
        supervisorName: widget.supervisorName,
        reasonController: _reasonController,
        reasonMode: reasonMode,
        lateNotice: reasonMode == _ReasonMode.required && deadline != null
            ? context.locale.lateCheckInNotice(
                context.numbers.phone(wallClockHm(deadline)),
              )
            : null,
      ),
    );
  }
}
