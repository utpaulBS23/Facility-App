import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/base/base.dart';
import '../../domain/entities/checklist_entity.dart';
import '../../domain/entities/report_issue_entity.dart';
import '../../domain/entities/visit_entity.dart';
import '../../domain/repositories/visit_repository.dart';
import '../extension/checklist_mapper.dart';
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
  Future<Result<VisitCheckInCaptureEntity, Failure>> captureCheckIn({
    required int partnerId,
    required int visitId,
    required VisitCheckInRequestEntity request,
  }) => asyncGuard(() async {
    final response = await _client.captureCheckIn(
      partnerId: partnerId,
      visitId: visitId,
      request: {'lat': request.latitude, 'lng': request.longitude},
    );

    return VisitCheckInCaptureResponseModel.fromJson(response.data).toEntity();
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
  Future<Result<ChecklistItemSaveResponseEntity, Failure>> saveChecklistItemResponse({
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
    if (booleanValue != null) formFields['boolean_value'] = booleanValue ? '1' : '0';
    if (photoPath != null) {
      fields.add(MapEntry(
        'photo',
        await MultipartFile.fromFile(photoPath, filename: File(photoPath).uri.pathSegments.last),
      ));
    }
    final formData = FormData.fromMap({...formFields, ...Map.fromEntries(fields)});
    final response = await _client.saveChecklistItemResponse(
      partnerId: partnerId,
      visitId: visitId,
      itemId: itemId,
      formData: formData,
    );
    final raw = response.data['data'];
    final data = raw as Map<String, dynamic>? ?? (throw Exception('Missing data in save-item-response'));
    return ChecklistItemSaveResponseEntity(
      id: data['id'] as int,
      ratingValue: data['rating_value'] as int?,
      booleanValue: data['boolean_value'] as bool?,
      pointsAwarded: (data['points_awarded'] as int?) ?? 0,
      hasProof: (data['has_proof'] as bool?) ?? false,
    );
  });

  @override
  Future<Result<void, Failure>> submitChecklist({
    required int partnerId,
    required int visitId,
    required ChecklistSubmitRequestEntity request,
  }) => asyncGuard(() async {
    await _client.submitChecklist(
      partnerId: partnerId,
      visitId: visitId,
      request: request.toJson(),
    );
  });

  @override
  Future<Result<ReportIssueResponseEntity, Failure>> reportIssue({
    required int partnerId,
    required ReportIssueRequestEntity request,
  }) => asyncGuard(() async {
    final body = <String, dynamic>{
      'visit_id': request.visitId,
      'department': request.department,
      'specific_problem': request.specificProblem,
      'location': request.location,
      'priority': request.priority.name,
      if (request.notes != null) 'notes': request.notes,
      if (request.assignedTo != null) 'assigned_to': request.assignedTo,
    };
    final response = await _client.reportIssue(
      partnerId: partnerId,
      request: body,
    );
    final raw = response.data['data'] ?? response.data;
    final data = raw as Map<String, dynamic>;
    return ReportIssueResponseEntity(
      id: data['id'] as int,
      message: data['message'] as String? ?? 'Issue reported successfully.',
    );
  });
}
