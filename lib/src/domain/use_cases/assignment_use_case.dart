import '../../core/base/result.dart';
import '../entities/assignment_entity.dart';
import '../entities/shift_entity.dart';
import '../repositories/assignment_repository.dart';
import '../repositories/authentication_repository.dart';

final class AssignStaffUseCase {
  AssignStaffUseCase(this._assignmentRepository, this._authRepository);

  final AssignmentRepository _assignmentRepository;
  final AuthenticationRepository _authRepository;

  Future<Result<AssignmentResponseEntity, String>> call({
    required ShiftEntity shift,
    required int attendantId,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error('Partner ID not found');

    final rosterId = shift.weeklyRosterId;
    if (rosterId == null) return const Error('Roster ID not available for this shift');

    final request = AssignmentRequestEntity(
      attendantId: attendantId,
      shiftTemplateId: shift.shiftTemplateId,
      shiftDates: [shift.shiftDate],
    );

    final result = await _assignmentRepository.assignStaff(
      partnerId: partnerId,
      facilityId: shift.facility.id,
      rosterId: rosterId,
      request: request,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to assign staff'),
    };
  }
}
