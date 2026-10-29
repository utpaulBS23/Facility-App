import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../domain/entities/saved_account/saved_account_entity.dart';
import '../models/login_flow_state.dart';
import 'saved_accounts_provider.dart';

part 'login_flow_provider.g.dart';

/// Which screen the login page shows, the save-account choice, and the account
/// being signed in with one tap.
@riverpod
class LoginFlow extends _$LoginFlow {
  @override
  LoginFlowState build() {
    final hasAccounts = !ref.read(savedAccountsProvider).isEmpty;

    return LoginFlowState(
      view: hasAccounts ? LoginView.accounts : LoginView.add,
    );
  }

  /// Back to the saved accounts, or to the form when none are left.
  void showAccounts() {
    final hasAccounts = !ref.read(savedAccountsProvider).isEmpty;
    state = state.copyWith(
      view: hasAccounts ? LoginView.accounts : LoginView.add,
    );
  }

  void showAdd() {
    state = state.copyWith(view: LoginView.add, saveAccount: true);
  }

  void showManage() {
    state = state.copyWith(view: LoginView.manage);
  }

  void setSaveAccount(bool value) {
    state = state.copyWith(saveAccount: value);
  }

  void startDirect(SavedAccountEntity account) {
    state = state.copyWith(directAccount: account);
  }

  void startLanding() {
    state = state.copyWith(isLanding: true);
  }

  void endDirect() {
    state = state.copyWith(clearDirectAccount: true);
  }
}
