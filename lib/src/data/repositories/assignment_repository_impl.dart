import '../../core/base/base.dart';
import '../../domain/entities/assignment_entity.dart';
import '../../domain/repositories/assignment_repository.dart';
import '../models/assignment_model.dart';
import '../services/network/rest_client.dart';

final class AssignmentRepositoryImpl extends AssignmentRepository {
  AssignmentRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<AssignmentResponseEntity, Failure>> assignStaff({
    required int partnerId,
    required int facilityId,
    required int rosterId,
    required AssignmentRequestEntity request,
  }) {
    return asyncGuard(() async {
      final model = AssignmentRequestModel.fromEntity(request);
      final response = await remote.assignStaff(
        partnerId: partnerId,
        facilityId: facilityId,
        rosterId: rosterId,
        request: model.toJson(),
      );
      return AssignmentResponseModel.fromJson(response.data).toEntity();
    });
  }
}
