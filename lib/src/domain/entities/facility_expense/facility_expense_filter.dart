/// Filter query parameters for facility expenses list
/// (`GET /partners/{partner}/facility-expenses`).
class FacilityExpenseFilter {
  const FacilityExpenseFilter({
    this.partnerId,
    this.facilityId,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final int? facilityId;
  final int? page;
  final int? pageSize;

  FacilityExpenseFilter copyWith({
    int? partnerId,
    int? facilityId,
    int? page,
    int? pageSize,
  }) {
    return FacilityExpenseFilter(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
