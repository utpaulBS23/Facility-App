import '../../../../../domain/entities/saved_account/saved_account_entity.dart';

class SavedAccountsState {
  const SavedAccountsState({required this.accounts, this.selectedUid});

  /// Most recently used first.
  final List<SavedAccountEntity> accounts;
  final String? selectedUid;

  bool get isEmpty => accounts.isEmpty;

  /// The account shown on the welcome-back card: the one the user picked, else
  /// the most recently used.
  SavedAccountEntity? get selected {
    if (accounts.isEmpty) return null;

    return accounts.firstWhere(
      (account) => account.uid == selectedUid,
      orElse: () => accounts.first,
    );
  }
}
