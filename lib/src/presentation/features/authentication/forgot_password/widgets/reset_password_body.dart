// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../view/reset_password_page.dart';

class _ResetPasswordBody extends StatelessWidget {
  const _ResetPasswordBody({
    required this.formKey,
    required this.phoneController,
    required this.onContinue,
    required this.isLoading,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final VoidCallback onContinue;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final spacing = context.dimensions.spacing;

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
              AppTextField.text(
                controller: phoneController,
                label: context.locale.phoneNumber,
                hint: context.locale.enterPhoneNumber,
                prefixIcon: const Icon(Icons.phone_outlined),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => isLoading ? null : onContinue(),
              ),
              Gap(context.spacing.s24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isLoading ? null : onContinue,
                  child: isLoading
                      ? SizedBox(
                          height: spacing.s20,
                          width: spacing.s20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: color.onPrimary,
                          ),
                        )
                      : Text(context.locale.continueAction),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
