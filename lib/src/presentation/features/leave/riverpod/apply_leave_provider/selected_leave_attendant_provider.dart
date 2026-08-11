import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../domain/entities/leave/leave_attendant_entity.dart';

part 'selected_leave_attendant_provider.g.dart';

@riverpod
class SelectedLeaveAttendant extends _$SelectedLeaveAttendant {
  @override
  LeaveAttendantEntity? build() => null;

  void select(LeaveAttendantEntity? attendant) {
    state = attendant;
  }
}
