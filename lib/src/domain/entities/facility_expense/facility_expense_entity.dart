import '../common/paginated_list_entity.dart';

enum FacilityExpensePaidBy {
  cash,
  accounts,
  unknown;

  static FacilityExpensePaidBy fromWireString(String? raw) {
    return switch (raw?.toLowerCase()) {
      'cash' => .cash,
      'accounts' => .accounts,
      _ => .unknown,
    };
  }

  String toWireString() {
    return switch (this) {
      .cash => 'cash',
      .accounts => 'accounts',
      .unknown => 'unknown',
    };
  }
}

/// Filter query parameters for facility expenses list
/// (`GET /partners/{partner}/facility-expenses`).
class FacilityExpenseFilter {
  const FacilityExpenseFilter({
    this.partnerId,
    this.facilityId,
    this.page,
    this.pageSize,
  });

  final int? partnerId;
  final int? facilityId;
  final int? page;
  final int? pageSize;

  FacilityExpenseFilter copyWith({
    int? partnerId,
    int? facilityId,
    int? page,
    int? pageSize,
  }) {
    return FacilityExpenseFilter(
      partnerId: partnerId ?? this.partnerId,
      facilityId: facilityId ?? this.facilityId,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

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
