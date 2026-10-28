part of '../view/login_page.dart';

/// The login page's main screen: the welcome-back card when accounts are saved
/// and one is selected, otherwise the sign-in form.
class _SignInBody extends StatelessWidget {
  const _SignInBody({
    required this.saved,
    required this.flow,
    required this.isSigningIn,
    required this.formKey,
    required this.uidController,
    required this.passwordController,
    required this.onBack,
    required this.onSaveAccountChanged,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onSignInWith,
    required this.onOpenPicker,
    required this.onUseAnother,
    required this.onManage,
  });

  final SavedAccountsState saved;
  final LoginFlowState flow;

  /// A sign-in is running, or has succeeded and the first screen is loading.
  final bool isSigningIn;

  final GlobalKey<FormState> formKey;
  final TextEditingController uidController;
  final TextEditingController passwordController;

  final VoidCallback onBack;
  final ValueChanged<bool> onSaveAccountChanged;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final ValueChanged<SavedAccountEntity> onSignInWith;
  final VoidCallback onOpenPicker;
  final VoidCallback onUseAnother;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;
    final selected = saved.selected;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.padding.p16,
        vertical: dimensions.padding.p24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _LoginHeader(
            canGoBack: flow.view == LoginView.add && !saved.isEmpty,
            onBack: onBack,
          ),
          Gap(dimensions.spacing.s40),
          if (flow.view == LoginView.accounts && selected != null)
            _WelcomeBackCard(
              account: selected,
              onSignIn: () => onSignInWith(selected),
              onOpenPicker: onOpenPicker,
              onUseAnother: onUseAnother,
              onManage: onManage,
            )
          else
            Form(
              key: formKey,
              child: _LoginCard(
                uidController: uidController,
                passwordController: passwordController,
                title: saved.isEmpty
                    ? context.locale.login
                    : context.locale.addAccountTitle,
                subtitle: saved.isEmpty
                    ? context.locale.loginSubtitle
                    : context.locale.addAccountSubtitle,
                saveAccount: flow.saveAccount,
                onSaveAccountChanged: onSaveAccountChanged,
                isLoading: isSigningIn,
                onLogin: onLogin,
                onForgotPassword: onForgotPassword,
              ),
            ),
          Gap(dimensions.spacing.s24),
        ],
      ),
    );
  }
}
