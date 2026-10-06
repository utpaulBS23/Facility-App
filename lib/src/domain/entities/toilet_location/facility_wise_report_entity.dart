/// One facility's closed-month figures.
class FacilityWiseRowEntity {
  const FacilityWiseRowEntity({
    required this.facilityId,
    required this.facilityName,
    required this.income,
    required this.accountsPaid,
    required this.operationDepartment,
    required this.expense,
    required this.toBkash,
    required this.toBank,
    required this.cashBalance,
    required this.profitLoss,
  });

  final int facilityId;
  final String facilityName;
  final num income;

  /// Expense paid through accounts.
  final num accountsPaid;

  /// Expense paid by the operation department.
  final num operationDepartment;
  final num expense;

  /// Cash converted to bKash / to bank.
  final num toBkash;
  final num toBank;
  final num cashBalance;

  /// Negative for a loss.
  final num profitLoss;

  num get converted => toBkash + toBank;
}

/// A month's facility-wise report. [facilities] is empty when no facility has
/// closed that month yet, which is a normal state and not an error.
class FacilityWiseReportEntity {
  const FacilityWiseReportEntity({required this.facilities});

  final List<FacilityWiseRowEntity> facilities;

  FacilityWiseRowEntity? get first =>
      facilities.isEmpty ? null : facilities.first;
}
