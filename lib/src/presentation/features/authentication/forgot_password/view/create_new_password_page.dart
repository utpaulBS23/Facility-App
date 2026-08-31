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
import '../../../../core/widgets/detail_app_bar.dart';
import '../../../../core/widgets/text/typography.dart';

part '../widgets/create_new_password_body.dart';

class CreateNewPasswordPage extends ConsumerStatefulWidget {
  const CreateNewPasswordPage({super.key});

  @override
  ConsumerState<CreateNewPasswordPage> createState() =>
      _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends ConsumerState<CreateNewPasswordPage> {
  final formKey = GlobalKey<FormState>();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _onResetPassword() {
    if (!formKey.currentState!.validate()) return;
    // TODO: Call provider to reset password
    context.pushReplacementNamed(Routes.resetPasswordSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar(title: context.locale.createNewPassword),
      body: _CreateNewPasswordBody(
        formKey: formKey,
        newPasswordController: newPasswordController,
        confirmPasswordController: confirmPasswordController,
        onResetPassword: _onResetPassword,
      ),
    );
  }
}
