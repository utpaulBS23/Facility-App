// The raw records a facility's monthly report is added up from. Whole-partner
// lists: the builder picks one facility out of them.

class CashItemRecord {
  const CashItemRecord({
    required this.service,
    required this.gender,
    required this.quantity,
    required this.amount,
  });

  /// Service name as sent (`Toilet`, `Shower`...).
  final String service;
  final String gender;
  final num quantity;
  final num amount;
}

class CashCollectionRecord {
  const CashCollectionRecord({
    required this.facilityId,
    required this.date,
    required this.productSelling,
    required this.rentingOthers,
    required this.items,
  });

  final int? facilityId;

  /// `yyyy-MM-dd`.
  final String date;
  final num productSelling;
  final num rentingOthers;
  final List<CashItemRecord> items;
}

class ExtraIncomeRecord {
  const ExtraIncomeRecord({
    required this.facilityId,
    required this.type,
    required this.amount,
    required this.status,
    required this.submittedAt,
  });

  final int? facilityId;
  final String type;
  final num amount;
  final String status;
  final String submittedAt;
}

class ProductSaleRecord {
  const ProductSaleRecord({
    required this.facilityId,
    required this.date,
    required this.productName,
    required this.revenue,
  });

  final int? facilityId;
  final String date;
  final String productName;
  final num revenue;
}

class ExpenseRecord {
  const ExpenseRecord({
    required this.facilityId,
    required this.category,
    required this.amount,
    required this.date,
  });

  final int? facilityId;
  final String category;
  final num amount;
  final String date;
}

class AccessRecord {
  const AccessRecord({
    required this.facilityId,
    required this.unlockedVia,
    required this.price,
  });

  final int? facilityId;

  /// `user_app` for an unlock from the customer app.
  final String unlockedVia;
  final num price;
}

class CenterCollectionRecord {
  const CenterCollectionRecord({
    required this.facilityId,
    required this.date,
    required this.channel,
    required this.amount,
  });

  final int? facilityId;
  final String date;
  final String channel;
  final num amount;
}

class TransactionRecord {
  const TransactionRecord({
    required this.facilityId,
    required this.date,
    required this.amount,
  });

  final int? facilityId;
  final String date;
  final num amount;
}

class FacilityReportSources {
  const FacilityReportSources({
    this.cash = const [],
    this.extras = const [],
    this.products = const [],
    this.expenses = const [],
    this.accesses = const [],
    this.centers = const [],
    this.transactions = const [],
  });

  final List<CashCollectionRecord> cash;
  final List<ExtraIncomeRecord> extras;
  final List<ProductSaleRecord> products;
  final List<ExpenseRecord> expenses;
  final List<AccessRecord> accesses;
  final List<CenterCollectionRecord> centers;
  final List<TransactionRecord> transactions;
}
