import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/create_leave_request.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';

part 'apply_leave_provider.g.dart';

@riverpod
class ApplyLeaveAction extends _$ApplyLeaveAction {
  @override
  AsyncValue<LeaveRequestEntity?> build() => const AsyncValue.data(null);

  Future<void> submit(CreateLeaveRequest params) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref.read(requestLeaveUseCaseProvider).call(params);

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
