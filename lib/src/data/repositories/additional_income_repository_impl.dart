import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/additional_income/additional_income_entity.dart';
import '../../domain/entities/additional_income/additional_income_filter.dart';
import '../../domain/entities/additional_income/additional_income_payloads.dart';
import '../../domain/repositories/additional_income_repository.dart';
import '../extension/additional_income_mapper.dart';
import '../models/additional_income/additional_income_model.dart';
import '../services/network/rest_client.dart';

final class AdditionalIncomeRepositoryImpl extends AdditionalIncomeRepository {
  AdditionalIncomeRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<AdditionalIncomeListResultEntity, Failure>> getAdditionalIncomes(
    AdditionalIncomeFilter filter,
  ) {
    return asyncGuard(() async {
      final response = await remote.getAdditionalIncomes(
        partnerId: filter.partnerId!,
        facilityId: filter.facilityId,
        page: filter.page,
        perPage: filter.pageSize,
      );
      final responseModel = AdditionalIncomeListResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<AdditionalIncomeEntity, Failure>> createAdditionalIncome(
    CreateAdditionalIncomeRequestEntity request,
  ) {
    return asyncGuard(() async {
      final response = await remote.createAdditionalIncome(
        partnerId: request.partnerId!,
        body: request.toBody(),
      );
      final responseModel = AdditionalIncomeModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }
}
