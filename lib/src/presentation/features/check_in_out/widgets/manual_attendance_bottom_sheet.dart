// ignore_for_file: max_file_lines
part of '../view/shift_check_in_page.dart';

class _ManualAttendanceBottomSheet extends ConsumerStatefulWidget {
  const _ManualAttendanceBottomSheet({required this.checkInInfo});

  final CheckInInfoEntity checkInInfo;

  @override
  ConsumerState<_ManualAttendanceBottomSheet> createState() =>
      _ManualAttendanceBottomSheetState();
}

class _ManualAttendanceBottomSheetState
    extends ConsumerState<_ManualAttendanceBottomSheet> {
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reasonController.dispose();
    // WHY: Reset so stale error state doesn't fire the listener on next open.
    ref.invalidate(manualAttendanceProvider);
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(manualAttendanceProvider.notifier).submit(
      reason: _reasonController.text.trim(),
      checkInInfo: widget.checkInInfo,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(manualAttendanceProvider, (_, next) {
      if (next is AsyncData && next.value != null) {
        Navigator.of(context).pop();
        context.goNamed(Routes.shift);
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: context.color.error,
          ),
        );
      }
    });

    final isLoading = ref.watch(manualAttendanceProvider).isLoading;
    final spacing = context.dimensions.spacing;
    final padding = context.dimensions.padding;
    final locale = context.locale;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        padding.p16,
        spacing.s16,
        padding.p16,
        spacing.s32 + MediaQuery.viewInsetsOf(context).bottom,
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
            TextFormField(
              controller: _reasonController,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              style: context.textStyle.bodyRegular.copyWith(
                color: context.color.text.primary,
              ),
              decoration: InputDecoration(
                labelText: locale.reasonLabel,
                hintText: locale.manualAttendanceReasonHint,
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    context.dimensions.radius.r12,
                  ),
                  borderSide: BorderSide(color: context.color.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    context.dimensions.radius.r12,
                  ),
                  borderSide: BorderSide(color: context.color.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    context.dimensions.radius.r12,
                  ),
                  borderSide: BorderSide(
                    color: context.color.borderBrandFocus,
                  ),
                ),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty)
                      ? locale.reasonRequired
                      : null,
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
    );
  }
}

class _ManualAttendanceInfoRow extends StatelessWidget {
  const _ManualAttendanceInfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: BodyRegularText.secondary(label),
        ),
        Expanded(
          child: BodyRegularText(value),
        ),
      ],
    );
  }
}
