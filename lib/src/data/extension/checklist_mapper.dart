import '../../domain/entities/checklist_entity.dart';
import '../models/checklist_model.dart';

ChecklistAnswerType _parseAnswerType(String? raw) => switch (raw) {
  'boolean' => ChecklistAnswerType.yesNo,
  'repair_work' => ChecklistAnswerType.repairWork,
  _ => ChecklistAnswerType.star,
};

ChecklistProofPolicy _parseProofPolicy(String? raw) => switch (raw) {
  'photo_required' => ChecklistProofPolicy.always,
  'photo_optional' => ChecklistProofPolicy.optional,
  _ => ChecklistProofPolicy.none,
};

extension ChecklistItemModelToEntity on ChecklistItemModel {
  ChecklistItemEntity toEntity() => ChecklistItemEntity(
    id: id,
    question: label ?? '',
    answerType: _parseAnswerType(responseType),
    order: sortOrder ?? 0,
    maxPoints: maxPoints ?? 5,
    proofPolicy: _parseProofPolicy(proofPolicy),
    existingRating: response?.ratingValue,
    existingBoolAnswer: response?.booleanValue,
    existingPointsAwarded: response?.pointsAwarded,
    existingMediaUrls:
        response?.media?.map((m) => m.url).whereType<String>().toList() ??
        const [],
    hasProof: response?.hasProof ?? false,
  );
}

extension ChecklistItemSaveResponseModelToEntity
    on ChecklistItemSaveResponseModel {
  ChecklistItemSaveResponseEntity toEntity() => ChecklistItemSaveResponseEntity(
    id: data.id,
    ratingValue: data.ratingValue,
    booleanValue: data.booleanValue,
    pointsAwarded: data.pointsAwarded ?? 0,
    hasProof: data.hasProof ?? false,
  );
}

extension ChecklistIssueModelToEntity on ChecklistIssueModel {
  ChecklistIssueEntity toEntity() => ChecklistIssueEntity(
    id: taskId,
    title: title ?? '',
    category: assignedToName ?? '',
    location: facilityName ?? '',
    priority: priority ?? '',
    status: status ?? '',
  );
}

extension ChecklistModelToEntity on ChecklistModel {
  ChecklistEntity toEntity() => ChecklistEntity(
    maxScore: meta?.maxScore ?? 0,
    items: (data ?? []).map((i) => i.toEntity()).toList(),
    issues: (issues ?? []).map((i) => i.toEntity()).toList(),
  );
}

