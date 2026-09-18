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
import '../riverpod/reset_password_provider.dart';

part '../widgets/create_new_password_body.dart';

class CreateNewPasswordPage extends ConsumerStatefulWidget {
  const CreateNewPasswordPage({
    super.key,
    this.phoneNumber,
    this.resetToken,
  });

  final String? phoneNumber;
  final String? resetToken;

  @override
  ConsumerState<CreateNewPasswordPage> createState() =>
      _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState
    extends ConsumerState<CreateNewPasswordPage> {
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
    final phone = widget.phoneNumber ?? '';
    final token = widget.resetToken ?? '';
    final password = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (phone.isEmpty || token.isEmpty) return;

    ref.read(resetPasswordProvider.notifier).resetPassword(
          ResetPasswordEntity(
            phoneNumber: phone,
            resetToken: token,
            password: password,
            passwordConfirmation: confirm,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(resetPasswordProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData) {
        context.pushReplacementNamed(Routes.resetPasswordSuccess);
      } else if (next is AsyncError) {
        final err = next.error;
        AppSnackBar.showError(
          context,
          err is Failure ? err.localizedMessage(context) : err.toString(),
        );
      }
    });

    final resetState = ref.watch(resetPasswordProvider);

    return Scaffold(
      appBar: DetailAppBar(title: context.locale.createNewPassword),
      body: _CreateNewPasswordBody(
        formKey: formKey,
        newPasswordController: newPasswordController,
        confirmPasswordController: confirmPasswordController,
        onResetPassword: _onResetPassword,
        isLoading: resetState.isLoading,
      ),
    );
  }
}
