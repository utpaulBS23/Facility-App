import '../../core/base/base.dart';
import '../entities/travel_expense_entity.dart';

abstract base class TravelExpenseRepository extends Repository {
  Future<Result<TravelExpenseEntity, Failure>> createTravelExpense(
    CreateTravelExpenseRequestEntity request,
  );

  Future<Result<List<TravelExpenseEntity>, Failure>> getTravelExpenses(
    TravelExpenseFilter filter,
  );

  Future<Result<TravelExpenseEntity, Failure>> getTravelExpenseDetail({
    required int partnerId,
    required int travelExpenseId,
  });

  /// Approves the claim at its claimed amount.
  Future<Result<void, Failure>> approveTravelExpense({
    required int partnerId,
    required int travelExpenseId,
  });

  /// [note] is required by the server and at most 255 characters.
  Future<Result<void, Failure>> rejectTravelExpense({
    required int partnerId,
    required int travelExpenseId,
    required String note,
  });

  /// Only the claimant may delete their own claim, and only while it's still
  /// `waiting` — the server rejects anything else (403/422).
  Future<Result<void, Failure>> deleteTravelExpense({
    required int partnerId,
    required int travelExpenseId,
  });
}
