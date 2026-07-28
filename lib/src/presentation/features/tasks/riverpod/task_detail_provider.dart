import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/task_entity.dart';

part 'task_detail_provider.g.dart';

@riverpod
class TaskDetail extends _$TaskDetail {
  @override
  AsyncValue<TaskEntity> build() => const AsyncValue.loading();

  Future<void> fetch({required int taskId}) async {
    state = const AsyncValue.loading();

    final Result<TaskEntity, Failure> result = await ref
        .read(getTaskDetailUseCaseProvider)
        .call(id: taskId);

    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error('Task not found', StackTrace.current),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<void> startIssue({required int issueId}) async {
    final Result<TaskEntity, Failure> result = await ref
        .read(startIssueUseCaseProvider)
        .call(issueId: issueId);

    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error('Task not found', StackTrace.current),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<TaskMediaEntity?> uploadMedia({
    required int taskId,
    required String photoPath,
    required String alt,
  }) async {
    final previousTask = state.valueOrNull;
    final Result<TaskMediaEntity, Failure> result = await ref
        .read(uploadTaskMediaUseCaseProvider)
        .call(
          taskId: taskId,
          photoPath: photoPath,
          alt: alt,
        );

    TaskMediaEntity? uploadedMedia;
    switch (result) {
      case Success(:final data) when previousTask != null && data != null:
        uploadedMedia = data;
        state = AsyncValue.data(
          previousTask.copyWith(media: [...previousTask.media, data]),
        );
      case Success():
        state = AsyncValue.error('Task not found', StackTrace.current);
      case Error(:final error):
        state = AsyncValue.error(error, StackTrace.current);
        throw Exception(error);
    }
    return uploadedMedia;
  }

  Future<TaskEntity?> completeIssue({required int issueId}) async {
    if (!ref.hasPermission(AppPermission.taskComplete)) {
      state = AsyncValue.error(Failure.permissionDenied, StackTrace.current);
      return null;
    }

    final previousTask = state.valueOrNull;
    final Result<TaskEntity, Failure> result = await ref
        .read(completeIssueUseCaseProvider)
        .call(issueId: issueId);

    TaskEntity? completedTask;
    switch (result) {
      case Success(:final data) when data != null:
        completedTask = data.copyWith(media: previousTask?.media ?? data.media);
        state = AsyncValue.data(completedTask);
      case Success():
        state = AsyncValue.error('Task not found', StackTrace.current);
      case Error(:final error):
        state = AsyncValue.error(error, StackTrace.current);
        throw Exception(error);
    }
    return completedTask;
  }
}
