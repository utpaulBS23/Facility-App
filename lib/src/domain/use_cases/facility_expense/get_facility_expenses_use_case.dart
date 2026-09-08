import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../entities/facility_expense/facility_expense_entity.dart';
import '../../entities/facility_expense/facility_expense_filter.dart';
import '../../repositories/facility_expense_repository.dart';
import '../partner_use_case.dart';

final class GetFacilityExpensesUseCase extends PartnerUseCase {
  GetFacilityExpensesUseCase({
    required this.facilityExpenseRepository,
    required super.authRepository,
  });

  final FacilityExpenseRepository facilityExpenseRepository;

  Future<Result<FacilityExpenseListResultEntity, Failure>> call([
    FacilityExpenseFilter? filter,
  ]) async {
    final partnerId = getPartnerId();
    final result = await facilityExpenseRepository.getFacilityExpenses(
      (filter ?? const FacilityExpenseFilter()).copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) when data != null => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get facility expenses')),
    };
  }
}
