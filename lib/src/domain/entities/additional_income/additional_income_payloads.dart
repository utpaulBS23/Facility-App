class CreateAdditionalIncomeRequestEntity {
  const CreateAdditionalIncomeRequestEntity({
    this.partnerId,
    required this.facilityId,
    this.incomeTypeId,
    this.description,
    required this.amount,
    this.evidencePhotoUrl,
  });

  // WHY nullable + attached via copyWith: same domain-only-partnerId
  // pattern as CreateFacilityExpenseRequestEntity / CreateSupplyRequestEntity
  // — the caller never supplies it, the use case fills it in from
  // PartnerUseCase.getPartnerId().
  final int? partnerId;
  final int facilityId;
  // WHY nullable: the doc's `additional_incomes` store payload requires
  // `income_type_id` as an integer FK into the real `income_types` table,
  // but no income-type master data exists yet (placeholder category key
  // `incomeType`, pending the real key — see EXTRA_COLLECTION_GAPS.md).
  // Temporarily optional so the form isn't blocked; omitted from the wire
  // body when null. Make required again once real income-type data lands.
  final int? incomeTypeId;
  final String? description;
  final double amount;
  final String? evidencePhotoUrl;

  CreateAdditionalIncomeRequestEntity copyWith({
    int? partnerId,
    int? facilityId,
    int? incomeTypeId,
    String? description,
    double? amount,
    String? evidencePhotoUrl,
  }) {
    return CreateAdditionalIncomeRequestEntity(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      incomeTypeId: incomeTypeId ?? this.incomeTypeId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      evidencePhotoUrl: evidencePhotoUrl ?? this.evidencePhotoUrl,
    );
  }
}
