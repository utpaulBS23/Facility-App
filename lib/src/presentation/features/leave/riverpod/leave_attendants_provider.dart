import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_attendant_entity.dart';

final leaveAttendantsProvider =
    FutureProvider<List<LeaveAttendantEntity>>((ref) async {
  final result = await ref.read(getLeaveAttendantsUseCaseProvider).call();

  return result.when(
    success: (data) => data ?? const [],
    error: (error) => throw Exception(error.message),
  );
});
