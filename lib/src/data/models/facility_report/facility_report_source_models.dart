import 'package:dart_mappable/dart_mappable.dart';

part 'facility_report_source_models.mapper.dart';

// WHY loose types: these records only feed the monthly report's sums. Amounts
// and prices may arrive as numbers or decimal strings, and `facility` as an
// object or an id, so they decode as-is and the mapper reads them tolerantly.

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ReportServiceRefModel with ReportServiceRefModelMappable {
  const ReportServiceRefModel({this.serviceName});

  final String? serviceName;

  static const fromJson = ReportServiceRefModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ReportCashItemModel with ReportCashItemModelMappable {
  const ReportCashItemModel({
    this.facilityService,
    this.gender,
    this.quantity,
    this.amount,
  });

  final ReportServiceRefModel? facilityService;
  final String? gender;
  final Object? quantity;
  final Object? amount;

  static const fromJson = ReportCashItemModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ReportCashCollectionModel with ReportCashCollectionModelMappable {
  const ReportCashCollectionModel({
    this.facility,
    this.collectionDate,
    this.productSellingAmount,
    this.rentingOthersAmount,
    this.items = const [],
  });

  final Object? facility;
  final String? collectionDate;
  final Object? productSellingAmount;
  final Object? rentingOthersAmount;
  final List<ReportCashItemModel> items;

  static const fromJson = ReportCashCollectionModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ReportExtraIncomeModel with ReportExtraIncomeModelMappable {
  const ReportExtraIncomeModel({
    this.facility,
    this.incomeType,
    this.amount,
    this.status,
    this.submittedAt,
  });

  final Object? facility;
  final String? incomeType;
  final Object? amount;
  final String? status;
  final String? submittedAt;

  static const fromJson = ReportExtraIncomeModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ReportProductRefModel with ReportProductRefModelMappable {
  const ReportProductRefModel({this.name});

  final String? name;

  static const fromJson = ReportProductRefModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ReportProductSaleModel with ReportProductSaleModelMappable {
  const ReportProductSaleModel({
    this.facility,
    this.entryDate,
    this.product,
    this.revenue,
  });

  final Object? facility;
  final String? entryDate;
  final ReportProductRefModel? product;
  final Object? revenue;

  static const fromJson = ReportProductSaleModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ReportExpenseModel with ReportExpenseModelMappable {
  const ReportExpenseModel({
    this.facility,
    this.category,
    this.amount,
    this.expenseDate,
  });

  final Object? facility;
  final String? category;
  final Object? amount;
  final String? expenseDate;

  static const fromJson = ReportExpenseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ReportAccessModel with ReportAccessModelMappable {
  const ReportAccessModel({
    this.facility,
    this.facilityId,
    this.unlockedVia,
    this.price,
  });

  final Object? facility;
  final Object? facilityId;
  final String? unlockedVia;
  final Object? price;

  static const fromJson = ReportAccessModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ReportCenterCollectionModel with ReportCenterCollectionModelMappable {
  const ReportCenterCollectionModel({
    this.facility,
    this.collectionDate,
    this.channel,
    this.amount,
  });

  final Object? facility;
  final String? collectionDate;
  final String? channel;
  final Object? amount;

  static const fromJson = ReportCenterCollectionModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ReportTransactionModel with ReportTransactionModelMappable {
  const ReportTransactionModel({
    this.facility,
    this.transactionDate,
    this.amount,
  });

  final Object? facility;
  final String? transactionDate;
  final Object? amount;

  static const fromJson = ReportTransactionModelMapper.fromJson;
}
