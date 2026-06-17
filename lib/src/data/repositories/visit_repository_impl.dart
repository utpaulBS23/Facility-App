import '../../core/base/base.dart';
import '../../domain/entities/checklist_entity.dart';
import '../../domain/entities/report_issue_entity.dart';
import '../../domain/entities/visit_entity.dart';
import '../../domain/repositories/visit_repository.dart';
import '../services/network/rest_client.dart';

final class VisitRepositoryImpl extends VisitRepository {
  VisitRepositoryImpl(this._client);

  // ignore: unused_field
  final RestClient _client;

  // WHY: API not ready — returning hardcoded dummy data until backend delivers endpoints.

  @override
  Future<Result<VisitListEntity, Failure>> getMyVisits({
    required int partnerId,
    required String date,
  }) async {
    return const Success(
      data: VisitListEntity(
        stats: VisitStatsSummaryEntity(
          todayCount: 4,
          weekCount: 18,
          completedCount: 3,
        ),
        visits: [
          VisitSummaryEntity(
            id: 1,
            facilityName: 'Dhaka Central Hospital',
            facilityAddress: '12 Motijheel C/A, Dhaka 1000',
            status: VisitStatus.scheduled,
            type: VisitType.routineInspection,
            date: '2026-06-18',
            startTime: '09:00',
            endTime: '11:00',
          ),
          VisitSummaryEntity(
            id: 2,
            facilityName: 'Gulshan Community Center',
            facilityAddress: '45 Gulshan Ave, Dhaka 1212',
            status: VisitStatus.completed,
            type: VisitType.followUp,
            date: '2026-06-18',
            startTime: '13:00',
            endTime: '14:30',
          ),
          VisitSummaryEntity(
            id: 3,
            facilityName: 'Mirpur Sports Complex',
            facilityAddress: '2 Mirpur Rd, Dhaka 1216',
            status: VisitStatus.pending,
            type: VisitType.routineInspection,
            date: '2026-06-18',
            startTime: '15:00',
            endTime: '16:30',
          ),
          VisitSummaryEntity(
            id: 4,
            facilityName: 'Uttara Administrative Office',
            facilityAddress: '8 Uttara Sector 7, Dhaka 1230',
            status: VisitStatus.scheduled,
            type: VisitType.followUp,
            date: '2026-06-18',
            startTime: '17:00',
            endTime: '18:00',
          ),
        ],
      ),
    );
  }

  @override
  Future<Result<VisitDetailEntity, Failure>> getVisitDetail({
    required int partnerId,
    required int visitId,
  }) async {
    return const Success(
      data: VisitDetailEntity(
        id: 1,
        facilityName: 'Dhaka Central Hospital',
        facilityAddress: '12 Motijheel C/A, Dhaka 1000',
        facilityLatitude: 23.7340,
        facilityLongitude: 90.4182,
        inRangeThresholdMeters: 100.0,
        status: VisitStatus.scheduled,
        type: VisitType.routineInspection,
        date: '2026-06-18',
        startTime: '09:00',
        endTime: '11:00',
        assignedBy: VisitAssignedByEntity(
          name: 'Rahim Uddin',
          role: 'Supervisor',
        ),
      ),
    );
  }

  @override
  Future<Result<void, Failure>> checkInVisit({
    required int partnerId,
    required int visitId,
    required VisitCheckInRequestEntity request,
  }) async {
    return const Success();
  }

  @override
  Future<Result<ChecklistEntity, Failure>> getChecklist({
    required int partnerId,
    required int visitId,
  }) async {
    return const Success(
      data: ChecklistEntity(
        maxScore: 25,
        items: [
          ChecklistItemEntity(
            id: 1,
            question: 'Is the facility entrance clean and accessible?',
            answerType: ChecklistAnswerType.yesNo,
            order: 1,
          ),
          ChecklistItemEntity(
            id: 2,
            question: 'Rate the overall cleanliness of common areas.',
            answerType: ChecklistAnswerType.star,
            order: 2,
          ),
          ChecklistItemEntity(
            id: 3,
            question: 'Are fire extinguishers in place and not expired?',
            answerType: ChecklistAnswerType.yesNo,
            order: 3,
          ),
          ChecklistItemEntity(
            id: 4,
            question: 'Rate the condition of electrical installations.',
            answerType: ChecklistAnswerType.star,
            order: 4,
          ),
          ChecklistItemEntity(
            id: 5,
            question: 'Is the restroom sanitation satisfactory?',
            answerType: ChecklistAnswerType.yesNo,
            order: 5,
          ),
        ],
        issues: [
          ChecklistIssueEntity(
            id: 101,
            title: 'Broken ceiling tile in corridor B',
            category: 'Structural',
            location: 'Corridor B',
            priority: 'High',
          ),
          ChecklistIssueEntity(
            id: 102,
            title: 'Leaking pipe near storage room',
            category: 'Plumbing',
            location: 'Storage Room 3',
            priority: 'Medium',
          ),
        ],
      ),
    );
  }

  @override
  Future<Result<void, Failure>> submitChecklist({
    required int partnerId,
    required int visitId,
    required ChecklistSubmitRequestEntity request,
  }) async {
    return const Success();
  }

  @override
  Future<Result<ReportIssueResponseEntity, Failure>> reportIssue({
    required int partnerId,
    required ReportIssueRequestEntity request,
  }) async {
    return const Success(
      data: ReportIssueResponseEntity(
        id: 999,
        message: 'Issue reported successfully.',
      ),
    );
  }
}
