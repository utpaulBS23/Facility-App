import '../entities/checklist_entity.dart';
import '../entities/problem_category_entity.dart';
import '../entities/report_issue_entity.dart';
import '../entities/visit_entity.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/visit_repository.dart';
import '../../core/base/failure.dart';
import '../../core/base/result.dart';

final class GetMyVisitsUseCase {
  GetMyVisitsUseCase(this._repository, this._authRepository);

  final VisitRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<VisitListEntity, Failure>> call({required String date}) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.getMyVisits(
      partnerId: partnerId,
      date: date,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('load visits')),
    };
  }
}

final class GetVisitDetailUseCase {
  GetVisitDetailUseCase(this._repository, this._authRepository);

  final VisitRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<VisitDetailEntity, Failure>> call({
    required int visitId,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.getVisitDetail(
      partnerId: partnerId,
      visitId: visitId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('load visit details')),
    };
  }
}

final class CheckInVisitUseCase {
  CheckInVisitUseCase(this._repository, this._authRepository);

  final VisitRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<void, Failure>> call({
    required int visitId,
    required VisitCheckInRequestEntity request,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.checkInVisit(
      partnerId: partnerId,
      visitId: visitId,
      request: request,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('check in')),
    };
  }
}

final class GetChecklistUseCase {
  GetChecklistUseCase(this._repository, this._authRepository);

  final VisitRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<ChecklistEntity, Failure>> call({required int visitId}) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.getChecklist(
      partnerId: partnerId,
      visitId: visitId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('load checklist')),
    };
  }
}

final class SubmitVisitUseCase {
  SubmitVisitUseCase(this._repository, this._authRepository);

  final VisitRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<void, Failure>> call({required int visitId}) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.submitVisit(
      partnerId: partnerId,
      visitId: visitId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('submit visit')),
    };
  }
}

final class SaveChecklistItemResponseUseCase {
  SaveChecklistItemResponseUseCase(this._repository, this._authRepository);

  final VisitRepository _repository;
  final AuthenticationRepository _authRepository;

  Future<Result<ChecklistItemSaveResponseEntity, Failure>> call({
    required int visitId,
    required int itemId,
    int? ratingValue,
    bool? booleanValue,
    String? photoPath,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) return const Error(Failure.partnerUnavailable);

    final result = await _repository.saveChecklistItemResponse(
      partnerId: partnerId,
      visitId: visitId,
      itemId: itemId,
      ratingValue: ratingValue,
      booleanValue: booleanValue,
      photoPath: photoPath,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('save answer')),
    };
  }
}

final class ReportIssueUseCase {
  ReportIssueUseCase(this._repository);

  final VisitRepository _repository;

  Future<Result<ReportIssueResponseEntity, Failure>> call({
    required int partnerId,
    required int visitId,
    required ReportIssueRequestEntity request,
  }) async {
    final result = await _repository.reportIssue(
      partnerId: partnerId,
      visitId: visitId,
      request: request,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('submit issue report')),
    };
  }
}

final class WatchVisitSubmittedUseCase {
  const WatchVisitSubmittedUseCase(this._repository);

  final VisitRepository _repository;

  Stream<int> call() => _repository.onVisitSubmitted;
}

final class GetProblemCategoriesUseCase {
  const GetProblemCategoriesUseCase(this._repository);

  final VisitRepository _repository;

  Future<Result<List<ProblemCategoryEntity>, String>> call({
    required int partnerId,
  }) async {
    final result = await _repository.getProblemCategories(partnerId: partnerId);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to load problem categories'),
    };
  }
}
