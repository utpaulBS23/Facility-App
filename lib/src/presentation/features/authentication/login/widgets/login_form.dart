// Author: Md. Shahin Bashar
// Created: 2026-04-02

part of '../view/login_page.dart';

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.uidController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
    required this.onForgotPassword,
  });

  final TextEditingController uidController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dimensions.padding.p20),
      decoration: BoxDecoration(
        color: colors.onPrimary,
        borderRadius: BorderRadius.circular(dimensions.radius.r20),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            offset: const Offset(0, 2),
            blurRadius: 14,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadlineLargeText(context.locale.login),
          Gap(dimensions.spacing.s6),
          BodyRegularText(
            context.locale.loginSubtitle,
            color: colors.text.secondary,
          ),
          Gap(dimensions.spacing.s16),
          AppTextField.text(
            controller: uidController,
            label: context.locale.userId,
            hint: context.locale.enterYourId,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          Gap(dimensions.spacing.s16),
          AppTextField.password(
            controller: passwordController,
            label: context.locale.password,
            hint: context.locale.password,
            textInputAction: TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          _ForgotPasswordButton(onForgotPassword: onForgotPassword),
          Gap(dimensions.spacing.s16),
          SizedBox(
            width: double.infinity,
            height: dimensions.spacing.s44,
            child: FilledButton(
              onPressed: isLoading ? null : onLogin,
              child: isLoading
                  ? const LoadingIndicator()
                  : Text(context.locale.login),
            ),
          ),
        ],
      ),
    );
  }
}
