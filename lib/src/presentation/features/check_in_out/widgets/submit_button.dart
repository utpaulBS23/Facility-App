// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../view/shift_check_in_page.dart';

/// Full-width submit button matching the Figma "Button" component
/// (node 13045:27268). Height 56px, brand background, white label.
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.onSubmit, required this.isLoading});

  final VoidCallback onSubmit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onSubmit,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Text(context.locale.submit),
    );
  }
}
