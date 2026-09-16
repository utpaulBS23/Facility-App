import '../../../core/base/failure.dart';
import '../../../core/base/result.dart';
import '../../repositories/facility_expense_repository.dart';
import '../partner_use_case.dart';

final class DeleteFacilityExpenseUseCase extends PartnerUseCase {
  DeleteFacilityExpenseUseCase({
    required this.facilityExpenseRepository,
    required super.authRepository,
  });

  final FacilityExpenseRepository facilityExpenseRepository;

  Future<Result<void, Failure>> call({required int facilityExpenseId}) async {
    final partnerId = getPartnerId();
    final result = await facilityExpenseRepository.deleteFacilityExpense(
      partnerId: partnerId,
      facilityExpenseId: facilityExpenseId,
    );

    return switch (result) {
      Success() => const Success(),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('delete facility expense')),
    };
  }
}
