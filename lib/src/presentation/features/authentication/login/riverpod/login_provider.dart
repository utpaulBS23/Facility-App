import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/failure.dart';
import '../../../../../core/base/result.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/app_update_entity.dart';
import '../../../../../domain/entities/login_entity.dart';

part 'login_provider.g.dart';

@riverpod
class Login extends _$Login {
  // WHY: bumped by [cancel] so a request the user walked away from can tell,
  // when it finally returns, that nobody is waiting for it any more. Cancelling
  // is a screen concern, so it is not pushed down into the domain, which would
  // otherwise have to know about the HTTP client's cancel token.
  int _attempt = 0;

  @override
  AsyncValue build() => const AsyncValue.data(null);

  Future<void> login({
    required String uid,
    required String password,
    bool saveAccount = false,
  }) async {
    if (state.isLoading) return;

    final attempt = ++_attempt;
    state = const AsyncValue.loading();

    final deviceInfo = await _resolveDeviceInfo();

    final result = await ref.read(signInUseCaseProvider).call(
      uid: uid,
      password: password,
      saveAccount: saveAccount,
      deviceName: deviceInfo?.deviceModel ?? 'Mobile',
      deviceId: deviceInfo?.deviceId,
      deviceModel: deviceInfo?.deviceModel,
      osVersion: deviceInfo?.osVersion,
    );

    if (attempt != _attempt) return;

    state = _toState(result);
  }

  /// One-tap sign-in with the password stored for [uid].
  Future<void> directLogin(String uid) async {
    if (state.isLoading) return;

    final attempt = ++_attempt;
    state = const AsyncValue.loading();

    final deviceInfo = await _resolveDeviceInfo();

    final result = await ref.read(directSignInUseCaseProvider).call(
      uid: uid,
      deviceName: deviceInfo?.deviceModel ?? 'Mobile',
      deviceId: deviceInfo?.deviceId,
      deviceModel: deviceInfo?.deviceModel,
      osVersion: deviceInfo?.osVersion,
    );

    if (attempt != _attempt) {
      // WHY: the repository applies the session as soon as the request
      // succeeds, so a login the user cancelled would otherwise leave them
      // signed in behind the login screen.
      if (result is Success) await ref.read(logoutUseCaseProvider).call();
      return;
    }

    state = _toState(result);
  }

  /// Abandons the in-flight login and returns to idle.
  void cancel() {
    if (!state.isLoading) return;

    _attempt++;
    state = const AsyncValue.data(null);
  }

  AsyncValue _toState(Result<LoginResponseEntity, Failure> result) {
    return switch (result) {
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
