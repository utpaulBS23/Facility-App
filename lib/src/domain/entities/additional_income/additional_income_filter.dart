/// Filter query parameters for additional incomes list
/// (`GET /partners/{partner}/additional-incomes`).
class AdditionalIncomeFilter {
  const AdditionalIncomeFilter({
    this.partnerId,
    this.facilityId,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final int? facilityId;
  final int? page;
  final int? pageSize;

  AdditionalIncomeFilter copyWith({
    int? partnerId,
    int? facilityId,
    int? page,
    int? pageSize,
  }) {
    return AdditionalIncomeFilter(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
