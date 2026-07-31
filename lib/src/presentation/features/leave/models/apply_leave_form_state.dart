import 'package:intl/intl.dart';

import '../../../../domain/entities/leave/apply_leave_params.dart';
import '../../../../domain/entities/leave/leave_attendant_entity.dart';
import '../../../../domain/entities/shift_entity.dart';

enum LeaveApplicationType { own, onBehalf }

class ApplyLeaveFormState {
  ApplyLeaveFormState({
    this.appType = LeaveApplicationType.own,
    this.leavePolicyId,
    this.selectedAttendant,
    this.selectedShift,
    DateTime? startDate,
    DateTime? endDate,
    this.reason = '',
  })  : startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now();

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
