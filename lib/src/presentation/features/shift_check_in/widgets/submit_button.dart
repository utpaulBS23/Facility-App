// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../view/shift_check_in_page.dart';

/// Full-width submit button matching the Figma "Button" component
/// (node 13045:27268). Height 56px, brand background, white label.
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onSubmit,
      child: Text(context.locale.submit),
    );
  }
}
