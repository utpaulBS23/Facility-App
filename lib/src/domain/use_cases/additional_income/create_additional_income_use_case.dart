import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/additional_income/additional_income_entity.dart';
import '../../entities/additional_income/additional_income_payloads.dart';
import '../../repositories/additional_income_repository.dart';
import '../partner_use_case.dart';

final class CreateAdditionalIncomeUseCase extends PartnerUseCase {
  CreateAdditionalIncomeUseCase({
    required this.additionalIncomeRepository,
    required super.authRepository,
  });

  final AdditionalIncomeRepository additionalIncomeRepository;

  Future<Result<AdditionalIncomeEntity, Failure>> call(
    CreateAdditionalIncomeRequestEntity request,
  ) async {
    final partnerId = getPartnerId();
    final result = await additionalIncomeRepository.createAdditionalIncome(
      request.copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('create additional income')),
    };
  }
}
