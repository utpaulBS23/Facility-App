/// Filter query parameters for facility expenses list
/// (`GET /partners/{partner}/facility-expenses`).
class FacilityExpenseFilter {
  const FacilityExpenseFilter({
    this.partnerId,
    this.facilityId,
    this.from,
    this.to,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final int? facilityId;

  /// Inclusive `expense_date` range, `YYYY-MM-DD`.
  final String? from;
  final String? to;
  final int? page;
  final int? pageSize;

  FacilityExpenseFilter copyWith({
    int? partnerId,
    int? facilityId,
    String? from,
    String? to,
    int? page,
    int? pageSize,
  }) {
    return FacilityExpenseFilter(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      from: from ?? this.from,
      to: to ?? this.to,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
