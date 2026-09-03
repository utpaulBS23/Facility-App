import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/profile_payloads.dart';

part 'change_password_provider.g.dart';

@riverpod
class ChangePassword extends _$ChangePassword {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> changePassword(ChangePasswordEntity request) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    final result = await ref.read(changePasswordUseCaseProvider)(request);

    state = result.when(
      success: (_) => const AsyncValue.data(null),
      error: (failure) => AsyncValue.error(failure, StackTrace.current),
    );
  }
}
