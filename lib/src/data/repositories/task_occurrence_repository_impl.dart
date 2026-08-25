import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/base/base.dart';
import '../../domain/entities/task_occurrence_entity.dart';
import '../../domain/repositories/task_occurrence_repository.dart';
import '../extension/task_occurrence_mapper.dart';
import '../models/task_occurrence_model.dart';
import '../services/network/rest_client.dart';

final class TaskOccurrenceRepositoryImpl extends TaskOccurrenceRepository {
  TaskOccurrenceRepositoryImpl(this._client);

  final RestClient _client;

  @override
  Future<Result<TaskOccurrenceListEntity, Failure>> getTaskOccurrences({
    required int partnerId,
    required int facilityId,
    String? date,
  }) => asyncGuard(() async {
    final response = await _client.getTaskOccurrences(
      partnerId: partnerId,
      facilityId: facilityId,
      date: date,
    );
    return TaskOccurrenceListResponseModel.fromJson(response.data).toEntity();
  });

  @override
  Future<Result<TaskOccurrenceEntity, Failure>> reassignTaskOccurrence({
    required int partnerId,
    required int taskOccurrenceId,
    required int assignedTo,
  }) => asyncGuard(() async {
    final response = await _client.reassignTaskOccurrence(
      partnerId: partnerId,
      taskOccurrenceId: taskOccurrenceId,
      request: {'assigned_to': assignedTo},
    );
    final entity = TaskOccurrenceDetailResponseModel.fromJson(
      response.data,
    ).toEntity();
    if (entity == null) throw Exception('Empty reassign response');
    return entity;
  });

  @override
  Future<Result<ChecklistItemAnswerEntity, Failure>>
  answerTaskOccurrenceChecklistItem({
    required int partnerId,
    required int taskOccurrenceId,
    required int itemId,
    int? ratingValue,
    bool? booleanValue,
    String? textValue,
    String? photoPath,
    String? alt,
  }) => asyncGuard(() async {
    final formData = FormData.fromMap({
      '_method': 'PUT',
      'rating_value': ?ratingValue,
      if (booleanValue != null) 'boolean_value': booleanValue ? '1' : '0',
      'text_value': ?textValue,
      'alt': ?alt,
      if (photoPath != null)
        'photo': await MultipartFile.fromFile(
          photoPath,
          filename: File(photoPath).uri.pathSegments.last,
        ),
    });
    final response = await _client.answerTaskOccurrenceChecklistItem(
      partnerId: partnerId,
      taskOccurrenceId: taskOccurrenceId,
      itemId: itemId,
      formData: formData,
    );
    final entity = TaskOccurrenceChecklistItemSaveResponseModel.fromJson(
      response.data,
    ).toEntity();
    if (entity == null) throw Exception('Empty checklist answer response');
    return entity;
  });

  @override
  Future<Result<TaskOccurrenceEntity, Failure>> submitTaskOccurrence({
    required int partnerId,
    required int taskOccurrenceId,
  }) => asyncGuard(() async {
    final response = await _client.submitTaskOccurrence(
      partnerId: partnerId,
      taskOccurrenceId: taskOccurrenceId,
    );
    final entity = TaskOccurrenceDetailResponseModel.fromJson(
      response.data,
    ).toEntity();
    if (entity == null) throw Exception('Empty submit response');
    return entity;
  });
}
