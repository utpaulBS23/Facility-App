// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../view/email_verification_page.dart';

class _EmailVerificationBody extends StatelessWidget {
  const _EmailVerificationBody({
    required this.otpController,
    required this.onOtpCompleted,
    required this.onResendCode,
    required this.onTryAnotherEmail,
  });

  final TextEditingController otpController;
  final ValueChanged<String> onOtpCompleted;
  final VoidCallback onResendCode;
  final VoidCallback onTryAnotherEmail;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    // WHY: Pinput theme configuration follows app design system colors and spacing
    final defaultPinTheme = PinTheme(
      width: dimensions.spacing.s56,
      height: dimensions.spacing.s56,
      textStyle: context.textStyle.titleLarge.copyWith(
        color: colors.text.primary,
      ),
      decoration: BoxDecoration(
        color: colors.onPrimary,
        borderRadius: BorderRadius.circular(dimensions.radius.r12),
        border: Border.all(color: colors.border),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: colors.borderBrandFocus),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: colors.error),
      ),
    );

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.padding.p16),
          child: Column(
            children: [
              Gap(context.spacing.s24),
              ApplicationLogo(),
              Gap(context.spacing.s24),
              HeadlineLargeText(context.locale.checkYourMail),
              Gap(context.spacing.s8),
              BodyRegularText.secondary(
                context.locale.enterVerificationCode,
                textAlign: TextAlign.center,
              ),
              Gap(context.spacing.s32),
              Pinput(
                controller: otpController,
                length: 4,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                errorPinTheme: errorPinTheme,
                onCompleted: onOtpCompleted,
                keyboardType: TextInputType.number,
                hapticFeedbackType: HapticFeedbackType.lightImpact,
              ),
              Gap(context.spacing.s24),
              LinkText(
                text: context.locale.didntGetCode,
                linkText: context.locale.clickToResend,
                onTap: onResendCode,
              ),
              Gap(context.spacing.s8),
              LinkText(
                text: context.locale.didNotReceiveEmail,
                linkText: context.locale.tryAnotherEmail,
                onTap: onTryAnotherEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
