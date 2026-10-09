import 'package:facility_management_app/src/domain/entities/toilet_location/facility_monthly_report_entity.dart';
import 'package:facility_management_app/src/domain/entities/toilet_location/facility_report_sources_entity.dart';
import 'package:facility_management_app/src/domain/use_cases/toilet_location/build_facility_monthly_report.dart';
import 'package:flutter_test/flutter_test.dart';

CashItemRecord _item(String service, String gender, num qty) => CashItemRecord(
  service: service,
  gender: gender,
  quantity: qty,
  amount: qty, // unit price 1, as in the sample data
);

// The August 2026 data of "ABM Uttara Relief Zone" (facility 44) as the
// admin web loads it. The web's PDF for it shows income 874, expense 1,100,
// profit -226 and 34 users; these tests pin the same arithmetic.
FacilityReportSources _august() => FacilityReportSources(
  cash: [
    CashCollectionRecord(
      facilityId: 44,
      date: '2026-08-10',
      productSelling: 200,
      rentingOthers: 300,
      items: [
        _item('Shower', 'female', 2),
        _item('Shower', 'male', 2),
        _item('Toilet', 'female', 2),
        _item('Toilet', 'male', 2),
      ],
    ),
    CashCollectionRecord(
      facilityId: 44,
      date: '2026-08-03',
      productSelling: 0,
      rentingOthers: 0,
      items: [
        _item('Shower', 'female', 4),
        _item('Shower', 'male', 3),
        _item('Toilet', 'female', 3),
        _item('Toilet', 'male', 2),
      ],
    ),
    CashCollectionRecord(
      facilityId: 44,
      date: '2026-08-02',
      productSelling: 0,
      rentingOthers: 0,
      items: [
        _item('Shower', 'female', 3),
        _item('Shower', 'male', 3),
        _item('Toilet', 'female', 4),
        _item('Toilet', 'male', 4),
      ],
    ),
    // Another facility, and another month: both ignored.
    CashCollectionRecord(
      facilityId: 43,
      date: '2026-08-04',
      productSelling: 0,
      rentingOthers: 0,
      items: [_item('Toilet', 'male', 50)],
    ),
    CashCollectionRecord(
      facilityId: 44,
      date: '2026-07-30',
      productSelling: 0,
      rentingOthers: 0,
      items: [_item('Toilet', 'male', 99)],
    ),
  ],
  extras: const [
    ExtraIncomeRecord(
      facilityId: 44,
      type: 'laundry',
      amount: 800,
      status: 'approved',
      submittedAt: '2026-08-12 10:00:00',
    ),
    // Submitted in another month: the web counts by submission date.
    ExtraIncomeRecord(
      facilityId: 44,
      type: 'locker',
      amount: 19992,
      status: 'approved',
      submittedAt: '2026-09-02 10:00:00',
    ),
    ExtraIncomeRecord(
      facilityId: 44,
      type: 'locker',
      amount: 5000,
      status: 'pending',
      submittedAt: '2026-08-05 10:00:00',
    ),
  ],
  products: const [
    ProductSaleRecord(
      facilityId: 44,
      date: '2026-08-05',
      productName: 'Water',
      revenue: 40,
    ),
  ],
  expenses: const [
    ExpenseRecord(
      facilityId: 44,
      category: 'water_bill',
      amount: 1000,
      date: '2026-08-11',
    ),
    ExpenseRecord(
      facilityId: 44,
      category: 'water_bill',
      amount: 100,
      date: '2026-08-03',
    ),
  ],
  centers: const [
    CenterCollectionRecord(
      facilityId: 44,
      date: '2026-08-04',
      channel: 'bank',
      amount: 250,
    ),
  ],
);

({String label, num value}) _line(ReportIncomeLine l) =>
    (label: l.label, value: l.value);

void main() {
  test('matches the web PDF for August 2026', () {
    final r = buildFacilityMonthlyReport(
      _august(),
      facilityId: 44,
      month: '2026-08',
    );

    // Named by the records: two services, one extra-income type, one product.
    expect(r.incomeLines.map(_line).toList(), [
      (label: 'Shower', value: 17),
      (label: 'Toilet', value: 17),
      (label: 'laundry', value: 800),
      (label: 'Water', value: 40),
    ]);
    expect(r.totalIncome, 874);
    expect(r.totalExpense, 1100);
    expect(r.profitLoss, -226);

    final toilet = r.services.firstWhere((s) => s.label == 'Toilet');
    final shower = r.services.firstWhere((s) => s.label == 'Shower');
    expect((toilet.women, toilet.men), (9, 8));
    expect((shower.women, shower.men), (9, 8));
    expect(r.totalUsers, 34);
    expect(r.hasRecords, isTrue);
  });

  test('a service or income type nobody listed shows up by itself', () {
    final r = buildFacilityMonthlyReport(
      FacilityReportSources(
        cash: [
          CashCollectionRecord(
            facilityId: 1,
            date: '2026-08-01',
            productSelling: 0,
            rentingOthers: 0,
            items: [_item('Sauna', 'male', 3)],
          ),
        ],
        extras: const [
          ExtraIncomeRecord(
            facilityId: 1,
            type: 'advertisement',
            amount: 500,
            status: 'approved',
            submittedAt: '2026-08-02 10:00:00',
          ),
        ],
      ),
      facilityId: 1,
      month: '2026-08',
    );

    expect(r.incomeLines.map((l) => l.label), ['Sauna', 'advertisement']);
    expect(r.totalIncome, 503);
  });

  test('expense is grouped by category', () {
    final r = buildFacilityMonthlyReport(
      _august(),
      facilityId: 44,
      month: '2026-08',
    );

    expect(r.expenseLines.map((l) => (l.key, l.value)).toList(), [
      ('water_bill', 1100),
    ]);
  });

  test('another facility sees none of it', () {
    final r = buildFacilityMonthlyReport(
      _august(),
      facilityId: 43,
      month: '2026-08',
    );

    expect(r.totalUsers, 50);
    expect(r.totalExpense, 0);
    expect(r.incomeLines.map((l) => l.label), ['Toilet']);
  });

  test('a facility with no records says so', () {
    final r = buildFacilityMonthlyReport(
      _august(),
      facilityId: 99,
      month: '2026-08',
    );

    expect(r.hasRecords, isFalse);
    expect(r.incomeLines, isEmpty);
    expect(r.totalIncome, 0);
  });

  test('cash sheet product and renting amounts stand in when nothing else '
      'was recorded', () {
    final r = buildFacilityMonthlyReport(
      FacilityReportSources(
        cash: [
          CashCollectionRecord(
            facilityId: 1,
            date: '2026-08-01',
            productSelling: 200,
            rentingOthers: 300,
            items: const [],
          ),
        ],
      ),
      facilityId: 1,
      month: '2026-08',
    );

    expect(r.incomeLines.map((l) => (l.kind, l.value)).toList(), [
      (ReportIncomeKind.cashProduct, 200),
      (ReportIncomeKind.rentingOthers, 300),
    ]);
  });

  test('app income and package purchases feed the digital system', () {
    final r = buildFacilityMonthlyReport(
      const FacilityReportSources(
        accesses: [
          AccessRecord(facilityId: 1, unlockedVia: 'user_app', price: 10),
          AccessRecord(facilityId: 1, unlockedVia: 'facility_app', price: 5),
        ],
        transactions: [
          TransactionRecord(facilityId: 1, date: '2026-08-09', amount: 100),
        ],
        centers: [
          CenterCollectionRecord(
            facilityId: 1,
            date: '2026-08-04',
            channel: 'Bkash',
            amount: 70,
          ),
        ],
      ),
      facilityId: 1,
      month: '2026-08',
    );

    expect(r.incomeLines.single.kind, ReportIncomeKind.app);
    expect(r.incomeLines.single.value, 10);
    expect(r.appIncome, 15);
    expect(r.packageIncome, 100);
    expect(r.digitalIncome, 115);
    expect(r.bkashCollected, 70);
  });
}
