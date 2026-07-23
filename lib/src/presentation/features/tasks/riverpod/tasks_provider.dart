import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/task_entity.dart';

part 'tasks_provider.g.dart';

@riverpod
class Tasks extends _$Tasks {
  @override
  AsyncValue<List<TaskEntity>> build() => const AsyncValue.loading();

  Future<void> fetch({required String bucket}) async {
    state = const AsyncValue.loading();

    final partnerId = ref.activePartnerId;
    if (partnerId == null) {
      state = AsyncValue.error(partnerUnavailableMessage, StackTrace.current);
      return;
    }

    final Result<List<TaskEntity>, String> result = await ref
        .read(getTasksUseCaseProvider)
        .call(partnerId: partnerId, bucket: bucket);

    state = result.when(
      success: (data) => data != null
          ? AsyncValue.data(data)
          : AsyncValue.error('No data', StackTrace.current),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<void> startIssue({required int issueId}) async {
    final partnerId = ref.activePartnerId;
    if (partnerId == null) {
      state = AsyncValue.error(partnerUnavailableMessage, StackTrace.current);
      return;
    }

    final previousTasks = state.valueOrNull ?? const <TaskEntity>[];
    final Result<TaskEntity, String> result = await ref
        .read(startIssueUseCaseProvider)
        .call(partnerId: partnerId, issueId: issueId);

    state = result.when(
      success: (data) {
        if (data == null) {
          return AsyncValue.data(previousTasks);
        }
        return AsyncValue.data(
          previousTasks
              .map((task) => task.id == data.id ? data : task)
              .toList(),
        );
      },
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<TaskMediaEntity?> uploadMedia({
    required int taskId,
    required String photoPath,
    required String alt,
  }) async {
    final partnerId = ref.activePartnerId;
    if (partnerId == null) {
      state = AsyncValue.error(partnerUnavailableMessage, StackTrace.current);
      return null;
    }

    final previousTasks = state.valueOrNull ?? const <TaskEntity>[];
    final Result<TaskMediaEntity, String> result = await ref
        .read(uploadTaskMediaUseCaseProvider)
        .call(
          partnerId: partnerId,
          taskId: taskId,
          photoPath: photoPath,
          alt: alt,
        );

    TaskMediaEntity? uploadedMedia;
    switch (result) {
      case Success(:final data) when data != null:
        uploadedMedia = data;
        state = AsyncValue.data(
          previousTasks.map((task) {
            if (task.id != taskId) return task;
            return task.copyWith(media: [...task.media, data]);
          }).toList(),
        );
      case Success():
        state = AsyncValue.data(previousTasks);
      case Error(:final error):
        state = AsyncValue.error(error, StackTrace.current);
        throw Exception(error);
    }
    return uploadedMedia;
  }

  Future<TaskEntity?> completeIssue({required int issueId}) async {
    if (!ref.hasPermission(AppPermission.taskComplete)) {
      state = AsyncValue.error(permissionDeniedMessage, StackTrace.current);
      return null;
    }

    final partnerId = ref.activePartnerId;
    if (partnerId == null) {
      state = AsyncValue.error(partnerUnavailableMessage, StackTrace.current);
      return null;
    }

    final previousTasks = state.valueOrNull ?? const <TaskEntity>[];
    final Result<TaskEntity, String> result = await ref
        .read(completeIssueUseCaseProvider)
        .call(partnerId: partnerId, issueId: issueId);

    TaskEntity? completedTask;
    switch (result) {
      case Success(:final data) when data != null:
        state = AsyncValue.data(
          previousTasks.map((task) {
            if (task.id != data.id) return task;
            completedTask = data.copyWith(media: task.media);
            return completedTask!;
          }).toList(),
        );
      case Success():
        state = AsyncValue.data(previousTasks);
      case Error(:final error):
        state = AsyncValue.error(error, StackTrace.current);
        throw Exception(error);
    }
    return completedTask;
  }

  void appendMedia({required int taskId, required TaskMediaEntity media}) {
    final previousTasks = state.valueOrNull;
    if (previousTasks == null) {
      return;
    }

    state = AsyncValue.data(
      previousTasks.map((task) {
        if (task.id != taskId) {
          return task;
        }
        return task.copyWith(media: [...task.media, media]);
      }).toList(),
    );
  }

  void replaceTask(TaskEntity task) {
    final previousTasks = state.valueOrNull;
    if (previousTasks == null) {
      return;
    }

    state = AsyncValue.data(
      previousTasks
          .map((currentTask) => currentTask.id == task.id ? task : currentTask)
          .toList(),
    );
  }
}
