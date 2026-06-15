enum ChecklistAnswerType { star, yesNo }

class ChecklistItemEntity {
  const ChecklistItemEntity({
    required this.id,
    required this.question,
    required this.answerType,
    required this.order,
    this.starRating,
    this.yesNoAnswer,
  });

  final int id;
  final String question;
  final ChecklistAnswerType answerType;
  final int order;
  final int? starRating;
  final bool? yesNoAnswer;

  bool get isAnswered => switch (answerType) {
        ChecklistAnswerType.star => starRating != null,
        ChecklistAnswerType.yesNo => yesNoAnswer != null,
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

  int get answeredCount => items.where((i) => i.isAnswered).length;

  int get currentScore => items
      .where((i) => i.answerType == ChecklistAnswerType.star && i.isAnswered)
      .fold(0, (sum, i) => sum + (i.starRating ?? 0));

  bool get isComplete => answeredCount == items.length;
}

class ChecklistIssueEntity {
  const ChecklistIssueEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.priority,
  });

  final int id;
  final String title;
  final String category;
  final String location;
  final String priority;
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
    this.proofImagePath,
  });

  final List<ChecklistAnswerRequestEntity> answers;
  final String? proofImagePath;
}
