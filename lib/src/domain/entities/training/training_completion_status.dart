enum TrainingCompletionStatus {
  enrolled,
  completed,
  absent,
  excused,
  unknown;

  static TrainingCompletionStatus fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'enrolled' => TrainingCompletionStatus.enrolled,
      'completed' => TrainingCompletionStatus.completed,
      'absent' => TrainingCompletionStatus.absent,
      'excused' => TrainingCompletionStatus.excused,
      _ => TrainingCompletionStatus.unknown,
    };
  }

  String toWireString() {
    return switch (this) {
      TrainingCompletionStatus.enrolled => 'enrolled',
      TrainingCompletionStatus.completed => 'completed',
      TrainingCompletionStatus.absent => 'absent',
      TrainingCompletionStatus.excused => 'excused',
      TrainingCompletionStatus.unknown => 'unknown',
    };
  }
}
