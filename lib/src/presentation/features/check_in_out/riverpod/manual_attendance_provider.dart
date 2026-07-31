import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
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

    if (!ref.hasPermission(UserPermission.attendanceCheckIn)) {
      state = AsyncValue.error(Failure.permissionDenied, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

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
        .call(request: request);

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

  Future<void> refresh({required int shiftId}) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    final result = await ref
        .read(refreshAttendanceUseCaseProvider)
        .call(shiftId: shiftId);
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

  Future<void> withdraw({required int attendanceId}) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    final result = await ref
        .read(withdrawAttendanceUseCaseProvider)
        .call(attendanceId: attendanceId);
    state = switch (result) {
      Success(:final data) => AsyncValue.data(data),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
