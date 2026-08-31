import '../../../../core/base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/leave/create_leave_request_entity.dart';
import '../../../../domain/entities/leave/leave_attendant_entity.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../riverpod/apply_leave_provider/selected_leave_attendant_provider.dart';
import '../riverpod/apply_leave_provider/selected_leave_policy_id_provider.dart';
import '../riverpod/apply_leave_provider/selected_shift_provider.dart';
import '../riverpod/apply_leave_provider/submit_leave_request_provider.dart';
import '../widgets/apply_leave_body.dart';
import '../widgets/apply_leave_submit_button.dart';
import '../widgets/apply_leave_type_switch.dart';

class ApplyLeavePage extends ConsumerStatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  ConsumerState<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends ConsumerState<ApplyLeavePage> {
  final _reasonController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  LeaveApplicationType _leaveApplicationType = LeaveApplicationType.own;

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      submitLeaveRequestProvider,
      _onLeaveSubmissionStateChanged,
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _onLeaveApplicationTypeChanged(LeaveApplicationType type) {
    setState(() {
      _leaveApplicationType = type;
      if (type == LeaveApplicationType.own) {
        ref.read(selectedLeaveAttendantProvider.notifier).select(null);
        ref.read(selectedShiftProvider.notifier).select(null);
      }
    });
  }

  void _onLeaveSubmissionStateChanged(AsyncValue? previous, AsyncValue next) {
    next.whenOrNull(
      data: (value) {
        if (value == null || !mounted) {
          return;
        }

        context.pushReplacementNamed(Routes.leaveSubmitted, extra: value);
      },
      error: (e, _) {
        AppSnackBar.showError(context, switch (e) {
          Failure() => e.localizedMessage(context),
          _ => context.locale.somethingWentWrong,
        });
      },
    );
  }

  Future<void> _pickDate({
    required DateTime initialDate,
    required DateTime firstDate,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      onPicked(picked);
    }
  }

  Future<void> _onPickStartDate() async {
    await _pickDate(
      initialDate: _startDate,
      firstDate: DateTime.now(),
      onPicked: (picked) {
        setState(() {
          _startDate = picked;
          if (_endDate.isBefore(picked)) {
            _endDate = picked;
          }
        });
        ref.read(selectedShiftProvider.notifier).select(null);
      },
    );
  }

  Future<void> _onPickEndDate() async {
    final initialDate = _endDate.isBefore(_startDate) ? _startDate : _endDate;

    await _pickDate(
      initialDate: initialDate,
      firstDate: _startDate,
      onPicked: (picked) {
        setState(() => _endDate = picked);
        ref.read(selectedShiftProvider.notifier).select(null);
      },
    );
  }

  Future<void> _onSelectShift() async {
    final date = DateFormat('yyyy-MM-dd').format(_startDate);
    final selectedShift = await context.pushNamed<ShiftEntity>(
      Routes.selectShift,
      extra: date,
    );

    if (selectedShift != null) {
      ref.read(selectedShiftProvider.notifier).select(selectedShift);
    }
  }

  Future<void> _onSelectAttendant() async {
    final selectedAttendant = await context.pushNamed<LeaveAttendantEntity>(
      Routes.selectAttendant,
    );

    if (selectedAttendant != null) {
      ref
          .read(selectedLeaveAttendantProvider.notifier)
          .select(selectedAttendant);
    }
  }

  Future<void> _onSubmit() async {
    final selectedLeavePolicyId = ref.read(selectedLeavePolicyIdProvider);

    if (selectedLeavePolicyId == null) {
      return;
    }

    final selectedAttendant = ref.read(selectedLeaveAttendantProvider);

    final formatter = DateFormat('yyyy-MM-dd');
    final reasonText = _reasonController.text.trim();
    final createLeaveRequestParams = CreateLeaveRequestEntity(
      leavePolicyId: selectedLeavePolicyId,
      startDate: formatter.format(_startDate),
      endDate: formatter.format(_endDate),
      reason: reasonText.isNotEmpty ? reasonText : null,
      attendantId: switch (_leaveApplicationType) {
        LeaveApplicationType.onBehalf => selectedAttendant?.id,
        LeaveApplicationType.own => null,
      },
    );

    await ref
        .read(submitLeaveRequestProvider.notifier)
        .submit(createLeaveRequestParams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.applyLeave),
      body: ApplyLeaveBody(
        leaveApplicationType: _leaveApplicationType,
        onTypeChanged: _onLeaveApplicationTypeChanged,
        onSelectAttendant: _onSelectAttendant,
        startDate: _startDate,
        endDate: _endDate,
        onPickStartDate: _onPickStartDate,
        onPickEndDate: _onPickEndDate,
        onSelectShift: _onSelectShift,
        reasonController: _reasonController,
      ),
      bottomNavigationBar: ApplyLeaveSubmitButton(onTap: _onSubmit),
    );
  }
}
