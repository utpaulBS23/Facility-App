import 'training_status.dart';

/// Filter query parameters for training sessions list (`GET /training-sessions`).
class TrainingSessionQueryFilter {
  const TrainingSessionQueryFilter({
    this.partnerId,
    this.facilityId,
    this.status,
    this.search,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final int? facilityId;
  final TrainingStatus? status;
  final String? search;
  final int? page;
  final int? pageSize;

  TrainingSessionQueryFilter copyWith({
    int? partnerId,
    int? facilityId,
    TrainingStatus? status,
    String? search,
    int? page,
    int? pageSize,
  }) {
    return TrainingSessionQueryFilter(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      status: status ?? this.status,
      search: search ?? this.search,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// UI Tab filter option for the training sessions screen.
enum TrainingFilter {
  all,
  scheduled,
  inProgress,
  completed;

  TrainingStatus? toRequestStatus() {
    return switch (this) {
      TrainingFilter.all => null,
      TrainingFilter.scheduled => TrainingStatus.scheduled,
      TrainingFilter.inProgress => TrainingStatus.inProgress,
      TrainingFilter.completed => TrainingStatus.completed,
    };
  }
}
