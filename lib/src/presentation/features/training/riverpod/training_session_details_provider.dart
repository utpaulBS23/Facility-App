import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/training/training_session_entity.dart';

part 'training_session_details_provider.g.dart';

@riverpod
Future<TrainingSessionEntity> trainingSessionDetails(
  Ref ref,
  int trainingSessionId,
) async {
  final Result<TrainingSessionEntity, Failure> result = await ref
      .read(getTrainingSessionDetailsUseCaseProvider)
      .call(trainingSessionId);

  return result.when(
    success: (data) => data!,
    error: (error) => throw Exception(error.message),
  );
}
