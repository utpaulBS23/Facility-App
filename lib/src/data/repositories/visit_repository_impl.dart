import '../../core/base/base.dart';
import '../../domain/entities/checklist_entity.dart';
import '../../domain/entities/report_issue_entity.dart';
import '../../domain/entities/visit_entity.dart';
import '../../domain/repositories/visit_repository.dart';
import '../extension/checklist_mapper.dart';
import '../extension/report_issue_mapper.dart';
import '../extension/visit_mapper.dart';
import '../models/checklist_model.dart';
import '../models/report_issue_model.dart';
import '../models/visit_model.dart';
import '../services/network/rest_client.dart';

final class VisitRepositoryImpl extends VisitRepository {
  VisitRepositoryImpl(this._client);

  final RestClient _client;

  @override
  Future<Result<VisitListEntity, Failure>> getMyVisits({
    required int partnerId,
    required String date,
  }) {
    return asyncGuard(() async {
      final response = await _client.getMyVisits(
        partnerId: partnerId,
        date: date,
      );
      final body = response.data as Map<String, dynamic>;
      final statsRaw = body['stats'] as Map<String, dynamic>? ?? {};
      final visitsRaw = body['visits'] as List<dynamic>? ?? [];
      return VisitListEntity(
        stats: VisitStatsSummaryModel.fromJson(statsRaw).toEntity(),
        visits: visitsRaw
            .cast<Map<String, dynamic>>()
            .map((v) => VisitSummaryModel.fromJson(v).toEntity())
            .toList(),
      );
    });
  }

  @override
  Future<Result<VisitDetailEntity, Failure>> getVisitDetail({
    required int partnerId,
    required int visitId,
  }) {
    return asyncGuard(() async {
      final response = await _client.getVisitDetail(
        partnerId: partnerId,
        visitId: visitId,
      );
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>? ?? body;
      return VisitDetailModel.fromJson(data).toEntity();
    });
  }

  @override
  Future<Result<void, Failure>> checkInVisit({
    required int partnerId,
    required int visitId,
    required VisitCheckInRequestEntity request,
  }) {
    return asyncGuard(() async {
      await _client.checkInVisit(
        partnerId: partnerId,
        visitId: visitId,
        request: request.toJson(),
      );
    });
  }

  @override
  Future<Result<ChecklistEntity, Failure>> getChecklist({
    required int partnerId,
    required int visitId,
  }) {
    return asyncGuard(() async {
      final response = await _client.getChecklist(
        partnerId: partnerId,
        visitId: visitId,
      );
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>? ?? body;
      return ChecklistModel.fromJson(data).toEntity();
    });
  }

  @override
  Future<Result<void, Failure>> submitChecklist({
    required int partnerId,
    required int visitId,
    required ChecklistSubmitRequestEntity request,
  }) {
    return asyncGuard(() async {
      await _client.submitChecklist(
        partnerId: partnerId,
        visitId: visitId,
        request: request.toJson(),
      );
    });
  }

  @override
  Future<Result<ReportIssueResponseEntity, Failure>> reportIssue({
    required int partnerId,
    required ReportIssueRequestEntity request,
  }) {
    return asyncGuard(() async {
      final response = await _client.reportIssue(
        partnerId: partnerId,
        request: request.toJson(),
      );
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>? ?? body;
      return ReportIssueResponseModel.fromJson(data).toEntity();
    });
  }
}
