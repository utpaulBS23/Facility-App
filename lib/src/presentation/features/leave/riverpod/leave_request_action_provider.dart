import 'package:facility_management_app/src/presentation/core/extensions/ref_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';

part 'leave_request_action_provider.g.dart';

@riverpod
class LeaveRequestAction extends _$LeaveRequestAction {
  @override
  AsyncValue<LeaveRequestEntity?> build() => const AsyncValue.data(null);

  Future<void> approve(int leaveRequestId) async {
    if (state.isLoading) return;

    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(approveLeaveUseCaseProvider)
        .call(partnerId, leaveRequestId);

    state = result.toAsyncValue();
  }

  Future<void> reject(int leaveRequestId, {String? reason}) async {
    if (state.isLoading) return;
    
    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(rejectLeaveUseCaseProvider)
        .call(partnerId, leaveRequestId, reason: reason);

    state = result.toAsyncValue();
  }

  Future<void> cancel(int leaveRequestId) async {
    if (state.isLoading) return;

    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) return;

    state = const AsyncValue.loading();

    final result = await ref
        .read(cancelLeaveUseCaseProvider)
        .call(partnerId, leaveRequestId);

    state = result.toAsyncValue();
  }

}
