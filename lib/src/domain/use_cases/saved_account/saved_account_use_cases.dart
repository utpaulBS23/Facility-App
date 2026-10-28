import '../../../core/base/base.dart';
import '../../entities/saved_account/saved_account_entity.dart';
import '../../repositories/saved_account_repository.dart';

final class GetSavedAccountsUseCase {
  GetSavedAccountsUseCase({required this.savedAccountRepository});

  final SavedAccountRepository savedAccountRepository;

  List<SavedAccountEntity> call() => savedAccountRepository.getAll();
}

final class RemoveSavedAccountUseCase {
  RemoveSavedAccountUseCase({required this.savedAccountRepository});

  final SavedAccountRepository savedAccountRepository;

  Future<Result<bool, Failure>> call(String uid) async {
    final result = await savedAccountRepository.remove(uid);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('remove saved account')),
    };
  }
}
