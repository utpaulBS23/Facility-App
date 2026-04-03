// Author: Md. Shahin Bashar
// Created: 2026-04-03

import 'package:facility_management_app/src/presentation/core/widgets/application_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/link_text.dart';
import '../../../../core/widgets/text/typography.dart';

part '../widgets/email_verification_body.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  ConsumerState<EmailVerificationPage> createState() =>
      _EmailVerificationPageState();
}

class _EmailVerificationPageState extends ConsumerState<EmailVerificationPage> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _onOtpCompleted(String otp) {
    // TODO: Call provider to verify OTP
    context.pushReplacementNamed(Routes.createNewPassword);
  }

  void _onResendCode() {
    // TODO: Call provider to resend OTP
  }

  void _onTryAnotherEmail() {
    context.pushNamed(Routes.resetPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: HeadlineSmallText(context.locale.checkYourMail)),
      body: _EmailVerificationBody(
        otpController: otpController,
        onOtpCompleted: _onOtpCompleted,
        onResendCode: _onResendCode,
        onTryAnotherEmail: _onTryAnotherEmail,
      ),
    );
  }
}
