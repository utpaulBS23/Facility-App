import '../../core/base/base.dart';
import '../entities/checklist_entity.dart';
import '../entities/problem_category_entity.dart';
import '../entities/report_issue_entity.dart';
import '../entities/visit_entity.dart';

abstract base class VisitRepository extends Repository {
  Future<Result<VisitListEntity, Failure>> getMyVisits({
    required int partnerId,
    String? date,
    String? status,
    int? facilityId,
    int? assignedTo,
  });

  Future<Result<VisitDetailEntity, Failure>> getVisitDetail({
    required int partnerId,
    required int visitId,
  });

  Future<Result<void, Failure>> checkInVisit({
    required int partnerId,
    required int visitId,
    required VisitCheckInRequestEntity request,
  });

  Future<Result<ChecklistEntity, Failure>> getChecklist({
    required int partnerId,
    required int visitId,
  });

  Future<Result<void, Failure>> submitVisit({
    required int partnerId,
    required int visitId,
  });

  Future<Result<ChecklistItemSaveResponseEntity, Failure>> saveChecklistItemResponse({
    required int partnerId,
    required int visitId,
    required int itemId,
    int? ratingValue,
    bool? booleanValue,
    String? photoPath,
  });

  Future<Result<ReportIssueResponseEntity, Failure>> reportIssue({
    required int partnerId,
    required int visitId,
    required ReportIssueRequestEntity request,
  });

  Future<Result<List<ProblemCategoryEntity>, Failure>> getProblemCategories({
    required int partnerId,
  });

  Stream<int> get onVisitSubmitted;
}
