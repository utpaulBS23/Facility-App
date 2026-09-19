enum TrainingStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
  unknown;

  static TrainingStatus fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'scheduled' => TrainingStatus.scheduled,
      'in_progress' => TrainingStatus.inProgress,
      'completed' => TrainingStatus.completed,
      'cancelled' => TrainingStatus.cancelled,
      _ => TrainingStatus.unknown,
    };
  }

  String toWireString() {
    return switch (this) {
      TrainingStatus.scheduled => 'scheduled',
      TrainingStatus.inProgress => 'in_progress',
      TrainingStatus.completed => 'completed',
      TrainingStatus.cancelled => 'cancelled',
      TrainingStatus.unknown => 'unknown',
    };
  }
}
