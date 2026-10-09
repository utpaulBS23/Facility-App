part of 'shift_check_in_page.dart';

/// Check-out requires a selfie, same capture flow as [ShiftCheckInPage] —
/// just no manual-supervisor fallback, since there is no manual check-out
/// path on the backend.
class ShiftCheckOutPage extends ConsumerStatefulWidget {
  const ShiftCheckOutPage({
    super.key,
    required this.attendanceId,
    this.checkInDate,
    this.shiftSlotId,
  });

  final int attendanceId;

  /// The slot being checked out of, when the entry point knows it. Without it
  /// the page cannot tell a late check-out, and keeps an optional reason box.
  final int? shiftSlotId;

  // WHY: a corrected check-out time must stay on the shift's own day — not
  // today's date — so a checkout submitted late (e.g. the morning after a
  // night shift) doesn't silently move the record to the wrong day.
  final DateTime? checkInDate;

  @override
  ConsumerState<ShiftCheckOutPage> createState() => _ShiftCheckOutPageState();
}

class _ShiftCheckOutPageState extends ConsumerState<ShiftCheckOutPage> {
  final _reasonController = TextEditingController();
  TimeOfDay _checkOutTime = TimeOfDay.fromDateTime(DateTime.now());
  // WHY: only send `check_out_time` when the attendant actually corrected it —
  // per the backend doc, omitting it on a live checkout leaves the server
  // stamp untouched; sending the untouched default would be indistinguishable
  // from a correction.
  bool _checkOutTimeEdited = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _onTakePhoto() async {
    final path = await context.pushNamed<String?>(Routes.selfieCamera);
    if (path == null || !mounted) return;
    ref.read(selfiePickerProvider.notifier).capturePhoto(path);
  }

  /// The check-out time as the server will read it, a Dhaka wall clock: the
  /// corrected time on the shift's day, else now.
  DateTime _checkOutMoment() {
    if (!_checkOutTimeEdited) return dhakaWallClock();
    final day = widget.checkInDate ?? DateTime.now();

    return DateTime.utc(
      day.year,
      day.month,
      day.day,
      _checkOutTime.hour,
      _checkOutTime.minute,
    );
  }

  ShiftSlotEntity? _slot(ShiftSlotsEntity? data) {
    final slotId = widget.shiftSlotId;

    return slotId == null ? null : data?.findSlot(slotId);
  }

  /// When check-out opens (the shift's end), or null when the slot is not
  /// known.
  DateTime? get _opens {
    final data = ref.read(shiftSlotsProvider).valueOrNull;
    final slot = _slot(data);
    if (data == null || slot == null) return null;

    return checkOutOpens(date: data.date, endTime: slot.endTime);
  }

  /// The moment on-time check-out ends (the shift's end plus the grace
  /// period), or null when the slot is not known.
  DateTime? get _deadline {
    final data = ref.read(shiftSlotsProvider).valueOrNull;
    final slot = _slot(data);
    if (data == null || slot == null) return null;

    return checkOutDeadline(
      date: data.date,
      endTime: slot.endTime,
      graceMinutes: slot.checkOutWindowAfterMinutes,
    );
  }

  bool get _isEarly => isBefore(_opens, _checkOutMoment());
  bool get _isLate => isPast(_deadline, _checkOutMoment());

  // WHY a reason on both sides: check-out opens when the shift ends, so one
  // before that, or after the grace period, has to be explained.
  _ReasonMode get _reasonMode {
    if (_opens == null) return _ReasonMode.optional;

    return _isEarly || _isLate ? _ReasonMode.required : _ReasonMode.hidden;
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
    final checkInInfo = ref.read(checkInInfoProvider).valueOrNull;
    if (checkInInfo == null || !checkInInfo.hasLocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.locationUnavailable)),
      );
      return;
    }
    // WHY: no upload-to-storage step exists yet — see the matching comment
    // in ShiftCheckInPage._onSubmit.
    final datePart = widget.checkInDate ?? DateTime.now();
    ref
        .read(checkOutProvider.notifier)
        .checkOut(
          attendanceId: widget.attendanceId,
          lat: checkInInfo.latitude!,
          lng: checkInInfo.longitude!,
          selfieUrl: photoPath,
          reason:
              _reasonMode == _ReasonMode.hidden ||
                  _reasonController.text.trim().isEmpty
              ? null
              : _reasonController.text.trim(),
          checkOutTime: _checkOutTimeEdited
              ? DateTime(
                  datePart.year,
                  datePart.month,
                  datePart.day,
                  _checkOutTime.hour,
                  _checkOutTime.minute,
                )
              : null,
        );
  }

  void _showResult(CheckOutEntity? entity) {
    final messages = (entity?.warnings ?? const [])
        .map((warning) => warning.message)
        .where((message) => message.isNotEmpty)
        .toList();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          messages.isNotEmpty
              ? messages.join('\n')
              : context.locale.approvalSuccessfulMessage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(checkOutProvider, (_, next) {
      if (next.hasValue && next.value != null) {
        final entity = (next.value as Success<CheckOutEntity, Failure>).data;
        _showResult(entity);
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
    final checkOutState = ref.watch(checkOutProvider);
    final selfieError = selfieState.error;
    final isNoFace = selfieError is Failure && selfieError.code == 'no_face_detected';
    // WHY watched: the slot (and its grace period) come from the shifts
    // payload; the page rebuilds if that loads or refreshes.
    ref.watch(shiftSlotsProvider);
    final deadline = _deadline;
    final opens = _opens;
    final reasonMode = _reasonMode;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.checkOut),
      body: _ShiftCheckOutBody(
        capturedPhotoPath: photoPath,
        isLoading: selfieState.isLoading,
        isSubmitting: checkOutState.isLoading,
        hasError: selfieState.hasError && !isNoFace,
        errorMessage: selfieError?.localizedMessage(context),
        faceValidationError: isNoFace ? context.locale.noFaceDetected : null,
        onTakePhoto: _onTakePhoto,
        onSubmit: () => _onSubmit(photoPath),
        reasonController: _reasonController,
        reasonMode: reasonMode,
        lateNotice: switch (reasonMode) {
          _ when opens != null && _isEarly =>
            context.locale.earlyCheckOutNotice(
              context.numbers.phone(wallClockHm(opens)),
            ),
          _ when deadline != null && _isLate =>
            context.locale.lateCheckOutNotice(
              context.numbers.phone(wallClockHm(deadline)),
            ),
          _ => null,
        },
        checkOutTime: _checkOutTime,
        onCheckOutTimeChanged: (time) => setState(() {
          _checkOutTime = time;
          _checkOutTimeEdited = true;
        }),
      ),
    );
  }
}

class _ShiftCheckOutBody extends StatelessWidget {
  const _ShiftCheckOutBody({
    required this.capturedPhotoPath,
    required this.isLoading,
    required this.isSubmitting,
    required this.hasError,
    this.errorMessage,
    this.faceValidationError,
    required this.onTakePhoto,
    required this.onSubmit,
    required this.reasonController,
    required this.checkOutTime,
    required this.onCheckOutTimeChanged,
    this.reasonMode = _ReasonMode.optional,
    this.lateNotice,
  });

  final String? capturedPhotoPath;
  final bool isLoading;
  final bool isSubmitting;
  final bool hasError;
  final String? errorMessage;
  final String? faceValidationError;
  final VoidCallback onTakePhoto;
  final VoidCallback onSubmit;
  final TextEditingController reasonController;
  final _ReasonMode reasonMode;
  final String? lateNotice;
  final TimeOfDay checkOutTime;
  final ValueChanged<TimeOfDay> onCheckOutTimeChanged;

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
                    hasError: hasError,
                    errorMessage: errorMessage,
                    faceValidationError: faceValidationError,
                    onRetry: onTakePhoto,
                  ),
                  Gap(dimensions.spacing.s12),
                  _TakePhotoButton(
                    capturedPhotoPath: capturedPhotoPath,
                    isLoading: isLoading,
                    onTap: onTakePhoto,
                  ),
                  Gap(dimensions.spacing.s16),
                  const _AutoDetectedInfoCard(timeIsCheckOut: true),
                  Gap(dimensions.spacing.s16),
                  AppTimeField(
                    label: context.locale.checkOutTime,
                    time: checkOutTime,
                    onChanged: onCheckOutTimeChanged,
                  ),
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
            child: ListenableBuilder(
              listenable: reasonController,
              builder: (context, _) => _SubmitButton(
                onSubmit: onSubmit,
                isLoading: isSubmitting,
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
