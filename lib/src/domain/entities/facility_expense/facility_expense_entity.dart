import '../common/paginated_list_entity.dart';
import 'facility_expense_paid_by.dart';
import '../../../core/utils/localized_text.dart';

class FacilityExpenseSummaryEntity {
  const FacilityExpenseSummaryEntity({
    required this.totalExpenses,
    required this.cashPaid,
    required this.accountsPaid,
  });

  final double totalExpenses;
  final double cashPaid;
  final double accountsPaid;
}

class FacilityExpenseEntity {
  const FacilityExpenseEntity({
    required this.id,
    required this.facilityName,
    this.facilityNameBn = '',
    required this.categoryName,
    required this.amount,
    required this.expenseDate,
    required this.paidBy,
    required this.note,
    required this.recordedByName,
    this.recordedByNameBn = '',
    required this.createdAt,
  });

  final int id;
  final String facilityName;
  final String facilityNameBn;
  final String categoryName;
  final double amount;
  final DateTime expenseDate;
  final FacilityExpensePaidBy paidBy;
  final String? note;
  final String recordedByName;
  final String recordedByNameBn;
  final DateTime createdAt;

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);

  String localizedRecordedByName(String languageCode) =>
      localizedText(languageCode, recordedByName, recordedByNameBn);
}

/// WHY a combined wrapper: unlike supply's summary (a separate
/// `GET .../summary` endpoint, its own repository method + provider), this
/// API embeds `summary` directly in the same `/facility-expenses` list
/// response — splitting it into two calls would just fire the same request
/// twice.
class FacilityExpenseListResultEntity {
  const FacilityExpenseListResultEntity({
    required this.list,
    required this.summary,
  });

  const FacilityExpenseListResultEntity.empty()
    : list = const PaginatedListEntity.empty(),
      summary = const FacilityExpenseSummaryEntity(
        totalExpenses: 0,
        cashPaid: 0,
        accountsPaid: 0,
      );

  final PaginatedListEntity<FacilityExpenseEntity> list;
  final FacilityExpenseSummaryEntity summary;
}
