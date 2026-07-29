import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
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
    required int attendanceId,
    required double lat,
    required double lng,
    required String selfieUrl,
    String? reason,
  }) async {
    if (state.isLoading) return;

    if (!ref.hasPermission(UserPermission.attendanceCheckOut)) {
      state = AsyncValue.error(Failure.permissionDenied, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref
        .read(checkOutUseCaseProvider)
        .call(
          attendanceId: attendanceId,
          lat: lat,
          lng: lng,
          selfieUrl: selfieUrl,
          reason: reason,
        );

    state = switch (result) {
      Success() => AsyncValue.data(result),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
