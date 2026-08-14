enum FacilityStockStatus {
  ok,
  low,
  out,
  unknown;

  static FacilityStockStatus fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'ok' => FacilityStockStatus.ok,
      'low' => FacilityStockStatus.low,
      'out' => FacilityStockStatus.out,
      _ => FacilityStockStatus.unknown,
    };
  }

  String toWireString() {
    return switch (this) {
      FacilityStockStatus.ok => 'ok',
      FacilityStockStatus.low => 'low',
      FacilityStockStatus.out => 'out',
      FacilityStockStatus.unknown => 'unknown',
    };
  }
}

class FacilityStockBalanceEntity {
  const FacilityStockBalanceEntity({
    required this.facilityId,
    required this.facilityName,
    required this.stockItemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.currentQty,
    this.thresholdQty,
    required this.status,
    this.lastCountedAt,
    this.thresholdUpdatedBy,
    this.thresholdUpdatedAt,
  });

  final int facilityId;
  final String facilityName;
  final int stockItemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double currentQty;
  final double? thresholdQty;
  final FacilityStockStatus status;
  final String? lastCountedAt;
  final String? thresholdUpdatedBy;
  final String? thresholdUpdatedAt;
}

class FacilityStockBalanceSummaryEntity {
  const FacilityStockBalanceSummaryEntity({
    required this.outCount,
    required this.lowCount,
    required this.okCount,
  });

  final int outCount;
  final int lowCount;
  final int okCount;
}

class FacilityStockBalancePageEntity {
  const FacilityStockBalancePageEntity({
    required this.items,
    this.summary,
  });

  final List<FacilityStockBalanceEntity> items;
  final FacilityStockBalanceSummaryEntity? summary;
}
