import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/result.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/forgot_password/forgot_password_entities.dart';

part 'send_otp_provider.g.dart';

@riverpod
class SendOtp extends _$SendOtp {
  @override
  AsyncValue<SendOtpResponseEntity?> build() => const AsyncValue.data(null);

  Future<void> sendOtp(SendOtpEntity request) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    final result = await ref.read(sendForgotPasswordOtpUseCaseProvider)(request);

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (failure) => AsyncValue.error(failure, StackTrace.current),
    );
  }
}
