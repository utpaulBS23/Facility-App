// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../view/reset_password_page.dart';

class _ResetPasswordBody extends StatelessWidget {
  const _ResetPasswordBody({
    required this.formKey,
    required this.emailController,
    required this.onContinue,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final VoidCallback onContinue;

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
              BodyRegularText.secondary(context.locale.enterAssociatedEmail),
              Gap(context.spacing.s24),
              AppTextField.email(
                controller: emailController,
                label: context.locale.emailAddress,
                hint: context.locale.email,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onContinue(),
              ),
              Gap(context.spacing.s24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onContinue,
                  child: Text(context.locale.continueAction),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
