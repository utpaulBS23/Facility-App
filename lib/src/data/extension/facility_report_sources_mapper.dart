import '../../domain/entities/toilet_location/facility_report_sources_entity.dart';
import '../models/facility_report/facility_report_source_models.dart';

/// A number sent as a number or as a decimal string; 0 when absent.
num _num(Object? value) {
  if (value is num) return value;
  if (value == null) return 0;

  return num.tryParse(value.toString()) ?? 0;
}

/// The facility id of a `facility` field sent as `{id: ...}` or as the id.
int? _facilityId(Object? facility, [Object? fallbackId]) {
  int? asInt(Object? v) => v is num ? v.toInt() : int.tryParse('$v');

  if (facility is Map) return asInt(facility['id']);
  if (facility is num) return facility.toInt();
  if (fallbackId != null) return asInt(fallbackId);

  return null;
}

extension ReportCashCollectionModelToRecord on ReportCashCollectionModel {
  CashCollectionRecord toRecord() => CashCollectionRecord(
    facilityId: _facilityId(facility),
    date: collectionDate ?? '',
    productSelling: _num(productSellingAmount),
    rentingOthers: _num(rentingOthersAmount),
    items: [
      for (final i in items)
        CashItemRecord(
          service: i.facilityService?.serviceName ?? '',
          gender: i.gender ?? '',
          quantity: _num(i.quantity),
          amount: _num(i.amount),
        ),
    ],
  );
}

extension ReportExtraIncomeModelToRecord on ReportExtraIncomeModel {
  ExtraIncomeRecord toRecord() => ExtraIncomeRecord(
    facilityId: _facilityId(facility),
    type: incomeType ?? '',
    amount: _num(amount),
    status: status ?? '',
    submittedAt: submittedAt ?? '',
  );
}

extension ReportProductSaleModelToRecord on ReportProductSaleModel {
  ProductSaleRecord toRecord() => ProductSaleRecord(
    facilityId: _facilityId(facility),
    date: entryDate ?? '',
    productName: product?.name ?? '',
    revenue: _num(revenue),
  );
}

extension ReportExpenseModelToRecord on ReportExpenseModel {
  ExpenseRecord toRecord() => ExpenseRecord(
    facilityId: _facilityId(facility),
    category: category ?? '',
    amount: _num(amount),
    date: expenseDate ?? '',
  );
}

extension ReportAccessModelToRecord on ReportAccessModel {
  AccessRecord toRecord() => AccessRecord(
    facilityId: _facilityId(facility, facilityId),
    unlockedVia: unlockedVia ?? '',
    price: _num(price),
  );
}

extension ReportCenterCollectionModelToRecord on ReportCenterCollectionModel {
  CenterCollectionRecord toRecord() => CenterCollectionRecord(
    facilityId: _facilityId(facility),
    date: collectionDate ?? '',
    channel: channel ?? '',
    amount: _num(amount),
  );
}

extension ReportTransactionModelToRecord on ReportTransactionModel {
  TransactionRecord toRecord() => TransactionRecord(
    facilityId: _facilityId(facility),
    date: transactionDate ?? '',
    amount: _num(amount),
  );
}
