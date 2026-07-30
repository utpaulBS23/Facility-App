import 'package:facility_management_app/src/core/extensions/permission_guard.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../../domain/repositories/leave_repository.dart';
import '../../../core/extensions/ref_extensions.dart';

part 'apply_leave_provider.g.dart';

@riverpod
class ApplyLeaveAction extends _$ApplyLeaveAction {
  @override
  AsyncValue<LeaveRequestEntity?> build() => const AsyncValue.data(null);

  Future<void> submit(RequestLeaveParams params) async {
    if (state.isLoading) return;

    final partnerId = ref.read(getActivePartnerUseCaseProvider).call();
    if (partnerId == null) {
      state = AsyncValue.error(partnerUnavailableMessage, StackTrace.current);
      
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref
        .read(requestLeaveUseCaseProvider)
        .call(partnerId, params);

    state = result.toAsyncValue();

  }
}
