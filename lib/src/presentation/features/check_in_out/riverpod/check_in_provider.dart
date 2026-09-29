import 'package:battery_plus/battery_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../core/logger/log.dart';
import '../../../../domain/entities/app_permission.dart';

part 'check_in_provider.g.dart';

@riverpod
class CheckIn extends _$CheckIn {
  @override
  AsyncValue build() => const AsyncValue.data(null);

  Future<void> checkIn({
    required int shiftSlotId,
    required double lat,
    required double lng,
    required String selfieUrl,
    String? lateCheckInReason,
  }) async {
    if (state.isLoading) return;

    if (!ref.hasPermission(UserPermission.attendanceCheckIn)) {
      state = AsyncValue.error(Failure.permissionDenied, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    int? batteryLevel;
    try {
      final battery = Battery();
      batteryLevel = await battery.batteryLevel;
    } catch (e) {
      Log.error('Failed to get battery level: $e');
    }

    final result = await ref
        .read(checkInUseCaseProvider)
        .call(
          shiftSlotId: shiftSlotId,
          lat: lat,
          lng: lng,
          selfieUrl: selfieUrl,
          lateCheckInReason: lateCheckInReason,
          batteryLevel: batteryLevel,
        );

    state = switch (result) {
      Success() => AsyncValue.data(result),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
