part of 'apply_leave_page.dart';

extension _ApplyLeavePageHandlers on _ApplyLeavePageState {
  Future<void> _onPickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      updateState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) _endDate = _startDate;
      });
    }
  }

  Future<void> _onPickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate.isBefore(_startDate) ? _startDate : _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      updateState(() => _endDate = picked);
    }
  }

  Future<void> _onSelectShiftTap() async {
    final pid = ref.read(getActivePartnerUseCaseProvider).call();
    if (pid == null) return;
    final res = await ref.read(getShiftsUseCaseProvider).call(
          partnerId: pid,
          date: DateFormat('yyyy-MM-dd').format(_startDate),
        );
    final list = switch (res) {
      Success(:final data) => data ?? const <ShiftEntity>[],
      _ => const <ShiftEntity>[],
    };
    if (!mounted) return;
    final s = await context.pushNamed<ShiftEntity>(Routes.selectShift, extra: list);
    if (s != null && mounted) {
      updateState(() => _selectedShift = s);
    }
  }

  Future<void> _onSelectAttendantTap() async {
    final a = await context.pushNamed<LeaveAttendantEntity>(Routes.selectAttendant);
    if (a != null && mounted) {
      updateState(() => _selectedAttendant = a);
    }
  }

  Future<void> _onSubmit() async {
    if (_selectedLeavePolicyId == null) return;
    final attendantId = _appType == LeaveApplicationType.onBehalf
        ? _selectedAttendant?.id
        : null;
    final params = RequestLeaveParams(
      leavePolicyId: _selectedLeavePolicyId!,
      startDate: DateFormat('yyyy-MM-dd').format(_startDate),
      endDate: DateFormat('yyyy-MM-dd').format(_endDate),
      attendantId: attendantId,
      reason: _reasonController.text,
    );
    final created = await ref.read(applyLeaveActionProvider.notifier).submit(params);
    if (created != null && mounted) {
      context.pushReplacementNamed(Routes.leaveSubmitted, extra: created);
    }
  }
}
