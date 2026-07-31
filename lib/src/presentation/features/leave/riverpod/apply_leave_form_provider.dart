import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/leave/apply_leave_params.dart';
import '../../../../domain/entities/leave/leave_attendant_entity.dart';
import '../../../../domain/entities/shift_entity.dart';

part 'apply_leave_form_provider.g.dart';

enum LeaveApplicationType { own, onBehalf }

class ApplyLeaveFormState {
  const ApplyLeaveFormState({
    this.appType = LeaveApplicationType.own,
    this.leavePolicyId,
    this.selectedAttendant,
    this.selectedShift,
    required this.startDate,
    required this.endDate,
    this.reason = '',
  });

  final LeaveApplicationType appType;
  final int? leavePolicyId;
  final LeaveAttendantEntity? selectedAttendant;
  final ShiftEntity? selectedShift;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;

  /// Pure presentation form validation logic
  bool get isSubmitEnabled {
    final hasLeaveType = leavePolicyId != null;
    return switch (appType) {
      LeaveApplicationType.onBehalf =>
        selectedAttendant != null && hasLeaveType,
      LeaveApplicationType.own => hasLeaveType,
    };
  }

  /// Converts current form inputs to domain [ApplyLeaveParams]
  ApplyLeaveParams toParams() {
    final attendantId = appType == LeaveApplicationType.onBehalf
        ? selectedAttendant?.id
        : null;
    final formatter = DateFormat('yyyy-MM-dd');
    return ApplyLeaveParams(
      leavePolicyId: leavePolicyId!,
      startDate: formatter.format(startDate),
      endDate: formatter.format(endDate),
      attendantId: attendantId,
      reason: reason.isNotEmpty ? reason : null,
    );
  }

  ApplyLeaveFormState copyWith({
    LeaveApplicationType? appType,
    int? leavePolicyId,
    LeaveAttendantEntity? selectedAttendant,
    ShiftEntity? selectedShift,
    DateTime? startDate,
    DateTime? endDate,
    String? reason,
    bool clearPolicy = false,
    bool clearShift = false,
    bool clearAttendant = false,
  }) {
    return ApplyLeaveFormState(
      appType: appType ?? this.appType,
      leavePolicyId: clearPolicy ? null : (leavePolicyId ?? this.leavePolicyId),
      selectedAttendant: clearAttendant
          ? null
          : (selectedAttendant ?? this.selectedAttendant),
      selectedShift: clearShift ? null : (selectedShift ?? this.selectedShift),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reason: reason ?? this.reason,
    );
  }
}

@riverpod
class ApplyLeaveForm extends _$ApplyLeaveForm {
  @override
  ApplyLeaveFormState build() {
    final now = DateTime.now();
    return ApplyLeaveFormState(startDate: now, endDate: now);
  }

  void setApplicationType(LeaveApplicationType type) {
    if (state.appType == type) return;
    final now = DateTime.now();
    state = state.copyWith(
      appType: type,
      clearPolicy: true,
      clearShift: true,
      clearAttendant: true,
      startDate: now,
      endDate: now,
    );
  }

  void setLeavePolicyId(int? id) {
    state = state.copyWith(leavePolicyId: id);
  }

  void setSelectedAttendant(LeaveAttendantEntity? attendant) {
    state = state.copyWith(selectedAttendant: attendant);
  }

  void setSelectedShift(ShiftEntity? shift) {
    state = state.copyWith(selectedShift: shift);
  }

  void setStartDate(DateTime date) {
    var end = state.endDate;
    if (end.isBefore(date)) {
      end = date;
    }
    state = state.copyWith(startDate: date, endDate: end, clearShift: true);
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date, clearShift: true);
  }

  void setReason(String reason) {
    state = state.copyWith(reason: reason);
  }

  void reset() {
    final now = DateTime.now();
    state = ApplyLeaveFormState(startDate: now, endDate: now);
  }
}
