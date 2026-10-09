class CreateAdditionalIncomeRequestEntity {
  const CreateAdditionalIncomeRequestEntity({
    this.partnerId,
    required this.facilityId,
    required this.incomeType,
    this.description,
    required this.amount,
    this.evidencePhotoPath,
  });

  // WHY nullable + attached via copyWith: same domain-only-partnerId
  // pattern as CreateFacilityExpenseRequestEntity / CreateSupplyRequestEntity
  // — the caller never supplies it, the use case fills it in from
  // PartnerUseCase.getPartnerId().
  final int? partnerId;
  final int facilityId;
  // WHY String 'income_type' not int 'income_type_id': the doc documents
  // income_type_id as a numeric FK, but the backend's actual validation
  // rejects both the key and a numeric value — it wants 'income_type' as a
  // string (the master-data item's `value`). Same stale-doc pattern as
  // facility-expense's category/paid_by fields.
  final String incomeType;
  final String? description;
  final double amount;

  /// Local path of the evidence photo to upload; null when none was picked.
  final String? evidencePhotoPath;

  CreateAdditionalIncomeRequestEntity copyWith({
    int? partnerId,
    int? facilityId,
    String? incomeType,
    String? description,
    double? amount,
    String? evidencePhotoPath,
  }) {
    return CreateAdditionalIncomeRequestEntity(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      incomeType: incomeType ?? this.incomeType,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      evidencePhotoPath: evidencePhotoPath ?? this.evidencePhotoPath,
    );
  }
}
