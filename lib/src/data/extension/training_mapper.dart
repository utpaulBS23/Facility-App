import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/training/training_completion_status.dart';
import '../../domain/entities/training/training_participant_entity.dart';
import '../../domain/entities/training/training_session_entity.dart';
import '../../domain/entities/training/training_status.dart';
import '../models/training/training_models.dart';
import '../models/training/training_response_model.dart';

extension TrainingSessionModelMapper on TrainingSessionModel {
  TrainingSessionEntity toEntity() {
    return TrainingSessionEntity(
      id: id,
      title: title,
      description: description ?? '',
      facilityName: facilityName ?? '',
      facilitatorName: facilitatorName,
      scheduledAt: DateTime.parse(scheduledAt),
      durationMinutes: durationMinutes,
      status: TrainingStatus.fromWireString(status),
      participants: [
        for (final participant
            in participants ?? const <TrainingParticipantModel>[])
          participant.toEntity(),
      ],
    );
  }
}

extension TrainingParticipantModelToEntity on TrainingParticipantModel {
  TrainingParticipantEntity toEntity() {
    return TrainingParticipantEntity(
      id: id,
      userId: userId,
      completionStatus: TrainingCompletionStatus.fromWireString(
        completionStatus,
      ),
    );
  }
}

extension TrainingParticipantResponseModelToEntity
    on TrainingParticipantResponseModel {
  TrainingParticipantEntity toEntity() {
    final payload = data;
    if (payload == null) {
      throw const FormatException(
        'Missing data payload in TrainingParticipantResponseModel',
      );
    }

    return payload.toEntity();
  }
}

extension TrainingSessionResponseModelToEntity on TrainingSessionResponseModel {
  TrainingSessionEntity toEntity() {
    final payload = data;
    if (payload == null) {
      throw const FormatException(
        'Missing data payload in TrainingSessionResponseModel',
      );
    }

    return payload.toEntity();
  }
}

extension TrainingSessionListResponseModelToEntity on TrainingSessionListResponseModel {
  PaginatedListEntity<TrainingSessionEntity> toEntity() {
    final items = data.map((model) => model.toEntity()).toList();
    final curPage = meta?.currentPage ?? 1;
    final size = meta?.perPage ?? 20;
    final total = meta?.total ?? items.length;
    final hasMore = meta?.lastPage != null
        ? curPage < meta!.lastPage!
        : (curPage * size) < total;

    return PaginatedListEntity<TrainingSessionEntity>(
      items: items,
      currentPage: curPage,
      pageSize: size,
      totalRecords: total,
      hasMore: hasMore,
    );
  }
}
