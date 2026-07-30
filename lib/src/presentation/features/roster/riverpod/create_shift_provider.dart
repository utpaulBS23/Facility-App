import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/shift_entity.dart';

part 'create_shift_provider.g.dart';

@riverpod
class CreateShift extends _$CreateShift {
  @override
  AsyncValue<ShiftEntity?> build() => const AsyncValue.data(null);

  Future<void> create({
    required int facilityId,
    required int rosterId,
    required int shiftTemplateId,
    required String shiftDate,
    String? notes,
    required int minAttendants,
    required int maxAttendants,
  }) async {
    if (state.isLoading) return;

    if (!ref.hasPermission(UserPermission.shiftCreate)) {
      state = AsyncValue.error(Failure.permissionDenied, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref
        .read(createShiftUseCaseProvider)
        .call(
          facilityId: facilityId,
          rosterId: rosterId,
          shiftTemplateId: shiftTemplateId,
          shiftDate: shiftDate,
          notes: notes,
          minAttendants: minAttendants,
          maxAttendants: maxAttendants,
        );

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
