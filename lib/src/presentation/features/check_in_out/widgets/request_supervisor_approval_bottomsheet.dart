// ignore_for_file: max_file_lines
part of '../view/shift_check_in_page.dart';

class _RequestSupervisorApprovalBottomSheet extends StatefulWidget {
  const _RequestSupervisorApprovalBottomSheet();

  @override
  State<_RequestSupervisorApprovalBottomSheet> createState() =>
      _RequestSupervisorApprovalBottomSheetState();
}

class _RequestSupervisorApprovalBottomSheetState
    extends State<_RequestSupervisorApprovalBottomSheet> {
  String? _selectedReason;

  void _onSubmit() {
    if (_selectedReason == null) return;
    // TODO: Implement supervisor approval request
    context.pop();
  }

  void _onCancel() => context.pop();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    // WHY: Reasons are localized; will be replaced with real API data later.
    final reasons = [
      context.locale.reasonCameraNotWorking,
      context.locale.reasonCameraUnavailable,
      context.locale.reasonPhoneCameraBroken,
      context.locale.reasonNoCameraDevice,
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.dimensions.padding.p16,
        spacing.s16,
        context.dimensions.padding.p16,
        spacing.s32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadlineSmallText(context.locale.requestSupervisor),
          Gap(spacing.s12),
          BodyRegularText.secondary(context.locale.requestSupervisorMessage),
          Gap(spacing.s16),
          _ReasonDropdown(
            selectedReason: _selectedReason,
            reasons: reasons,
            onChanged: (value) => setState(() => _selectedReason = value),
          ),
          Gap(spacing.s16),
          SizedBox(
            width: double.infinity,
            height: spacing.s56,
            child: FilledButton(
              onPressed: _selectedReason != null ? _onSubmit : null,
              child: Text(context.locale.requestSupervisor),
            ),
          ),
          Gap(spacing.s12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _onCancel,
              style: TextButton.styleFrom(
                backgroundColor: context.color.subtle,
                foregroundColor: context.color.text.primary,
                shape: const StadiumBorder(),
              ),
              child: LabelLargeText(context.locale.cancel),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonDropdown extends StatelessWidget {
  const _ReasonDropdown({
    required this.selectedReason,
    required this.reasons,
    required this.onChanged,
  });

  final String? selectedReason;
  final List<String> reasons;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final radius = context.dimensions.radius;
    final spacing = context.dimensions.spacing;
    final borderRadius = BorderRadius.circular(radius.r12);
    final borderSide = BorderSide(color: context.color.border);

    return SizedBox(
      height: spacing.s56,
      child: DropdownButtonFormField<String>(
        initialValue: selectedReason,
        decoration: InputDecoration(
          labelText: context.locale.reasonLabel,
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderSide,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderSide,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: context.color.borderBrandFocus),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: spacing.s16),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: context.color.text.muted,
        ),
        dropdownColor: context.color.onPrimary,
        borderRadius: borderRadius,
        style: context.textStyle.labelLarge.copyWith(
          color: context.color.text.primary,
        ),
        items: reasons
            .map(
              (reason) => DropdownMenuItem(value: reason, child: Text(reason)),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
