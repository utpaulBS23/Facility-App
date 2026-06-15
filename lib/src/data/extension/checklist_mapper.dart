import '../../domain/entities/checklist_entity.dart';
import '../models/checklist_model.dart';

ChecklistAnswerType _parseAnswerType(String? raw) => switch (raw) {
      'yes_no' => ChecklistAnswerType.yesNo,
      _ => ChecklistAnswerType.star,
    };

extension ChecklistItemModelToEntity on ChecklistItemModel {
  ChecklistItemEntity toEntity() => ChecklistItemEntity(
        id: id,
        question: question ?? '',
        answerType: _parseAnswerType(answerType),
        order: order ?? 0,
      );
}

extension ChecklistIssueModelToEntity on ChecklistIssueModel {
  ChecklistIssueEntity toEntity() => ChecklistIssueEntity(
        id: id,
        title: title ?? '',
        category: category ?? '',
        location: location ?? '',
        priority: priority ?? '',
      );
}

extension ChecklistModelToEntity on ChecklistModel {
  ChecklistEntity toEntity() => ChecklistEntity(
        maxScore: maxScore ?? 0,
        items: (items ?? []).map((i) => i.toEntity()).toList(),
        issues: (issues ?? []).map((i) => i.toEntity()).toList(),
      );
}

extension ChecklistSubmitRequestEntityToJson on ChecklistSubmitRequestEntity {
  Map<String, dynamic> toJson() => {
        'answers': answers.map((a) => a.toJson()).toList(),
        if (proofImagePath != null) 'proof_image_path': proofImagePath,
      };
}

extension ChecklistAnswerRequestEntityToJson on ChecklistAnswerRequestEntity {
  Map<String, dynamic> toJson() => {
        'item_id': itemId,
        if (starRating != null) 'star_rating': starRating,
        if (yesNoAnswer != null) 'yes_no_answer': yesNoAnswer,
      };
}
