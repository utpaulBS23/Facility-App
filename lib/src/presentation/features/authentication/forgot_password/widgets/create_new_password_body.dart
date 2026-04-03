// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../view/create_new_password_page.dart';

class _CreateNewPasswordBody extends StatelessWidget {
  const _CreateNewPasswordBody({
    required this.formKey,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.onResetPassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onResetPassword;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.padding.p16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(context.spacing.s16),
              BodyRegularText.secondary(context.locale.createNewPasswordHint),
              Gap(context.spacing.s24),
              AppTextField.password(
                controller: newPasswordController,
                label: context.locale.newPassword,
                hint: context.locale.newPassword,
                textInputAction: TextInputAction.next,
              ),
              Gap(context.spacing.s16),
              AppTextField.password(
                controller: confirmPasswordController,
                label: context.locale.confirmPassword,
                hint: context.locale.confirmPassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onResetPassword(),
              ),
              Gap(context.spacing.s32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onResetPassword,
                  child: Text(context.locale.resetPassword),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
