// Author: Md. Shahin Bashar
// Created: 2026-04-03

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/base/failure.dart';
import '../../../../../core/extensions/app_localization.dart';
import '../../../../../core/extensions/failure_localization.dart';
import '../../../../../domain/entities/forgot_password/forgot_password_entities.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/detail_app_bar.dart';
import '../../../../core/widgets/text/typography.dart';
import '../riverpod/send_otp_provider.dart';

part '../widgets/reset_password_body.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!formKey.currentState!.validate()) return;
    final phone = phoneController.text.trim();
    ref.read(sendOtpProvider.notifier).sendOtp(
          SendOtpEntity(phoneNumber: phone),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sendOtpProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData && next.value != null) {
        context.pushNamed(
          Routes.emailVerification,
          extra: phoneController.text.trim(),
        );
      } else if (next is AsyncError) {
        final err = next.error;
        AppSnackBar.showError(
          context,
          err is Failure ? err.localizedMessage(context) : err.toString(),
        );
      }
    });

    final sendOtpState = ref.watch(sendOtpProvider);

    return Scaffold(
      appBar: DetailAppBar(title: context.locale.resetPassword),
      body: _ResetPasswordBody(
        formKey: formKey,
        phoneController: phoneController,
        onContinue: _onContinue,
        isLoading: sendOtpState.isLoading,
      ),
    );
  }
}
