import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'selected_leave_attendant_provider.dart';
import 'selected_shift_provider.dart';

part 'selected_leave_policy_id_provider.g.dart';

@riverpod
class SelectedLeavePolicyId extends _$SelectedLeavePolicyId {
  @override
  int? build() {
    ref.listen(selectedLeaveAttendantProvider, (previous, next) {
      ref.invalidateSelf();
    });
    ref.listen(selectedShiftProvider, (previous, next) {
      ref.invalidateSelf();
    });
    return null;
  }

  void select(int? policyId) {
    state = policyId;
  }
}
