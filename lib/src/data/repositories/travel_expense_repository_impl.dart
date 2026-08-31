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
    int partnerId,
    CreateTravelExpenseRequestEntity request,
  ) {
    return asyncGuard(() async {
      final response = await remote.createTravelExpense(
        partnerId: partnerId,
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
}
