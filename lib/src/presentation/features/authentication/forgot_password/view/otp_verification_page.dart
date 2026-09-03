// Author: Md. Shahin Bashar
// Created: 2026-04-03

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/base/failure.dart';
import '../../../../../core/extensions/app_localization.dart';
import '../../../../../core/extensions/failure_localization.dart';
import '../../../../../domain/entities/forgot_password/forgot_password_entities.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/application_logo.dart';
import '../../../../core/widgets/detail_app_bar.dart';
import '../../../../core/widgets/link_text.dart';
import '../../../../core/widgets/text/typography.dart';
import '../riverpod/send_otp_provider.dart';
import '../riverpod/verify_otp_provider.dart';

part '../widgets/otp_verification_body.dart';

class ForgotPasswordOtpVerificationPage extends ConsumerStatefulWidget {
  const ForgotPasswordOtpVerificationPage({super.key, this.phoneNumber});

  final String? phoneNumber;

  @override
  ConsumerState<ForgotPasswordOtpVerificationPage> createState() =>
      _ForgotPasswordOtpVerificationPageState();
}

class _ForgotPasswordOtpVerificationPageState
    extends ConsumerState<ForgotPasswordOtpVerificationPage> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _onOtpCompleted(String otp) {
    final phone = widget.phoneNumber ?? '';
    if (phone.isEmpty) return;

    ref.read(verifyOtpProvider.notifier).verifyOtp(
          VerifyOtpEntity(
            phoneNumber: phone,
            otp: otp,
          ),
        );
  }

  void _onResendCode() {
    final phone = widget.phoneNumber ?? '';
    if (phone.isEmpty) return;

    ref.read(sendOtpProvider.notifier).sendOtp(
          SendOtpEntity(phoneNumber: phone),
        );
  }

  void _onTryAnotherEmail() {
    context.pushNamed(Routes.resetPassword);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(verifyOtpProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData && next.value != null) {
        context.pushReplacementNamed(
          Routes.createNewPassword,
          extra: {
            'phoneNumber': widget.phoneNumber ?? '',
            'resetToken': next.value!.resetToken,
          },
        );
      } else if (next is AsyncError) {
        final err = next.error;
        AppSnackBar.showError(
          context,
          err is Failure ? err.localizedMessage(context) : err.toString(),
        );
      }
    });

    ref.listen(sendOtpProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData && next.value != null) {
        AppSnackBar.showSuccess(context, context.locale.otpSentSuccessfully);
      } else if (next is AsyncError) {
        final err = next.error;
        AppSnackBar.showError(
          context,
          err is Failure ? err.localizedMessage(context) : err.toString(),
        );
      }
    });

    final verifyState = ref.watch(verifyOtpProvider);

    return Scaffold(
      appBar: DetailAppBar(title: context.locale.verifyOtp),
      body: _OtpVerificationBody(
        phoneNumber: widget.phoneNumber,
        otpController: otpController,
        onOtpCompleted: _onOtpCompleted,
        onResendCode: _onResendCode,
        onTryAnotherEmail: _onTryAnotherEmail,
        isLoading: verifyState.isLoading,
      ),
    );
  }
}
