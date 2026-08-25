import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/result.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/app_update_entity.dart';

part 'login_provider.g.dart';

@riverpod
class Login extends _$Login {
  @override
  AsyncValue build() => const AsyncValue.data(null);

  Future<void> login({
    required String uid,
    required String password,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final deviceInfo = await _resolveDeviceInfo();

    final result = await ref.read(loginUseCaseProvider).call(
      uid: uid,
      password: password,
      deviceName: deviceInfo?.deviceModel ?? 'Mobile',
      deviceId: deviceInfo?.deviceId,
      deviceModel: deviceInfo?.deviceModel,
      osVersion: deviceInfo?.osVersion,
    );

    state = switch (result) {
      Success() => AsyncValue.data(result),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }

  Future<DeviceInfoEntity?> _resolveDeviceInfo() async {
    final result = await ref.read(getDeviceInfoUseCaseProvider).call();
    return switch (result) {
      Success(:final data) => data,
      _ => null,
    };
  }
}
