class CreateFacilityExpenseRequestEntity {
  const CreateFacilityExpenseRequestEntity({
    this.partnerId,
    required this.facilityId,
    required this.category,
    required this.amount,
    required this.expenseDate,
    required this.paidBy,
    this.note,
  });

  // WHY nullable + attached via copyWith: this is the same
  // domain-only-partnerId pattern used by CreateTravelExpenseRequestEntity /
  // CreateSupplyRequestEntity — the caller never supplies it, the use case
  // fills it in from PartnerUseCase.getPartnerId().
  final int? partnerId;
  final int facilityId;
  // WHY String not an id: backend validation rejects a numeric category
  // ("The category must be a string") — it wants the master-data item's
  // `value` (its wire code), not its `id`.
  final String category;
  final double amount;
  final DateTime expenseDate;
  // WHY String not FacilityExpensePaidBy: paid_by now comes from the
  // master-data `paymentMethod` category, whose values are backend-driven
  // and don't necessarily match the fixed cash/accounts enum — send the
  // master-data item's raw `value` straight through. The enum stays for
  // interpreting `paid_by` on records already read back from the API.
  final String paidBy;
  final String? note;

  CreateFacilityExpenseRequestEntity copyWith({
    int? partnerId,
    int? facilityId,
    String? category,
    double? amount,
    DateTime? expenseDate,
    String? paidBy,
    String? note,
  }) {
    return CreateFacilityExpenseRequestEntity(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      expenseDate: expenseDate ?? this.expenseDate,
      paidBy: paidBy ?? this.paidBy,
      note: note ?? this.note,
    );
  }
}
