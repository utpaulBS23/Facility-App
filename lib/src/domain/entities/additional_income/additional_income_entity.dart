import '../common/paginated_list_entity.dart';

class AdditionalIncomeSummaryEntity {
  const AdditionalIncomeSummaryEntity({
    required this.approvedTotal,
    required this.pendingCount,
    required this.totalSubmissions,
  });

  final double approvedTotal;
  final int pendingCount;
  final int totalSubmissions;
}

class AdditionalIncomeEntity {
  const AdditionalIncomeEntity({
    required this.id,
    required this.facilityName,
    required this.incomeTypeName,
    required this.amount,
    required this.description,
    required this.evidencePhotoUrl,
    required this.isSelfApproved,
    required this.submittedByName,
    required this.createdAt,
  });

  final int id;
  final String facilityName;
  final String incomeTypeName;
  final double amount;
  final String? description;
  final String? evidencePhotoUrl;
  final bool isSelfApproved;
  final String submittedByName;
  final DateTime createdAt;
}

// WHY a combined wrapper: mirrors FacilityExpenseListResultEntity — the
// `/additional-incomes` list endpoint embeds `summary` directly in the same
// response, so a single call covers both list and stats.
class AdditionalIncomeListResultEntity {
  const AdditionalIncomeListResultEntity({
    required this.list,
    required this.summary,
  });

  const AdditionalIncomeListResultEntity.empty()
    : list = const PaginatedListEntity.empty(),
      summary = const AdditionalIncomeSummaryEntity(
        approvedTotal: 0,
        pendingCount: 0,
        totalSubmissions: 0,
      );

  final PaginatedListEntity<AdditionalIncomeEntity> list;
  final AdditionalIncomeSummaryEntity summary;
}
