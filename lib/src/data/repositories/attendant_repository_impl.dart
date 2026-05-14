import '../../core/base/base.dart';
import '../../domain/entities/attendant_entity.dart';
import '../../domain/repositories/attendant_repository.dart';
import '../extension/attendant_mapper.dart';
import '../models/attendant_model.dart';
import '../services/network/rest_client.dart';

final class AttendantRepositoryImpl extends AttendantRepository {
  AttendantRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<List<AttendantEntity>, Failure>> getFacilityAttendants({
    required int partnerId,
    required int facilityId,
  }) {
    return asyncGuard(() async {
      final response = await remote.getFacilityAttendants(
        partnerId: partnerId,
        facilityId: facilityId,
      );
      final model = AttendantResponseModel.fromJson(response.data);
      return model.data.map((a) => a.toEntity()).toList();
    });
  }
}
