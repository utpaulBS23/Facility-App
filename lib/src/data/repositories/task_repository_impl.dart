import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/base/base.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';
import '../services/network/rest_client.dart';

final class TaskRepositoryImpl extends TaskRepository {
  TaskRepositoryImpl(this._client);

  final RestClient _client;

  @override
  Future<Result<List<TaskEntity>, Failure>> getTasks({
    required int partnerId,
    required String bucket,
    required String taskType,
  }) => asyncGuard(() async {
    final response = await _client.getTasks(
      partnerId: partnerId,
      bucket: bucket,
      taskType: taskType,
    );
    final status = _bucketToStatus(bucket);
    return TaskListResponseModel.fromJson(response.data).toEntities(status);
  });

  @override
  Future<Result<TaskEntity, Failure>> getTaskDetail({
    required int partnerId,
    required int id,
  }) => asyncGuard(() async {
    final response = await _client.getTaskDetail(
      partnerId: partnerId,
      taskId: id,
    );
    return TaskDetailResponseModel.fromJson(response.data).toEntity();
  });

  @override
  Future<Result<TaskEntity, Failure>> startIssue({
    required int partnerId,
    required int issueId,
  }) => asyncGuard(() async {
    final response = await _client.startIssue(
      partnerId: partnerId,
      issueId: issueId,
    );
    return TaskDetailResponseModel.fromJson(response.data).toEntity();
  });

  @override
  Future<Result<TaskEntity, Failure>> completeIssue({
    required int partnerId,
    required int issueId,
  }) => asyncGuard(() async {
    final response = await _client.completeIssue(
      partnerId: partnerId,
      issueId: issueId,
    );
    return TaskDetailResponseModel.fromJson(response.data).toEntity();
  });

  @override
  Future<Result<TaskMediaEntity, Failure>> uploadTaskMedia({
    required int partnerId,
    required int taskId,
    required String photoPath,
    required String alt,
  }) => asyncGuard(() async {
    final photo = await MultipartFile.fromFile(
      photoPath,
      filename: File(photoPath).uri.pathSegments.last,
    );
    final formData = FormData.fromMap({'photo': photo, 'alt': alt});
    final response = await _client.uploadTaskMedia(
      partnerId: partnerId,
      taskId: taskId,
      formData: formData,
    );
    return TaskMediaResponseModel.fromJson(response.data).toEntity();
  });

  static TaskStatus _bucketToStatus(String bucket) => switch (bucket) {
    'completed' => TaskStatus.completed,
    'pending' => TaskStatus.pending,
    _ => TaskStatus.today,
  };
}
