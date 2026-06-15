import '../entities/checklist_entity.dart';
import '../entities/report_issue_entity.dart';
import '../entities/visit_entity.dart';
import '../repositories/visit_repository.dart';
import '../../core/base/result.dart';

final class GetMyVisitsUseCase {
  GetMyVisitsUseCase(this._repository);

  final VisitRepository _repository;

  Future<Result<VisitListEntity, String>> call({
    required int partnerId,
    required String date,
  }) async {
    final result = await _repository.getMyVisits(
      partnerId: partnerId,
      date: date,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to load visits'),
    };
  }
}

final class GetVisitDetailUseCase {
  GetVisitDetailUseCase(this._repository);

  final VisitRepository _repository;

  Future<Result<VisitDetailEntity, String>> call({
    required int partnerId,
    required int visitId,
  }) async {
    final result = await _repository.getVisitDetail(
      partnerId: partnerId,
      visitId: visitId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to load visit details'),
    };
  }
}

final class CheckInVisitUseCase {
  CheckInVisitUseCase(this._repository);

  final VisitRepository _repository;

  Future<Result<void, String>> call({
    required int partnerId,
    required int visitId,
    required VisitCheckInRequestEntity request,
  }) async {
    final result = await _repository.checkInVisit(
      partnerId: partnerId,
      visitId: visitId,
      request: request,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to check in'),
    };
  }
}

final class GetChecklistUseCase {
  GetChecklistUseCase(this._repository);

  final VisitRepository _repository;

  Future<Result<ChecklistEntity, String>> call({
    required int partnerId,
    required int visitId,
  }) async {
    final result = await _repository.getChecklist(
      partnerId: partnerId,
      visitId: visitId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to load checklist'),
    };
  }
}

final class SubmitChecklistUseCase {
  SubmitChecklistUseCase(this._repository);

  final VisitRepository _repository;

  Future<Result<void, String>> call({
    required int partnerId,
    required int visitId,
    required ChecklistSubmitRequestEntity request,
  }) async {
    final result = await _repository.submitChecklist(
      partnerId: partnerId,
      visitId: visitId,
      request: request,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to submit checklist'),
    };
  }
}

final class ReportIssueUseCase {
  ReportIssueUseCase(this._repository);

  final VisitRepository _repository;

  Future<Result<ReportIssueResponseEntity, String>> call({
    required int partnerId,
    required ReportIssueRequestEntity request,
  }) async {
    final result = await _repository.reportIssue(
      partnerId: partnerId,
      request: request,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to submit issue report'),
    };
  }
}
