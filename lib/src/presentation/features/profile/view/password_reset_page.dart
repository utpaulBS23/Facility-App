part of 'my_profile_page.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _userIdController = TextEditingController();
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _userIdController.addListener(() {
      final enabled = _userIdController.text.isNotEmpty;
      if (enabled != _canSubmit) {
        setState(() => _canSubmit = enabled);
      }
    });
  }

  @override
  void dispose() {
    _userIdController.dispose();
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
        title: Text(
          context.locale.passwordReset,
          style: textStyle.titleMedium.copyWith(
            color: color.text.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                        const AuthHeaderIcon(icon: Icons.key_outlined),
                        Gap(spacing.s16),
                        Text(
                          context.locale.passwordReset,
                          style: textStyle.titleMedium.copyWith(
                            color: color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(spacing.s4),
                        Text(
                          context.locale.enterYourUserId,
                          style: textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(spacing.s24),
                  // --- User ID field ---
                  AppTextField.text(
                    controller: _userIdController,
                    label: context.locale.userId,
                    hint: context.locale.enterYourUserIdHint,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  Gap(spacing.s16),
                  // --- OTP info box (no border, pale red bg) ---
                  Container(
                    padding: EdgeInsets.all(spacing.s16),
                    decoration: BoxDecoration(
                      color: color.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(context.radius.r12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.phone_android_outlined,
                          color: color.primary,
                          size: 20,
                        ),
                        Gap(spacing.s12),
                        Expanded(
                          child: Text(
                            context.locale.otpWillBeSent,
                            style: textStyle.bodySmall.copyWith(
                              color: color.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // --- Send OTP button ---
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
                onPressed: _canSubmit
                    ? () => context.pushNamed(Routes.otpVerification)
                    : null,
                child: Text(
                  context.locale.sendOtp,
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
