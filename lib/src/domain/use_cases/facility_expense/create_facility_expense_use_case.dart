import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/facility_expense/facility_expense_entity.dart';
import '../../entities/facility_expense/facility_expense_payloads.dart';
import '../../repositories/facility_expense_repository.dart';
import '../partner_use_case.dart';

final class CreateFacilityExpenseUseCase extends PartnerUseCase {
  CreateFacilityExpenseUseCase({
    required this.facilityExpenseRepository,
    required super.authRepository,
  });

  final FacilityExpenseRepository facilityExpenseRepository;

  Future<Result<FacilityExpenseEntity, Failure>> call(
    CreateFacilityExpenseRequestEntity request,
  ) async {
    final partnerId = getPartnerId();
    final result = await facilityExpenseRepository.createFacilityExpense(
      request.copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('create facility expense')),
    };
  }
}
