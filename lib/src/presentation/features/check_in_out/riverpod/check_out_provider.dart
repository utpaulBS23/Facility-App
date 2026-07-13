import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';

part 'check_out_provider.g.dart';

@riverpod
class CheckOut extends _$CheckOut {
  @override
  AsyncValue build() => const AsyncValue.data(null);

  Future<void> checkOut({
    required int partnerId,
    required int shiftId,
    required String imagePath,
    required double lat,
    required double lng,
    required String address,
  }) async {
    if (state.isLoading) return;

    if (!ref.hasPermission(AppPermission.attendanceCheckOut)) {
      state = AsyncValue.error(permissionDeniedMessage, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref.read(checkOutUseCaseProvider).call(
      partnerId: partnerId,
      shiftId: shiftId,
      imagePath: imagePath,
      lat: lat,
      lng: lng,
      address: address,
    );

    state = switch (result) {
      Success() => AsyncValue.data(result),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
