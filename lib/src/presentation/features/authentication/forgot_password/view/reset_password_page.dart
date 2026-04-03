// Author: Md. Shahin Bashar
// Created: 2026-04-03

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/text/typography.dart';

part '../widgets/reset_password_body.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!formKey.currentState!.validate()) return;
    // TODO: Call provider to send reset password email
    context.pushNamed(Routes.emailVerification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: HeadlineSmallText(context.locale.resetPassword)),
      body: _ResetPasswordBody(
        formKey: formKey,
        emailController: emailController,
        onContinue: _onContinue,
      ),
    );
  }
}
