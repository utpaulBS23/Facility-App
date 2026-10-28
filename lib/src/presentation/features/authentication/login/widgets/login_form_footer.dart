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

    return TextButton(
      onPressed: onForgotPassword,
      style: TextButton.styleFrom(
        foregroundColor: colors.primary,
        textStyle: textStyle.labelXl,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(context.locale.forgotPassword),
    );
  }
}

class _SaveAccountCheckbox extends StatelessWidget {
  const _SaveAccountCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;

    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          SizedBox(
            width: context.dimensions.spacing.s24,
            height: context.dimensions.spacing.s24,
            child: Checkbox(
              value: value,
              onChanged: (checked) => onChanged(checked ?? false),
              activeColor: colors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          SizedBox(width: context.dimensions.spacing.s8),
          Expanded(
            child: Text(
              context.locale.saveAccountOnDevice,
              style: context.textStyle.bodySmall.copyWith(
                color: colors.text.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
