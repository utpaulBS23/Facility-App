import '../../core/base/base.dart';
import '../entities/travel_expense_entity.dart';

abstract base class TravelExpenseRepository extends Repository {
  Future<Result<TravelExpenseEntity, Failure>> createTravelExpense(
    CreateTravelExpenseRequestEntity request,
  );

  Future<Result<List<TravelExpenseEntity>, Failure>> getTravelExpenses(
    TravelExpenseFilter filter,
  );
}
