import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
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
  }) async {
    if (state.isLoading) return;

    if (!ref.hasPermission(AppPermission.attendanceCheckIn)) {
      state = AsyncValue.error(Failure.permissionDenied, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref.read(checkInUseCaseProvider).call(
      shiftSlotId: shiftSlotId,
      lat: lat,
      lng: lng,
      selfieUrl: selfieUrl,
    );

    state = switch (result) {
      Success() => AsyncValue.data(result),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
