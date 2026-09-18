// ignore_for_file: max_file_lines
part of '../view/shift_check_in_page.dart';

class _ManualAttendanceBottomSheet extends ConsumerStatefulWidget {
  const _ManualAttendanceBottomSheet({
    required this.checkInInfo,
    required this.shiftSlotId,
    required this.withdrawRoute,
  });

  final CheckInInfoEntity checkInInfo;
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
                value: widget.checkInInfo.location,
              ),
              Gap(spacing.s16),
              _ReasonDropdown(
                selectedReason: _selectedReason,
                reasons: [
                  locale.reasonCameraNotWorking,
                  locale.reasonCameraUnavailable,
                  locale.reasonPhoneCameraBroken,
                  locale.reasonNoCameraDevice,
                ],
                onChanged: (value) => setState(() => _selectedReason = value),
                validator: (_) =>
                    _selectedReason == null ? locale.reasonRequired : null,
              ),
              Gap(spacing.s16),
              SizedBox(
                width: double.infinity,
                height: spacing.s56,
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
