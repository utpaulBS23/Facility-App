import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/travel_expense_entity.dart';
import '../repositories/travel_expense_repository.dart';
import 'partner_use_case.dart';

final class CreateTravelExpenseUseCase extends PartnerUseCase {
  CreateTravelExpenseUseCase({
    required this.repository,
    required super.authRepository,
  });

  final TravelExpenseRepository repository;

  Future<Result<TravelExpenseEntity, Failure>> call(
    CreateTravelExpenseRequestEntity request,
  ) async {
    final partnerId = getPartnerId();
    final result = await repository.createTravelExpense(
      request.copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('submit travel expense')),
    };
  }
}

final class GetTravelExpensesUseCase extends PartnerUseCase {
  GetTravelExpensesUseCase({
    required this.repository,
    required super.authRepository,
  });

  final TravelExpenseRepository repository;

  Future<Result<List<TravelExpenseEntity>, Failure>> call([
    TravelExpenseFilter? filter,
  ]) async {
    final partnerId = getPartnerId();
    final result = await repository.getTravelExpenses(
      (filter ?? const TravelExpenseFilter()).copyWith(partnerId: partnerId),
    );

    return switch (result) {
      Success(:final data) => Success(data: data ?? const []),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get travel expenses')),
    };
  }
}
