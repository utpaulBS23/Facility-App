import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/master_data_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/master_data_repository.dart';

final class GetMasterDataItemsUseCase {
  GetMasterDataItemsUseCase(this._repository, this._authRepository);

  final MasterDataRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<List<MasterDataItemEntity>, Failure>> call({
    required String category,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    return _repository.getItems(partnerId: partnerId, category: category);
  }
}
