import '../common/paginated_list_entity.dart';
import 'facility_expense_paid_by.dart';

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
    required this.categoryName,
    required this.amount,
    required this.expenseDate,
    required this.paidBy,
    required this.note,
    required this.recordedByName,
    required this.createdAt,
  });

  final int id;
  final String facilityName;
  final String categoryName;
  final double amount;
  final DateTime expenseDate;
  final FacilityExpensePaidBy paidBy;
  final String? note;
  final String recordedByName;
  final DateTime createdAt;
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
