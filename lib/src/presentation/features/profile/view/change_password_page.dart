part of 'my_profile_page.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController.addListener(_onFieldChanged);
    _newPasswordController.addListener(_onFieldChanged);
    _confirmPasswordController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final enabled =
        _currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
    if (enabled != _canSubmit) {
      setState(() => _canSubmit = enabled);
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    await ref.read(editProfileProvider.notifier).updateProfile(
          UpdateProfileEntity(
            currentPassword: currentPassword,
            newPassword: newPassword,
            newPasswordConfirmation: confirmPassword,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    ref.listen(editProfileProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData) {
        AppSnackBar.showSuccess(context, context.locale.changePassword);
        if (context.canPop()) {
          context.pop();
        }
      } else if (next is AsyncError) {
        final err = next.error;
        AppSnackBar.showError(
          context,
          err is Failure ? err.localizedMessage(context) : err.toString(),
        );
      }
    });

    final changeState = ref.watch(editProfileProvider);
    final isLoading = changeState.isLoading;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: color.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: color.primary, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: Text(
          context.locale.changePassword,
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
                        const AuthHeaderIcon(icon: Icons.lock_outline),
                        Gap(spacing.s16),
                        Text(
                          context.locale.changePassword,
                          style: textStyle.titleMedium.copyWith(
                            color: color.text.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(spacing.s4),
                        Text(
                          context.locale.accountSecurity,
                          style: textStyle.bodySmall.copyWith(
                            color: color.text.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(spacing.s24),
                  AppTextField.password(
                    controller: _currentPasswordController,
                    label: context.locale.currentPassword,
                    hint: context.locale.currentPassword,
                  ),
                  Gap(spacing.s16),
                  AppTextField.password(
                    controller: _newPasswordController,
                    label: context.locale.newPassword,
                    hint: context.locale.newPassword,
                  ),
                  Gap(spacing.s16),
                  AppTextField.password(
                    controller: _confirmPasswordController,
                    label: context.locale.confirmPassword,
                    hint: context.locale.confirmPassword,
                  ),
                ],
              ),
            ),
          ),
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
                onPressed: (_canSubmit && !isLoading) ? _submit : null,
                child: isLoading
                    ? SizedBox(
                        height: spacing.s20,
                        width: spacing.s20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color.onPrimary,
                        ),
                      )
                    : Text(
                        context.locale.changePassword,
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
