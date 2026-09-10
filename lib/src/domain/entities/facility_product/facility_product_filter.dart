/// Filter for the facility-scoped product offering list
/// (`GET /partners/{partner}/facility-products`).
class FacilityProductFilter {
  const FacilityProductFilter({this.partnerId, required this.facilityId});

  final int? partnerId;
  final int facilityId;

  FacilityProductFilter copyWith({int? partnerId, int? facilityId}) {
    return FacilityProductFilter(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
    );
  }
}
