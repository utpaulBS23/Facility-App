import '../../core/base/base.dart';
import '../../domain/entities/checklist_entity.dart';
import '../../domain/entities/report_issue_entity.dart';
import '../../domain/entities/visit_entity.dart';
import '../../domain/repositories/visit_repository.dart';
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
          request: {
            'latitude': request.latitude,
            'longitude': request.longitude,
          },
        );
      });

  @override
  Future<Result<ChecklistEntity, Failure>> getChecklist({
    required int partnerId,
    required int visitId,
  }) => asyncGuard(() async => const ChecklistEntity(
        maxScore: 80,
        items: [
          ChecklistItemEntity(
            id: 1,
            order: 1,
            question: 'Clean the mirror',
            answerType: ChecklistAnswerType.star,
            maxPoints: 5,
            proofPolicy: ChecklistProofPolicy.always,
            existingRating: 4,
            hasProof: true,
          ),
          ChecklistItemEntity(id: 2, order: 2, question: 'Clean the basins', answerType: ChecklistAnswerType.star),
          ChecklistItemEntity(id: 3, order: 3, question: 'Clean the commode and urinal', answerType: ChecklistAnswerType.star),
          ChecklistItemEntity(id: 4, order: 4, question: 'Clean the rubbish bin', answerType: ChecklistAnswerType.star),
          ChecklistItemEntity(id: 5, order: 5, question: 'Clean and dry the floor', answerType: ChecklistAnswerType.star),
          ChecklistItemEntity(id: 6, order: 6, question: 'Odour', answerType: ChecklistAnswerType.yesNo),
          ChecklistItemEntity(id: 7, order: 7, question: 'Tap or something is broken', answerType: ChecklistAnswerType.yesNo),
          ChecklistItemEntity(id: 8, order: 8, question: 'Tissue is available', answerType: ChecklistAnswerType.yesNo),
          ChecklistItemEntity(id: 9, order: 9, question: 'Soap/handwash is available', answerType: ChecklistAnswerType.yesNo),
          ChecklistItemEntity(id: 10, order: 10, question: 'Cleaning supplies are properly stored in the storeroom', answerType: ChecklistAnswerType.star),
          ChecklistItemEntity(id: 11, order: 11, question: 'Toilet cleaning supplies', answerType: ChecklistAnswerType.star),
          ChecklistItemEntity(id: 12, order: 12, question: 'The caretaker is dressed appropriately', answerType: ChecklistAnswerType.yesNo),
          ChecklistItemEntity(id: 13, order: 13, question: 'The caretaker is dancing happily', answerType: ChecklistAnswerType.yesNo),
          ChecklistItemEntity(id: 14, order: 14, question: 'The patient is eating', answerType: ChecklistAnswerType.yesNo),
          ChecklistItemEntity(id: 15, order: 15, question: 'The caretaker is giving medicine', answerType: ChecklistAnswerType.yesNo),
          ChecklistItemEntity(id: 16, order: 16, question: 'Repair work', answerType: ChecklistAnswerType.repairWork),
        ],
        issues: [
          ChecklistIssueEntity(
            id: 101,
            title: 'Broken bulb',
            category: 'Electrical',
            location: 'Mirpur-10, Dhaka',
            status: 'reported',
            priority: 'high',
          ),
          ChecklistIssueEntity(
            id: 102,
            title: 'Clogged drain',
            category: 'Plumbing',
            location: 'Farmgate Overbridge',
            status: 'reported',
            priority: 'medium',
          ),
        ],
      ));

  @override
  Future<Result<void, Failure>> submitChecklist({
    required int partnerId,
    required int visitId,
    required ChecklistSubmitRequestEntity request,
  }) => asyncGuard(() async {});

  @override
  Future<Result<ReportIssueResponseEntity, Failure>> reportIssue({
    required int partnerId,
    required ReportIssueRequestEntity request,
  }) => asyncGuard(() async => const ReportIssueResponseEntity(
        id: 999,
        message: 'Issue reported successfully.',
      ));
}
