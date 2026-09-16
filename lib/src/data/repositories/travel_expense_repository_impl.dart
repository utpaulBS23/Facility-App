import '../../core/base/base.dart';
import '../../domain/entities/travel_expense_entity.dart';
import '../../domain/repositories/travel_expense_repository.dart';
import '../extension/travel_expense_mapper.dart';
import '../models/travel_expense_model.dart';
import '../services/network/rest_client.dart';

final class TravelExpenseRepositoryImpl extends TravelExpenseRepository {
  TravelExpenseRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<TravelExpenseEntity, Failure>> createTravelExpense(
    CreateTravelExpenseRequestEntity request,
  ) {
    return asyncGuard(() async {
      final response = await remote.createTravelExpense(
        partnerId: request.partnerId!,
        body: request.toModel().toJson(),
      );
      final responseModel = TravelExpenseResponseModel.fromJson(response.data);
      final model = responseModel.data;
      if (model == null) {
        throw Exception('Empty travel expense response');
      }
      return model.toEntity();
    });
  }

  @override
  Future<Result<List<TravelExpenseEntity>, Failure>> getTravelExpenses(
    TravelExpenseFilter filter,
  ) {
    return asyncGuard(() async {
      final response = await remote.getTravelExpenses(
        partnerId: filter.partnerId!,
        status: filter.status?.toWireString(),
        facilityId: filter.facilityId,
        // WHY 100 flat, no paging: the app fetches one page and treats it as
        // the full list for now — see GetTravelExpensesUseCase.
        perPage: 100,
      );
      final responseModel = TravelExpenseListResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }
}
