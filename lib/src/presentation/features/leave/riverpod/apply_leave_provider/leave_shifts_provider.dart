import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/base.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/shift_entity.dart';
import '../../../../../domain/use_cases/shift_use_case.dart';
import 'selected_leave_attendant_provider.dart';

part 'leave_shifts_provider.g.dart';

@riverpod
class LeaveShifts extends _$LeaveShifts {
  late final GetShiftsUseCase _usecase;

  @override
  AsyncValue<List<ShiftEntity>> build() {
    _usecase = ref.read(getShiftsUseCaseProvider);

    ref.listen(selectedLeaveAttendantProvider, (previous, next) {
      ref.invalidateSelf();
    });

    return const AsyncValue.data([]);
  }

  Future<void> fetch(String date) async {
    state = const AsyncValue.loading();

    final result = await _usecase(date: date);

    state = result.when(
      success: (data) => AsyncValue.data(data ?? const []),
      error: (error) => AsyncValue.error(error.message, StackTrace.current),
    );
  }
}