import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/leave/leave_attendant_entity.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../models/apply_leave_form_state.dart';

export '../models/apply_leave_form_state.dart';

part 'apply_leave_form_provider.g.dart';

@riverpod
class ApplyLeaveForm extends _$ApplyLeaveForm {
  @override
  ApplyLeaveFormState build() => ApplyLeaveFormState();

  void setApplicationType(LeaveApplicationType type) {
    if (state.appType == type) {
      return;
    }

    state = ApplyLeaveFormState(appType: type);
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
    state = ApplyLeaveFormState();
  }
}
