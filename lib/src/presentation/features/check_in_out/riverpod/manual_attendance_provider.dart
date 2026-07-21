import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/check_in_info_entity.dart';
import '../../../../domain/entities/manual_attendance_entity.dart';

part 'manual_attendance_provider.g.dart';

@riverpod
class ManualAttendance extends _$ManualAttendance {
  @override
  AsyncValue<ManualAttendanceResponseEntity?> build() =>
      const AsyncValue.data(null);

  Future<void> submit({
    required int shiftSlotId,
    required String reason,
    required CheckInInfoEntity checkInInfo,
  }) async {
    if (state.isLoading) return;

    if (!ref.hasPermission(AppPermission.attendanceCheckIn)) {
      state = AsyncValue.error(permissionDeniedMessage, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    final partnerId = ref.activePartnerId;
    if (partnerId == null) {
      state = AsyncValue.error(partnerUnavailableMessage, StackTrace.current);
      return;
    }

    final request = ManualAttendanceRequestEntity(
      shiftId: shiftSlotId,
      reason: reason,
      checkInTime: checkInInfo.checkInTimeRaw,
      lat: checkInInfo.latitude,
      lng: checkInInfo.longitude,
      address: checkInInfo.location,
    );

    final result = await ref
        .read(submitManualAttendanceUseCaseProvider)
        .call(partnerId: partnerId, request: request);

    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}

@riverpod
class RefreshAttendance extends _$RefreshAttendance {
  @override
  AsyncValue<ManualAttendanceResponseEntity?> build() =>
      const AsyncValue.data(null);

  Future<void> refresh({
    required int partnerId,
    required int shiftId,
  }) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    final result = await ref
        .read(refreshAttendanceUseCaseProvider)
        .call(partnerId: partnerId, shiftId: shiftId);
    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}

@riverpod
class WithdrawAttendance extends _$WithdrawAttendance {
  @override
  AsyncValue<bool?> build() => const AsyncValue.data(null);

  Future<void> withdraw({
    required int partnerId,
    required int attendanceId,
  }) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    final result = await ref
        .read(withdrawAttendanceUseCaseProvider)
        .call(partnerId: partnerId, attendanceId: attendanceId);
    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
