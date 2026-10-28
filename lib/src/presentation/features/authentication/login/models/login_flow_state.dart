import '../../../../../domain/entities/saved_account/saved_account_entity.dart';

/// Which screen of the login page is showing.
enum LoginView { accounts, add, manage }

class LoginFlowState {
  const LoginFlowState({
    required this.view,
    this.saveAccount = true,
    this.directAccount,
    this.isLanding = false,
  });

  final LoginView view;

  /// The "save account on this device" checkbox.
  final bool saveAccount;

  /// Set while a one-tap sign-in is in flight. The login state alone cannot
  /// tell a one-tap sign-in from a typed one, and only the one-tap flow shows
  /// the loader and falls back to the form.
  final SavedAccountEntity? directAccount;

  /// Sign-in succeeded and the first screen is being prepared. The page must
  /// keep showing progress, or it falls back to an idle form for that gap.
  final bool isLanding;

  LoginFlowState copyWith({
    LoginView? view,
    bool? saveAccount,
    SavedAccountEntity? directAccount,
    bool? isLanding,
    bool clearDirectAccount = false,
  }) {
    return LoginFlowState(
      view: view ?? this.view,
      saveAccount: saveAccount ?? this.saveAccount,
      directAccount: clearDirectAccount
          ? null
          : directAccount ?? this.directAccount,
      isLanding: isLanding ?? this.isLanding,
    );
  }
}
