class CashCollectionLineEntity {
  const CashCollectionLineEntity({
    required this.facilityServiceId,
    required this.gender,
    required this.quantity,
  });

  final int facilityServiceId;
  final String gender;
  final int quantity;
}

class CreateCashCollectionRequestEntity {
  const CreateCashCollectionRequestEntity({
    this.partnerId,
    required this.facilityId,
    required this.collectionDate,
    required this.lines,
    required this.photoPath,
    this.productSellingAmount = 0,
    this.rentingOthersAmount = 0,
    this.note,
  });

  // WHY nullable + attached via copyWith: same domain-only-partnerId pattern
  // as the other create requests — the use case fills it in.
  final int? partnerId;
  final int facilityId;
  final DateTime collectionDate;
  final List<CashCollectionLineEntity> lines;

  /// Local path of the physical-count evidence photo (required by the API).
  final String photoPath;
  final double productSellingAmount;
  final double rentingOthersAmount;
  final String? note;

  CreateCashCollectionRequestEntity copyWith({int? partnerId}) {
    return CreateCashCollectionRequestEntity(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId,
      collectionDate: collectionDate,
      lines: lines,
      photoPath: photoPath,
      productSellingAmount: productSellingAmount,
      rentingOthersAmount: rentingOthersAmount,
      note: note,
    );
  }
}
