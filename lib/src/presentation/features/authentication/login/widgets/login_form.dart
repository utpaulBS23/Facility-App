// Author: Md. Shahin Bashar
// Created: 2026-04-02

part of '../view/login_page.dart';

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
    required this.onForgotPassword,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final d = context.dimensions;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(d.padding.p20),
      decoration: BoxDecoration(
        color: c.onPrimary,
        borderRadius: BorderRadius.circular(d.radius.r20),
        // WHY: Shadow color derives from overlay (same base hue) at 10% opacity
        // to match the Figma EV-Card drop shadow token exactly.
        boxShadow: [
          BoxShadow(
            color: c.overlay.withAlpha(0x1A),
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
          Gap(d.spacing.s6),
          BodyRegularText(
            context.locale.loginSubtitle,
            color: c.text.secondary,
          ),
          Gap(d.spacing.s16),
          AppTextField.email(
            controller: emailController,
            label: context.locale.email,
            hint: context.locale.enterYourId,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          Gap(d.spacing.s16),
          AppTextField.password(
            controller: passwordController,
            label: context.locale.password,
            hint: context.locale.password,
            textInputAction: TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          _ForgotPasswordButton(onForgotPassword: onForgotPassword),
          Gap(d.spacing.s16),
          SizedBox(
            width: double.infinity,
            height: d.spacing.s44,
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
