class FacilityStockAveragingOverviewEntity {
  const FacilityStockAveragingOverviewEntity({
    required this.facilityId,
    required this.facilityName,
    required this.supervisorName,
    this.lastStockCountAt,
    required this.isSetUp,
  });

  final int facilityId;
  final String facilityName;
  final String supervisorName;
  final String? lastStockCountAt;
  final bool isSetUp;
}
