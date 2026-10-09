import '../../../core/utils/localized_text.dart';
import '../common/paginated_list_entity.dart';

class CashCollectionItemEntity {
  const CashCollectionItemEntity({
    required this.id,
    required this.serviceName,
    required this.section,
    required this.gender,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
  });

  final int id;
  final String serviceName;
  final String? section;
  final String gender;
  final int quantity;
  final double unitPrice;
  final double amount;
}

class CashCollectionEntity {
  const CashCollectionEntity({
    required this.id,
    required this.facilityName,
    this.facilityNameBn = '',
    required this.collectionDate,
    required this.productSellingAmount,
    required this.rentingOthersAmount,
    required this.lineItemsTotal,
    required this.totalCashAmount,
    required this.items,
    required this.photoUrl,
    required this.note,
    required this.submittedByName,
    this.submittedByNameBn = '',
  });

  final int id;
  final String facilityName;
  final String facilityNameBn;
  final DateTime collectionDate;
  final double productSellingAmount;
  final double rentingOthersAmount;
  final double lineItemsTotal;
  final double totalCashAmount;
  final List<CashCollectionItemEntity> items;

  /// Signed, time-limited (24h) URL — never cache beyond the session.
  final String? photoUrl;
  final String? note;
  final String submittedByName;
  final String submittedByNameBn;

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);

  String localizedSubmittedByName(String languageCode) =>
      localizedText(languageCode, submittedByName, submittedByNameBn);
}

class CashCollectionSummaryEntity {
  const CashCollectionSummaryEntity({
    required this.entriesCount,
    required this.manualTotal,
  });

  final int entriesCount;
  final double manualTotal;
}

// WHY a combined wrapper: the list endpoint embeds `summary` in the same
// response, so one call covers both the list and the stats cards.
class CashCollectionListResultEntity {
  const CashCollectionListResultEntity({
    required this.list,
    required this.summary,
  });

  const CashCollectionListResultEntity.empty()
    : list = const PaginatedListEntity.empty(),
      summary = const CashCollectionSummaryEntity(
        entriesCount: 0,
        manualTotal: 0,
      );

  final PaginatedListEntity<CashCollectionEntity> list;
  final CashCollectionSummaryEntity summary;
}

/// One service x gender price row offered at a facility. Its [id] is the
/// `facility_service_id` a cash collection line refers to.
class FacilityServiceEntity {
  const FacilityServiceEntity({
    required this.id,
    required this.serviceName,
    this.serviceNameBn = '',
    required this.gender,
    required this.price,
  });

  final int id;
  final String serviceName;
  final String serviceNameBn;
  final String gender;
  final double price;

  String localizedServiceName(String languageCode) =>
      localizedText(languageCode, serviceName, serviceNameBn);
}
