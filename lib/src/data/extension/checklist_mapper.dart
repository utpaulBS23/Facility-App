import '../../domain/entities/checklist_entity.dart';
import '../models/checklist_model.dart';

/// The answer types the checklist supports, or null for any other type.
ChecklistAnswerType? _parseAnswerType(String? raw) => switch (raw) {
  'rating' => ChecklistAnswerType.star,
  'boolean' => ChecklistAnswerType.yesNo,
  'repair_work' => ChecklistAnswerType.repairWork,
  _ => null,
};

ChecklistProofPolicy _parseProofPolicy(String? raw) => switch (raw) {
  'photo_required' || 'required' => ChecklistProofPolicy.always,
  'photo_optional' => ChecklistProofPolicy.optional,
  _ => ChecklistProofPolicy.none,
};

extension ChecklistItemModelToEntity on ChecklistItemModel {
  /// False for an item type the page cannot answer (text, or one that does not
  /// exist yet): the item is left out, so it is not shown and cannot block the
  /// submit.
  bool get isSupported => _parseAnswerType(responseType) != null;

  ChecklistItemEntity toEntity() => ChecklistItemEntity(
    id: id,
    question: label ?? '',
    questionBn: labelBn ?? '',
    answerType: _parseAnswerType(responseType)!,
    order: sortOrder ?? 0,
    maxPoints: maxPoints ?? 5,
    proofPolicy: _parseProofPolicy(proofPolicy),
    isRequired: isRequired ?? false,
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
    media: media != null
        ? ChecklistItemMediaEntity(id: media!.id, url: media!.url)
        : null,
  );
}

extension ChecklistIssueModelToEntity on ChecklistIssueModel {
  ChecklistIssueEntity toEntity() => ChecklistIssueEntity(
    id: taskId,
    title: title ?? '',
    titleBn: titleBn ?? '',
    category: problemCategory ?? '',
    location: '',
    priority: priority ?? '',
    status: status ?? '',
    facilityName: facilityName,
    facilityNameBn: facilityNameBn ?? '',
    dueDateString: dueDate,
  );
}

extension ChecklistModelToEntity on ChecklistModel {
  ChecklistEntity toEntity() => ChecklistEntity(
    maxScore: meta?.maxScore ?? 0,
    items: [
      for (final i in data ?? const <ChecklistItemModel>[])
        if (i.isSupported) i.toEntity(),
    ],
    issues: (issues ?? []).map((i) => i.toEntity()).toList(),
  );
}

