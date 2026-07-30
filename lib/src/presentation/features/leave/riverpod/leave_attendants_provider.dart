import 'package:facility_management_app/src/presentation/core/extensions/ref_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_attendant_entity.dart';

part 'leave_attendants_provider.g.dart';

@riverpod
class LeaveAttendants extends _$LeaveAttendants {
  @override
  Future<List<LeaveAttendantEntity>> build() async {
    final result = await ref.read(getLeaveAttendantsUseCaseProvider).call();

    return result.getOrThrow() ?? const [];
  }
}
