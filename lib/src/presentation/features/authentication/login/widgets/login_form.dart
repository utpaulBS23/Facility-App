// Author: Md. Shahin Bashar
// Created: 2026-04-02

part of '../view/login_page.dart';

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.uidController,
    required this.passwordController,
    required this.title,
    required this.subtitle,
    required this.saveAccount,
    required this.onSaveAccountChanged,
    required this.isLoading,
    required this.onLogin,
    required this.onForgotPassword,
  });

  final TextEditingController uidController;
  final TextEditingController passwordController;
  final String title;
  final String subtitle;
  final bool saveAccount;
  final ValueChanged<bool> onSaveAccountChanged;
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
      decoration: _loginCardDecoration(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadlineLargeText(title),
          Gap(dimensions.spacing.s6),
          BodyRegularText(subtitle, color: colors.text.secondary),
          Gap(dimensions.spacing.s16),
          AppTextField.text(
            controller: uidController,
            label: context.locale.userId,
            hint: context.locale.enterYourId,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            prefixIcon: SizedBox(
              width: dimensions.spacing.s20,
              height: dimensions.spacing.s20,
              child: Icon(Icons.person_outline, color: colors.icon),
            ),
          ),
          Gap(dimensions.spacing.s12),
          AppTextField.password(
            controller: passwordController,
            label: context.locale.password,
            hint: context.locale.password,
            textInputAction: TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          Gap(dimensions.spacing.s8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _SaveAccountCheckbox(
                  value: saveAccount,
                  onChanged: onSaveAccountChanged,
                ),
              ),
              _ForgotPasswordButton(onForgotPassword: onForgotPassword),
            ],
          ),
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

/// Rounded white surface with the soft shadow shared by every card on the
/// login page.
BoxDecoration _loginCardDecoration(BuildContext context) {
  final dimensions = context.dimensions;

  return BoxDecoration(
    color: context.color.onPrimary,
    borderRadius: BorderRadius.circular(dimensions.radius.r20),
    boxShadow: [
      BoxShadow(
        color: context.color.shadow,
        offset: const Offset(0, 2),
        blurRadius: 14,
      ),
    ],
  );
}
