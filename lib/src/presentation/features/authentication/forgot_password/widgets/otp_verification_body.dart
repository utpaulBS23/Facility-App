// Author: Md. Shahin Bashar
// Created: 2026-04-03

part of '../view/otp_verification_page.dart';

class _OtpVerificationBody extends StatelessWidget {
  const _OtpVerificationBody({
    this.phoneNumber,
    required this.otpController,
    required this.onOtpCompleted,
    required this.onResendCode,
    required this.onTryAnotherEmail,
    required this.isLoading,
  });

  final String? phoneNumber;
  final TextEditingController otpController;
  final ValueChanged<String> onOtpCompleted;
  final VoidCallback onResendCode;
  final VoidCallback onTryAnotherEmail;
  final bool isLoading;

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

    final phoneStr = phoneNumber != null && phoneNumber!.isNotEmpty
        ? phoneNumber
        : '';

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.padding.p16),
          child: Column(
            children: [
              Gap(context.spacing.s24),
              ApplicationLogo(),
              Gap(context.spacing.s24),
              HeadlineLargeText(context.locale.verifyOtp),
              Gap(context.spacing.s8),
              BodyRegularText.secondary(
                phoneStr != null && phoneStr.isNotEmpty
                    ? '${context.locale.enterVerificationCode} ($phoneStr)'
                    : context.locale.enterVerificationCode,
                textAlign: TextAlign.center,
              ),
              Gap(context.spacing.s32),
              Pinput(
                controller: otpController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                errorPinTheme: errorPinTheme,
                onCompleted: isLoading ? null : onOtpCompleted,
                keyboardType: TextInputType.number,
                hapticFeedbackType: HapticFeedbackType.lightImpact,
              ),
              if (isLoading) ...[
                Gap(dimensions.spacing.s16),
                const CircularProgressIndicator(),
              ],
              Gap(context.spacing.s24),
              LinkText(
                text: context.locale.didntGetCode,
                linkText: context.locale.clickToResend,
                onTap: onResendCode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
