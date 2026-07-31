import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_entity.dart';

part 'leave_shifts_provider.g.dart';

@riverpod
class LeaveShifts extends _$LeaveShifts {
  @override
  Future<List<ShiftEntity>> build({required String date}) async {
    final result = await ref.read(getShiftsUseCaseProvider).call(date: date);

    return result.when(
      success: (data) => data ?? const [],
      error: (error) => throw Exception(error.message),
    );
  }
}
