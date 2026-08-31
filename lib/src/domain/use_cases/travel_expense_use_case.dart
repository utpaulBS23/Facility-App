import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/travel_expense_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/travel_expense_repository.dart';

final class CreateTravelExpenseUseCase {
  CreateTravelExpenseUseCase(this._repository, this._authRepository);

  final TravelExpenseRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<TravelExpenseEntity, Failure>> call(
    CreateTravelExpenseRequestEntity request,
  ) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.createTravelExpense(partnerId, request);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('submit travel expense')),
    };
  }
}
