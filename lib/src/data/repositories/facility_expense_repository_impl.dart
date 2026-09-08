import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/facility_expense/facility_expense_entity.dart';
import '../../domain/repositories/facility_expense_repository.dart';
import '../extension/facility_expense_mapper.dart';
import '../models/facility_expense/facility_expense_model.dart';
import '../services/network/rest_client.dart';

final class FacilityExpenseRepositoryImpl extends FacilityExpenseRepository {
  FacilityExpenseRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<FacilityExpenseListResultEntity, Failure>> getFacilityExpenses(
    FacilityExpenseFilter filter,
  ) {
    return asyncGuard(() async {
      final response = await remote.getFacilityExpenses(
        partnerId: filter.partnerId!,
        facilityId: filter.facilityId,
        page: filter.page,
        perPage: filter.pageSize,
      );
      final responseModel = FacilityExpenseListResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<FacilityExpenseEntity, Failure>> createFacilityExpense(
    CreateFacilityExpenseRequestEntity request,
  ) {
    return asyncGuard(() async {
      final response = await remote.createFacilityExpense(
        partnerId: request.partnerId!,
        body: request.toBody(),
      );
      final responseModel = FacilityExpenseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<void, Failure>> deleteFacilityExpense({
    required int partnerId,
    required int facilityExpenseId,
  }) {
    return asyncGuard(() async {
      await remote.deleteFacilityExpense(
        partnerId: partnerId,
        facilityExpenseId: facilityExpenseId,
      );
    });
  }
}
