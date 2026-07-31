import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/apply_leave_params.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../core/extensions/ref_extensions.dart';

part 'apply_leave_provider.g.dart';

@riverpod
class ApplyLeaveAction extends _$ApplyLeaveAction {
  @override
  AsyncValue<LeaveRequestEntity?> build() => const AsyncValue.data(null);

  Future<void> submit(ApplyLeaveParams params) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref.read(requestLeaveUseCaseProvider).call(params);

    state = result.toAsyncValue();
  }
}
