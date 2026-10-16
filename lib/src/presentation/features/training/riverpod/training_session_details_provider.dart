import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/training/training_completion_status.dart';
import '../../../../domain/entities/training/training_session_entity.dart';
import 'training_sessions_list_provider.dart';

part 'training_session_details_provider.g.dart';

@riverpod
class TrainingSessionDetails extends _$TrainingSessionDetails {
  @override
  Future<TrainingSessionEntity> build(int trainingSessionId) async {
    final Result<TrainingSessionEntity, Failure> result = await ref
        .read(getTrainingSessionDetailsUseCaseProvider)
        .call(trainingSessionId);

    return result.when(
      success: (data) => data!,
      error: (error) => throw error,
    );
  }

  /// Marks the logged-in user's own attendance on this session.
  ///
  /// Returns null on success, or the failure. On success the details and the
  /// sessions list are refetched, so the shown status comes from the server.
  Future<Failure?> markAttendance({
    required int participantId,
    required TrainingCompletionStatus status,
  }) async {
    final result = await ref
        .read(markTrainingAttendanceUseCaseProvider)
        .call(
          trainingSessionId: trainingSessionId,
          participantId: participantId,
          status: status,
        );

    return result.when(
      success: (_) {
        ref.invalidate(trainingSessionsListProvider);
        ref.invalidateSelf();
        return null;
      },
      error: (error) => error,
    );
  }
}
