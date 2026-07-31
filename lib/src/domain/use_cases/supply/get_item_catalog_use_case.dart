import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/common/paginated_list_entity.dart';
import '../../entities/supply/stock_item_entity.dart';
import '../../repositories/authentication_repository.dart';
import '../../repositories/item_catalog_repository.dart';

final class GetItemCatalogUseCase {
  GetItemCatalogUseCase(this._repository, this._authRepository);

  final ItemCatalogRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<PaginatedListEntity<StockItemEntity>, Failure>> call({
    String? search,
    String? category,
    bool? isActive,
    int? page,
    int? perPage,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await _repository.getItemCatalog(
      partnerId: partnerId,
      search: search,
      category: category,
      isActive: isActive,
      page: page,
      perPage: perPage,
    );

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}
