import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/result.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/forgot_password/forgot_password_entities.dart';

part 'reset_password_provider.g.dart';

@riverpod
class ResetPassword extends _$ResetPassword {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> resetPassword(ResetPasswordEntity request) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    final result = await ref.read(resetForgotPasswordUseCaseProvider)(request);

    state = result.when(
      success: (_) => const AsyncValue.data(null),
      error: (failure) => AsyncValue.error(failure, StackTrace.current),
    );
  }
}
