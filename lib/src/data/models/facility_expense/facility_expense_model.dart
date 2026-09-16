import 'package:dart_mappable/dart_mappable.dart';

import 'facility_expense_pagination_meta_model.dart';
import 'named_ref_model.dart';

part 'facility_expense_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityExpenseSummaryModel with FacilityExpenseSummaryModelMappable {
  const FacilityExpenseSummaryModel({
    this.totalExpenses,
    this.cashPaid,
    this.accountsPaid,
  });

  final double? totalExpenses;
  final double? cashPaid;
  final double? accountsPaid;

  static const fromJson = FacilityExpenseSummaryModelMapper.fromJson;
}

// WHY no separate wrapper: the doc's store/show response is flat at the top
// level (no `data` wrapper) — this model IS that flat shape directly.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityExpenseModel with FacilityExpenseModelMappable {
  const FacilityExpenseModel({
    required this.id,
    this.facility,
    this.category,
    this.amount,
    this.expenseDate,
    this.paidBy,
    this.note,
    this.recordedBy,
    this.createdAt,
  });

  final int id;
  final NamedRefModel? facility;
  // WHY String not NamedRefModel: unlike facility/recorded_by, the backend
  // returns category as a plain master-data value string (e.g. "cleaner"),
  // not an {id, name} object — doc was wrong here too.
  final String? category;
  final double? amount;
  final String? expenseDate;
  final String? paidBy;
  final String? note;
  final NamedRefModel? recordedBy;
  final String? createdAt;

  static const fromJson = FacilityExpenseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class FacilityExpenseListResponseModel
    with FacilityExpenseListResponseModelMappable {
  const FacilityExpenseListResponseModel({
    this.data = const [],
    this.meta,
    this.summary,
  });

  final List<FacilityExpenseModel> data;
  final FacilityExpensePaginationMetaModel? meta;
  final FacilityExpenseSummaryModel? summary;

  static const fromJson = FacilityExpenseListResponseModelMapper.fromJson;
}
