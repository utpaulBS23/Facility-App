import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/result.dart';
import '../../../../../core/di/dependency_injection.dart';

part 'login_provider.g.dart';

@riverpod
class Login extends _$Login {
  @override
  AsyncValue build() => const AsyncValue.data(null);

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final deviceName = await _resolveDeviceName();

    final result = await ref.read(loginUseCaseProvider).call(
      email: email,
      password: password,
      deviceName: deviceName,
    );

    state = switch (result) {
      Success() => AsyncValue.data(result),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }

  Future<String> _resolveDeviceName() async {
    final result = await ref.read(getDeviceNameUseCaseProvider).call();
    return switch (result) {
      Success(:final data) => data ?? 'Mobile',
      _ => 'Mobile',
    };
  }
}
