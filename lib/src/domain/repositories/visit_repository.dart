import '../../core/base/base.dart';
import '../entities/checklist_entity.dart';
import '../entities/report_issue_entity.dart';
import '../entities/visit_entity.dart';

abstract base class VisitRepository extends Repository {
  Future<Result<VisitListEntity, Failure>> getMyVisits({
    required int partnerId,
    required String date,
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

  Future<Result<VisitCheckInCaptureEntity, Failure>> captureCheckIn({
    required int partnerId,
    required int visitId,
    required VisitCheckInRequestEntity request,
  });

  Future<Result<ChecklistEntity, Failure>> getChecklist({
    required int partnerId,
    required int visitId,
  });

  Future<Result<void, Failure>> submitChecklist({
    required int partnerId,
    required int visitId,
    required ChecklistSubmitRequestEntity request,
  });

  Future<Result<ReportIssueResponseEntity, Failure>> reportIssue({
    required int partnerId,
    required ReportIssueRequestEntity request,
  });
}
