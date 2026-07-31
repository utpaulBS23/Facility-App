import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_attendant_entity.dart';

part 'leave_attendants_provider.g.dart';

@riverpod
class LeaveAttendants extends _$LeaveAttendants {
  @override
  Future<List<LeaveAttendantEntity>> build() async {
    final result = await ref.read(getLeaveAttendantsUseCaseProvider).call();

    return result.when(
      success: (data) => data ?? const [],
      error: (error) => throw Exception(error.message),
    );
  }
}
