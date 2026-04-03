// Author: Md. Shahin Bashar
// Created: 2026-04-02

part of '../view/login_page.dart';

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton({required this.onForgotPassword});

  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final textStyle = context.textStyle;

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onForgotPassword,
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: textStyle.labelXl,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(context.locale.forgotPassword),
      ),
    );
  }
}
