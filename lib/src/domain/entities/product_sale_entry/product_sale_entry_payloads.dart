/// Payload for creating a product sale entry
/// (`POST /partners/{partner}/product-sale-entries`) — one facility + one
/// date + multiple product rows in a single request.
class CreateProductSaleEntryRequestEntity {
  const CreateProductSaleEntryRequestEntity({
    this.partnerId,
    required this.facilityId,
    required this.entryDate,
    required this.items,
  });

  // WHY nullable + attached via copyWith: same domain-only-partnerId pattern
  // as CreateAdditionalIncomeRequestEntity / CreateFacilityExpenseRequestEntity
  // — the caller never supplies it, the use case fills it in from
  // PartnerUseCase.getPartnerId().
  final int? partnerId;
  final int facilityId;
  final DateTime entryDate;
  final List<CreateProductSaleEntryItemEntity> items;

  CreateProductSaleEntryRequestEntity copyWith({
    int? partnerId,
    int? facilityId,
    DateTime? entryDate,
    List<CreateProductSaleEntryItemEntity>? items,
  }) {
    return CreateProductSaleEntryRequestEntity(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      entryDate: entryDate ?? this.entryDate,
      items: items ?? this.items,
    );
  }
}

/// Single product row in a product sale entry payload.
class CreateProductSaleEntryItemEntity {
  const CreateProductSaleEntryItemEntity({
    required this.productId,
    required this.unitsSold,
    required this.unitPrice,
  });

  final int productId;
  final int unitsSold;
  final double unitPrice;
}
