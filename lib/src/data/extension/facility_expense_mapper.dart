import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/facility_expense/facility_expense_entity.dart';
import '../models/facility_expense/facility_expense_model.dart';

extension FacilityExpenseModelMapper on FacilityExpenseModel {
  FacilityExpenseEntity toEntity() {
    return FacilityExpenseEntity(
      id: id,
      facilityName: facility?.name ?? '',
      categoryName: category ?? '',
      amount: amount ?? 0,
      expenseDate: DateTime.tryParse(expenseDate ?? '') ?? DateTime.now(),
      paidBy: FacilityExpensePaidBy.fromWireString(paidBy),
      note: note,
      recordedByName: recordedBy?.name ?? '',
      createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
    );
  }
}

extension FacilityExpenseSummaryModelMapper on FacilityExpenseSummaryModel {
  FacilityExpenseSummaryEntity toEntity() {
    return FacilityExpenseSummaryEntity(
      totalExpenses: totalExpenses ?? 0,
      cashPaid: cashPaid ?? 0,
      accountsPaid: accountsPaid ?? 0,
    );
  }
}

extension FacilityExpenseListResponseModelToEntity
    on FacilityExpenseListResponseModel {
  FacilityExpenseListResultEntity toEntity() {
    final items = data.map((model) => model.toEntity()).toList();
    final curPage = meta?.currentPage ?? 1;
    final size = meta?.perPage ?? 20;
    final total = meta?.total ?? items.length;
    final hasMore = meta?.lastPage != null
        ? curPage < meta!.lastPage!
        : (curPage * size) < total;

    return FacilityExpenseListResultEntity(
      list: PaginatedListEntity<FacilityExpenseEntity>(
        items: items,
        currentPage: curPage,
        pageSize: size,
        totalRecords: total,
        hasMore: hasMore,
      ),
      summary: (summary ?? const FacilityExpenseSummaryModel()).toEntity(),
    );
  }
}

extension CreateFacilityExpenseRequestEntityMapper
    on CreateFacilityExpenseRequestEntity {
  Map<String, dynamic> toBody() => {
    'facility_id': facilityId,
    // WHY 'category' not 'category_id', and a string not an id: the doc
    // documents category_id as numeric, but the backend's actual validation
    // rejects both the key and a numeric value — it wants 'category' as a
    // string (the master-data item's `value`). Same stale-doc pattern as
    // the dropdown endpoint. 'paid_by' likewise wants the master-data
    // item's raw value, not the fixed cash/accounts wire string.
    'category': category,
    'amount': amount,
    'expense_date': expenseDate.toIso8601String().split('T').first,
    'paid_by': paidBy,
    if (note != null && note!.isNotEmpty) 'note': note,
  };
}
