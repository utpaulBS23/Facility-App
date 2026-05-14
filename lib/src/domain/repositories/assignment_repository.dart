import '../../core/base/base.dart';
import '../entities/assignment_entity.dart';

abstract base class AssignmentRepository extends Repository {
  Future<Result<AssignmentResponseEntity, Failure>> assignStaff({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required AssignmentRequestEntity request,
  });
}
