import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/shift_entity.dart';

part 'leave_shifts_provider.g.dart';

@riverpod
class LeaveShifts extends _$LeaveShifts {
  @override
  Future<List<ShiftEntity>> build({
    required int partnerId,
    required String date,
  }) async {


    // shift usecase returns string instead of failure. need confirmation which one to follow

    final Result<List<ShiftEntity>, String> result = await ref
        .read(getShiftsUseCaseProvider)
        .call(partnerId: partnerId, date: date);

    return result.when(
      success: (data) => data ?? const [],
      error: (error) => throw Exception(error),
    );
  }
}
