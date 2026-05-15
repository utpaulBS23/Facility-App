import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/check_in_info_entity.dart';
import '../../../../domain/entities/manual_attendance_entity.dart';
import '../../shift/riverpod/shift_list_provider.dart';

part 'manual_attendance_provider.g.dart';

@riverpod
class ManualAttendance extends _$ManualAttendance {
  @override
  AsyncValue<ManualAttendanceResponseEntity?> build() =>
      const AsyncValue.data(null);

  Future<void> submit({
    required String reason,
    required CheckInInfoEntity checkInInfo,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final partnerId =
        ref.read(getCurrentUserUseCaseProvider).call()?.partnerId;
    if (partnerId == null) {
      state = AsyncValue.error('User not found', StackTrace.current);
      return;
    }

    final shiftId = await _resolveShiftId(partnerId);
    if (shiftId == null) {
      state = AsyncValue.error('No shift found for today', StackTrace.current);
      return;
    }

    final request = ManualAttendanceRequestEntity(
      shiftId: shiftId,
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

  Future<int?> _resolveShiftId(int partnerId) async {
    // WHY: Reuse already-loaded shifts to avoid an extra round-trip; only
    // fetch when the shift list hasn't been populated yet (e.g. direct
    // login → check-in without visiting the shift list page).
    final cached = ref.read(shiftListProvider).valueOrNull;
    if (cached != null && cached.isNotEmpty) return cached.first.id;

    final result = await ref.read(getShiftsUseCaseProvider).call(
      partnerId: partnerId,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    return switch (result) {
      Success(:final data) when data != null && data.isNotEmpty =>
        data.first.id,
      _ => null,
    };
  }
}
