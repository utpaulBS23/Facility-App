import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/result.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/forgot_password/forgot_password_entities.dart';

part 'verify_otp_provider.g.dart';

@riverpod
class VerifyOtp extends _$VerifyOtp {
  @override
  AsyncValue<VerifyOtpResponseEntity?> build() => const AsyncValue.data(null);

  Future<void> verifyOtp(VerifyOtpEntity request) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    final result = await ref.read(verifyForgotPasswordOtpUseCaseProvider)(request);

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (failure) => AsyncValue.error(failure, StackTrace.current),
    );
  }
}
