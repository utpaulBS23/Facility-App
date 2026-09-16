import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/additional_income/additional_income_entity.dart';
import '../../entities/additional_income/additional_income_filter.dart';
import '../../repositories/additional_income_repository.dart';
import '../partner_use_case.dart';

final class GetAdditionalIncomesUseCase extends PartnerUseCase {
  GetAdditionalIncomesUseCase({
    required this.additionalIncomeRepository,
    required super.authRepository,
  });

  final AdditionalIncomeRepository additionalIncomeRepository;

  Future<Result<AdditionalIncomeListResultEntity, Failure>> call([
    AdditionalIncomeFilter? filter,
  ]) async {
    final partnerId = getPartnerId();
    final result = await additionalIncomeRepository.getAdditionalIncomes(
      (filter ?? const AdditionalIncomeFilter()).copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get additional incomes')),
    };
  }
}
