// ignore_for_file: max_file_lines
part of '../view/shift_check_in_page.dart';

class _ManualAttendanceBottomSheet extends ConsumerStatefulWidget {
  const _ManualAttendanceBottomSheet({
    required this.checkInInfo,
    required this.failureType,
    required this.shiftSlotId,
    required this.withdrawRoute,
  });

  final CheckInInfoEntity checkInInfo;
  final CheckInFailureType failureType;
  final int? shiftSlotId;
  final String withdrawRoute;

  @override
  ConsumerState<_ManualAttendanceBottomSheet> createState() =>
      _ManualAttendanceBottomSheetState();
}

class _ManualAttendanceBottomSheetState
    extends ConsumerState<_ManualAttendanceBottomSheet> {
  String? _selectedReason;
  final _formKey = GlobalKey<FormState>();
  // NEW: only used when location itself failed — lets the attendant type
  // where they are since checkInInfo.location is empty in that case.
  final _manualLocationController = TextEditingController();

  @override
  void dispose() {
    _manualLocationController.dispose();
    super.dispose();
  }

  // NEW: reason list matches whichever detector actually failed, instead of
  // always showing camera-worded options for a location-only failure.
  List<String> _reasonOptions(BuildContext context) {
    final locale = context.locale;
    final cameraReasons = [
      locale.reasonCameraNotWorking,
      locale.reasonCameraUnavailable,
      locale.reasonPhoneCameraBroken,
      locale.reasonNoCameraDevice,
    ];
    final locationReasons = [
      locale.reasonLocationOff,
      locale.reasonLocationPermissionDenied,
      locale.reasonLocationSignalWeak,
      locale.reasonLocationUnavailable,
    ];
    return switch (widget.failureType) {
      CheckInFailureType.camera => cameraReasons,
      CheckInFailureType.location => locationReasons,
      CheckInFailureType.both => [...cameraReasons, ...locationReasons],
      CheckInFailureType.none => cameraReasons,
    };
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    final shiftSlotId = widget.shiftSlotId;
    if (shiftSlotId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.locale.noActiveShift)));
      return;
    }
    ref
        .read(manualAttendanceProvider.notifier)
        .submit(
          shiftSlotId: shiftSlotId,
          reason: _selectedReason!,
          checkInInfo: widget.checkInInfo,
          manualLocation: widget.failureType.hasLocationFailure
              ? _manualLocationController.text.trim()
              : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(manualAttendanceProvider, (_, next) {
      if (next is AsyncData && next.value != null) {
        Navigator.of(context).pop();
        context.goNamed(
          Routes.approvalRequest,
          extra: (attendance: next.value!, withdrawRoute: widget.withdrawRoute),
        );
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!.localizedMessage(context)),
            backgroundColor: context.color.error,
          ),
        );
      }
    });

    final isLoading = ref.watch(manualAttendanceProvider).isLoading;
    final spacing = context.dimensions.spacing;
    final padding = context.dimensions.padding;
    final locale = context.locale;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          padding.p16,
          spacing.s16,
          padding.p16,
          spacing.s16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadlineSmallText(locale.manualAttendance),
                Gap(spacing.s4),
                BodyRegularText.secondary(locale.manualAttendanceDescription),
                Gap(spacing.s16),
                _ManualAttendanceInfoRow(
                  label: locale.checkInTime,
                  value: widget.checkInInfo.checkInTime,
                ),
                Gap(spacing.s8),
                _ManualAttendanceInfoRow(
                  label: locale.location,
                  value: widget.checkInInfo.location ?? '',
                ),
                Gap(spacing.s16),
                _ReasonDropdown(
                  selectedReason: _selectedReason,
                  reasons: _reasonOptions(context),
                  onChanged: (value) => setState(() => _selectedReason = value),
                  validator: (_) =>
                      _selectedReason == null ? locale.reasonRequired : null,
                ),
                // NEW: only shown when location is the (or one of the) failure —
                // checkInInfo.location is empty in that case, so this is the
                // attendant's only way to give the supervisor any location context.
                if (widget.failureType.hasLocationFailure) ...[
                  Gap(spacing.s16),
                  AppTextField.description(
                    controller: _manualLocationController,
                    label: locale.manualLocationLabel,
                    hint: locale.manualLocationHint,
                  ),
                ],
                Gap(spacing.s16),
                SizedBox(
                  width: double.infinity,
                  height: spacing.s44,
                  child: FilledButton(
                    onPressed: isLoading ? null : _onSubmit,
                    child: isLoading
                        ? const LoadingIndicator()
                        : Text(locale.submit),
                  ),
                ),
                Gap(spacing.s12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: isLoading ? null : context.pop,
                    style: TextButton.styleFrom(
                      backgroundColor: context.color.subtle,
                      foregroundColor: context.color.text.primary,
                      shape: const StadiumBorder(),
                    ),
                    child: LabelLargeText(locale.cancel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ManualAttendanceInfoRow extends StatelessWidget {
  const _ManualAttendanceInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 100, child: BodyRegularText.secondary(label)),
        Expanded(child: BodyRegularText(value)),
      ],
    );
  }
}
