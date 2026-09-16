import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/facility_expense/facility_expense_entity.dart';
import '../entities/facility_expense/facility_expense_filter.dart';
import '../entities/facility_expense/facility_expense_payloads.dart';

abstract base class FacilityExpenseRepository extends Repository {
  Future<Result<FacilityExpenseListResultEntity, Failure>> getFacilityExpenses(
    FacilityExpenseFilter filter,
  );

  Future<Result<FacilityExpenseEntity, Failure>> createFacilityExpense(
    CreateFacilityExpenseRequestEntity request,
  );

  Future<Result<void, Failure>> deleteFacilityExpense({
    required int partnerId,
    required int facilityExpenseId,
  });
}
