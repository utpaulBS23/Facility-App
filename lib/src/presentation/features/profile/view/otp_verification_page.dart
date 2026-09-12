part of 'my_profile_page.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  static const _otpLength = 6;
  static const _resendSeconds = 59;

  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  int _secondsLeft = _resendSeconds;
  bool _canVerify = false;

  @override
  void initState() {
    super.initState();
    // Show success snackbar on arrival
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_outline,
                    color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(context.locale.otpSentSuccessfully),
              ],
            ),
            backgroundColor: context.color.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.radius.r10),
            ),
          ),
        );
      }
    });
    _startCountdown();
    for (final c in _controllers) {
      c.addListener(_onOtpChanged);
    }
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
        _startCountdown();
      }
    });
  }

  void _onOtpChanged() {
    final filled = _controllers.every((c) => c.text.isNotEmpty);
    if (filled != _canVerify) {
      setState(() => _canVerify = filled);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: color.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: color.primary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.s16,
                vertical: spacing.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Header card ---
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: spacing.s24,
                      horizontal: spacing.s16,
                    ),
                    decoration: BoxDecoration(
                      color: color.onPrimary,
                      borderRadius: BorderRadius.circular(context.radius.r12),
                      border: Border.all(color: color.borderSubtle),
                    ),
                    child: Column(
                      children: [
                        const AuthHeaderIcon(icon: Icons.phone_android_outlined),
                        Gap(spacing.s16),
                        Text(
                          context.locale.enterYourOtp,
                          style: textStyle.titleMedium.copyWith(
                            color: color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(spacing.s4),
                        Text(
                          context.locale.enterSixDigitCode,
                          style: textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Gap(spacing.s8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              color: color.text.secondary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '0171****678',
                              style: textStyle.bodySmall.copyWith(
                                color: color.text.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Gap(spacing.s32),
                  // --- OTP cells ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_otpLength, (index) {
                      return SizedBox(
                        width: 44,
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: textStyle.titleMedium.copyWith(
                            color: color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: color.onPrimary,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: spacing.s14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: color.borderSubtle),
                              borderRadius: BorderRadius.circular(context.radius.r10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color.borderBrandFocus,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(context.radius.r10),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < _otpLength - 1) {
                              _focusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  Gap(spacing.s20),
                  // --- Resend countdown ---
                  Center(
                    child: Text(
                      _secondsLeft > 0
                          ? context.locale.resendIn(_secondsLeft)
                          : context.locale.resendOtp,
                      style: textStyle.bodySmall.copyWith(
                        color: _secondsLeft > 0
                            ? color.text.secondary
                            : color.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // --- Verify button ---
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                spacing.s8,
                spacing.s16,
                spacing.s16,
              ),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: color.primary,
                  minimumSize: Size(double.infinity, spacing.s44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.radius.r12),
                  ),
                ),
                onPressed: _canVerify
                    ? () {
                        // TODO(profile): wire up OTP verification API
                      }
                    : null,
                child: Text(
                  context.locale.verifyOtp,
                  style: textStyle.labelLarge.copyWith(
                    color: color.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
