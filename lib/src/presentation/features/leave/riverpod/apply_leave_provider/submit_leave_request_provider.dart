import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/base.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/leave/create_leave_request_entity.dart';
import '../../../../../domain/entities/leave/leave_request_entity.dart';

part 'submit_leave_request_provider.g.dart';

@riverpod
class SubmitLeaveRequest extends _$SubmitLeaveRequest {
  @override
  AsyncValue<LeaveRequestEntity?> build() => const AsyncValue.data(null);

  Future<void> submit(CreateLeaveRequestEntity params) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref.read(requestLeaveUseCaseProvider).call(params);

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error(
          Exception('Failed to submit leave request'),
          StackTrace.current,
        ),
    };
  }
}
