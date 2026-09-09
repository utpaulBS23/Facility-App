import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/additional_income/additional_income_entity.dart';
import '../entities/additional_income/additional_income_filter.dart';
import '../entities/additional_income/additional_income_payloads.dart';

abstract base class AdditionalIncomeRepository extends Repository {
  Future<Result<AdditionalIncomeListResultEntity, Failure>> getAdditionalIncomes(
    AdditionalIncomeFilter filter,
  );

  Future<Result<AdditionalIncomeEntity, Failure>> createAdditionalIncome(
    CreateAdditionalIncomeRequestEntity request,
  );
}
