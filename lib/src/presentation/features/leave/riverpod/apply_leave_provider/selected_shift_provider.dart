import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../domain/entities/shift_entity.dart';
import 'selected_leave_attendant_provider.dart';

part 'selected_shift_provider.g.dart';

@riverpod
class SelectedShift extends _$SelectedShift {
  @override
  ShiftEntity? build() {
    ref.listen(selectedLeaveAttendantProvider, (previous, next) {
      ref.invalidateSelf();
    });

    return null;
  }

  void select(ShiftEntity? shift) {
    state = shift;
  }
}
