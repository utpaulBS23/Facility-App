import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/base/base.dart';
import '../../domain/entities/checklist_entity.dart';
import '../../domain/entities/problem_category_entity.dart';
import '../../domain/entities/report_issue_entity.dart';
import '../../domain/entities/visit_entity.dart';
import '../../domain/repositories/visit_repository.dart';
import '../extension/checklist_mapper.dart';
import '../models/problem_category_model.dart';
import '../models/checklist_model.dart';
import '../models/visit_model.dart';
import '../services/network/rest_client.dart';

final class VisitRepositoryImpl extends VisitRepository {
  VisitRepositoryImpl(this._client);

  final RestClient _client;

  @override
  Future<Result<VisitListEntity, Failure>> getMyVisits({
    required int partnerId,
    required String date,
  }) => asyncGuard(() async {
    final response = await _client.getMyVisits(
      partnerId: partnerId,
      date: date,
    );
    return VisitListResponseModel.fromJson(response.data).toEntity();
  });

  @override
  Future<Result<VisitDetailEntity, Failure>> getVisitDetail({
    required int partnerId,
    required int visitId,
  }) => asyncGuard(() async {
    final response = await _client.getVisitDetail(
      partnerId: partnerId,
      visitId: visitId,
    );
    return VisitDetailResponseModel.fromJson(response.data).toEntity();
  });

  @override
  Future<Result<void, Failure>> checkInVisit({
    required int partnerId,
    required int visitId,
    required VisitCheckInRequestEntity request,
  }) => asyncGuard(() async {
    await _client.checkInVisit(
      partnerId: partnerId,
      visitId: visitId,
      request: {'lat': request.latitude, 'lng': request.longitude},
    );
  });

  @override
  Future<Result<ChecklistEntity, Failure>> getChecklist({
    required int partnerId,
    required int visitId,
  }) => asyncGuard(() async {
    final response = await _client.getChecklist(
      partnerId: partnerId,
      visitId: visitId,
    );
    return ChecklistModel.fromJson(response.data).toEntity();
  });

  @override
  Future<Result<void, Failure>> submitVisit({
    required int partnerId,
    required int visitId,
  }) => asyncGuard(() async {
    await _client.submitVisit(partnerId: partnerId, visitId: visitId);
  });

  @override
  Future<Result<ChecklistItemSaveResponseEntity, Failure>>
  saveChecklistItemResponse({
    required int partnerId,
    required int visitId,
    required int itemId,
    int? ratingValue,
    bool? booleanValue,
    String? photoPath,
  }) => asyncGuard(() async {
    final fields = <MapEntry<String, MultipartFile>>[];
    final formFields = <String, dynamic>{'_method': 'PUT'};
    if (ratingValue != null) formFields['rating_value'] = ratingValue;
    if (booleanValue != null) {
      formFields['boolean_value'] = booleanValue ? '1' : '0';
    }
    if (photoPath != null) {
      fields.add(
        MapEntry(
          'photo',
          await MultipartFile.fromFile(
            photoPath,
            filename: File(photoPath).uri.pathSegments.last,
          ),
        ),
      );
    }
    final formData = FormData.fromMap({
      ...formFields,
      ...Map.fromEntries(fields),
    });
    final response = await _client.saveChecklistItemResponse(
      partnerId: partnerId,
      visitId: visitId,
      itemId: itemId,
      formData: formData,
    );
    return ChecklistItemSaveResponseModel.fromJson(response.data).toEntity();
  });

  @override
  Future<Result<ReportIssueResponseEntity, Failure>> reportIssue({
    required int partnerId,
    required int visitId,
    required ReportIssueRequestEntity request,
  }) => asyncGuard(() async {
    final fields = <MapEntry<String, dynamic>>[
      MapEntry('problem_category_id', request.categoryId.toString()),
      MapEntry('title', request.title),
      MapEntry('priority', request.priority.name),
      if (request.description != null)
        MapEntry('description', request.description!),
      if (request.assignedTo != null)
        MapEntry('assigned_to', request.assignedTo.toString()),
      if (request.dueAt != null) MapEntry('due_at', request.dueAt!),
    ];
    final formData = FormData.fromMap({
      for (final e in fields) e.key: e.value,
      if (request.photoPath != null)
        'photo': await MultipartFile.fromFile(
          request.photoPath!,
          filename: request.photoPath!.split('/').last,
        ),
    });
    final response = await _client.reportIssue(
      partnerId: partnerId,
      visitId: visitId,
      request: formData,
    );
    final raw = response.data['data'] ?? response.data;
    final data = raw as Map<String, dynamic>;
    return ReportIssueResponseEntity(
      id: data['id'] as int,
      title: data['title'] as String? ?? '',
      priority: data['priority'] as String? ?? '',
      status: data['status'] as String? ?? '',
    );
  });

  @override
  Future<Result<List<ProblemCategoryEntity>, Failure>> getProblemCategories({
    required int partnerId,
  }) => asyncGuard(() async {
    final response = await _client.getProblemCategories(partnerId: partnerId);
    final list = ProblemCategoryListModel.fromJson(response.data);
    return (list.data ?? [])
        .where((m) => m.isActive != false)
        .map((m) => ProblemCategoryEntity(
              id: m.id,
              name: m.name ?? '',
              description: m.description ?? '',
            ))
        .toList();
  });
}
