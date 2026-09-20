import 'toilet_status.dart';

/// UI tab filter option for the toilet location list screen.
enum ToiletListFilter {
  all,
  active,
  inactive,
  maintenance;

  ToiletStatus? get status => switch (this) {
        ToiletListFilter.all => null,
        ToiletListFilter.active => ToiletStatus.active,
        ToiletListFilter.inactive => ToiletStatus.inactive,
        ToiletListFilter.maintenance => ToiletStatus.maintenance,
      };
}

/// Filter query parameters for the toilet list (`GET /facilities`).
class ToiletListQueryFilter {
  const ToiletListQueryFilter({
    this.partnerId,
    this.status,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final ToiletStatus? status;
  final int? page;
  final int? pageSize;

  ToiletListQueryFilter copyWith({
    int? partnerId,
    ToiletStatus? status,
    int? page,
    int? pageSize,
  }) {
    return ToiletListQueryFilter(
      partnerId: partnerId ?? this.partnerId,
      status: status ?? this.status,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
