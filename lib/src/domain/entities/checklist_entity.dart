enum ChecklistAnswerType { star, yesNo, repairWork }

enum ChecklistProofPolicy { always, optional, none }

class ChecklistItemEntity {
  const ChecklistItemEntity({
    required this.id,
    required this.question,
    required this.answerType,
    required this.order,
    this.maxPoints = 5,
    this.proofPolicy = ChecklistProofPolicy.none,
    this.existingRating,
    this.existingBoolAnswer,
    this.existingPointsAwarded,
    this.existingMediaUrls = const [],
    this.hasProof = false,
  });

  final int id;
  final String question;
  final ChecklistAnswerType answerType;
  final int order;
  final int maxPoints;
  final ChecklistProofPolicy proofPolicy;
  final int? existingRating;
  final bool? existingBoolAnswer;
  final int? existingPointsAwarded;
  final List<String> existingMediaUrls;
  final bool hasProof;

  bool get isAnswered => switch (answerType) {
    ChecklistAnswerType.star => existingRating != null,
    ChecklistAnswerType.yesNo => existingBoolAnswer != null,
    ChecklistAnswerType.repairWork => true,
  };
}

class ChecklistEntity {
  const ChecklistEntity({
    required this.maxScore,
    required this.items,
    required this.issues,
  });

  final int maxScore;
  final List<ChecklistItemEntity> items;
  final List<ChecklistIssueEntity> issues;

  int get totalAnswerableCount =>
      items.where((i) => i.answerType != ChecklistAnswerType.repairWork).length;

  int get answeredCount => items
      .where((i) => i.answerType != ChecklistAnswerType.repairWork && i.isAnswered)
      .length;

  int get currentScore => items
      .where((i) => i.answerType == ChecklistAnswerType.star && i.isAnswered)
      .fold(0, (sum, i) => sum + (i.existingRating ?? 0));

  bool get isComplete => answeredCount == totalAnswerableCount;
}

class ChecklistIssueEntity {
  const ChecklistIssueEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.priority,
    this.status = '',
  });

  final int id;
  final String title;
  final String category;
  final String location;
  final String priority;
  final String status;
}

class ChecklistItemSaveResponseEntity {
  const ChecklistItemSaveResponseEntity({
    required this.id,
    required this.pointsAwarded,
    required this.hasProof,
    this.ratingValue,
    this.booleanValue,
  });

  final int id;
  final int pointsAwarded;
  final bool hasProof;
  final int? ratingValue;
  final bool? booleanValue;
}

class ChecklistAnswerRequestEntity {
  const ChecklistAnswerRequestEntity({
    required this.itemId,
    this.starRating,
    this.yesNoAnswer,
  });

  final int itemId;
  final int? starRating;
  final bool? yesNoAnswer;
}

class ChecklistSubmitRequestEntity {
  const ChecklistSubmitRequestEntity({
    required this.answers,
    this.proofImagePaths = const {},
  });

  final List<ChecklistAnswerRequestEntity> answers;
  // itemId → list of local file paths for proof images
  final Map<int, List<String>> proofImagePaths;
}
