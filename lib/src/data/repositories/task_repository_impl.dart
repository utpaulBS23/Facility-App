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
  Future<Result<List<TaskEntity>, Failure>> getIssues({
    required int partnerId,
    String? status,
    int? facilityId,
  }) => asyncGuard(() async {
    final response = await _client.getIssues(
      partnerId: partnerId,
      status: status,
      facilityId: facilityId,
    );
    return TaskListResponseModel.fromJson(response.data).toEntities();
  });

  @override
  Future<Result<TaskEntity, Failure>> getIssueDetail({
    required int partnerId,
    required int id,
  }) => asyncGuard(() async {
    final response = await _client.getIssueDetail(
      partnerId: partnerId,
      issueId: id,
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
}
