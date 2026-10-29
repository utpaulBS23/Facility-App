import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../models/saved_accounts_state.dart';

part 'saved_accounts_provider.g.dart';

@riverpod
class SavedAccounts extends _$SavedAccounts {
  @override
  SavedAccountsState build() {
    return SavedAccountsState(
      accounts: ref.read(getSavedAccountsUseCaseProvider).call(),
    );
  }

  void reload() {
    state = SavedAccountsState(
      accounts: ref.read(getSavedAccountsUseCaseProvider).call(),
      selectedUid: state.selectedUid,
    );
  }

  void select(String uid) {
    state = SavedAccountsState(accounts: state.accounts, selectedUid: uid);
  }

  Future<void> remove(String uid) async {
    await ref.read(removeSavedAccountUseCaseProvider).call(uid);
    reload();
  }
}
