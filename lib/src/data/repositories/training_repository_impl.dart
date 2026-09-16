import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/training/training_filters.dart';
import '../../domain/entities/training/training_session_entity.dart';
import '../../domain/repositories/training_repository.dart';
import '../extension/training_mapper.dart';
import '../models/training/training_response_model.dart';
import '../services/network/rest_client.dart';

final class TrainingRepositoryImpl extends TrainingRepository {
  TrainingRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<PaginatedListEntity<TrainingSessionEntity>, Failure>>
  getTrainingSessions(TrainingSessionQueryFilter filter) {
    return asyncGuard(() async {
      final response = await remote.getTrainingSessions(
        partnerId: filter.partnerId!,
        facilityId: filter.facilityId,
        status: filter.status?.toWireString(),
        search: filter.search,
        page: filter.page,
        perPage: filter.pageSize,
      );
      final responseModel = TrainingSessionListResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<TrainingSessionEntity, Failure>> getTrainingSessionDetails({
    required int partnerId,
    required int trainingSessionId,
  }) {
    return asyncGuard(() async {
      final response = await remote.getTrainingSessionDetails(
        partnerId: partnerId,
        trainingSessionId: trainingSessionId,
      );
      final responseModel = TrainingSessionResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }
}
