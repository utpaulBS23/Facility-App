import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/task_entity.dart';

part 'assign_task_staff_provider.g.dart';

@riverpod
class TaskPartnerStaff extends _$TaskPartnerStaff {
  @override
  AsyncValue<List<PartnerStaffEntity>> build() => const AsyncValue.loading();

  Future<void> fetch({required int facilityId, String? search}) async {
    state = const AsyncValue.loading();

    final result = await ref
        .read(getPartnerStaffUseCaseProvider)
        .call(facilityId: facilityId, search: search);
    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error('No staff', StackTrace.current),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}

@riverpod
class AssignTaskStaff extends _$AssignTaskStaff {
  @override
  AsyncValue<TaskEntity?> build() => const AsyncValue.data(null);

  Future<void> assign({
    required int issueId,
    required int assignedTo,
  }) async {
    if (!ref.hasPermission(UserPermission.issueUpdate)) {
      state = AsyncValue.error(Failure.permissionDenied, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref
        .read(updateIssueAssignmentUseCaseProvider)
        .call(issueId: issueId, assignedTo: assignedTo);

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}