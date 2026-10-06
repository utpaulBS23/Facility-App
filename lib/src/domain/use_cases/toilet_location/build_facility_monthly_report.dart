import '../../entities/toilet_location/facility_monthly_report_entity.dart';
import '../../entities/toilet_location/facility_report_sources_entity.dart';

/// Adds up one facility's month from the raw records.
///
/// WHY this arithmetic: it mirrors the admin web's Facility Wise Report PDF,
/// so a facility shows the same figures in both places. Rules:
/// * a record counts when its date starts with [month] (`YYYY-MM`) and it
///   belongs to [facilityId];
/// * extra income counts only when approved, dated by `submitted_at`;
/// * the cash sheets' product amount stands in only when the facility has no
///   product sales, and their renting/others amount only when it has no extra
///   income.
///
/// Income is listed by what the records name: each service, each extra-income
/// type and each product becomes its own line. Nothing is matched against a
/// fixed list.
FacilityMonthlyReportEntity buildFacilityMonthlyReport(
  FacilityReportSources sources, {
  required int facilityId,
  required String month,
}) {
  bool inMonth(String date) => date.startsWith(month);
  bool mine(int? id) => id == facilityId;

  final cash = [
    for (final c in sources.cash)
      if (inMonth(c.date) && mine(c.facilityId)) c,
  ];
  final extras = [
    for (final e in sources.extras)
      if (e.status == 'approved' &&
          inMonth(e.submittedAt) &&
          mine(e.facilityId))
        e,
  ];
  final products = [
    for (final p in sources.products)
      if (inMonth(p.date) && mine(p.facilityId)) p,
  ];
  final expenses = [
    for (final e in sources.expenses)
      if (inMonth(e.date) && mine(e.facilityId)) e,
  ];
  final accesses = [
    for (final a in sources.accesses)
      if (mine(a.facilityId)) a,
  ];
  final transactions = [
    for (final t in sources.transactions)
      if (inMonth(t.date) && mine(t.facilityId)) t,
  ];
  final centers = [
    for (final c in sources.centers)
      if (inMonth(c.date) && mine(c.facilityId)) c,
  ];

  // Services, in the order the cash sheets first name them.
  final serviceNames = <String, String>{};
  final serviceAmount = <String, num>{};
  final serviceWomen = <String, num>{};
  final serviceMen = <String, num>{};
  for (final item in [for (final c in cash) ...c.items]) {
    if (item.service.trim().isEmpty) continue;
    final key = _key(item.service);
    serviceNames.putIfAbsent(key, () => item.service);
    serviceAmount[key] = (serviceAmount[key] ?? 0) + item.amount;
    if (_isFemale(item.gender)) {
      serviceWomen[key] = (serviceWomen[key] ?? 0) + item.quantity;
    } else if (_isMale(item.gender)) {
      serviceMen[key] = (serviceMen[key] ?? 0) + item.quantity;
    }
  }

  final extraNames = <String, String>{};
  final extraAmount = <String, num>{};
  for (final e in extras) {
    final key = _key(e.type);
    extraNames.putIfAbsent(key, () => e.type);
    extraAmount[key] = (extraAmount[key] ?? 0) + e.amount;
  }

  final productNames = <String, String>{};
  final productAmount = <String, num>{};
  for (final p in products) {
    final key = _key(p.productName);
    productNames.putIfAbsent(key, () => p.productName);
    productAmount[key] = (productAmount[key] ?? 0) + p.revenue;
  }

  final cashProduct = cash.fold<num>(0, (a, c) => a + c.productSelling);
  final cashRenting = cash.fold<num>(0, (a, c) => a + c.rentingOthers);
  final appFromCustomers = accesses
      .where((a) => a.unlockedVia == 'user_app')
      .fold<num>(0, (a, r) => a + r.price);

  final spend = <String, num>{};
  for (final e in expenses) {
    final category = e.category.isEmpty ? 'other' : e.category;
    spend[category] = (spend[category] ?? 0) + e.amount;
  }

  return FacilityMonthlyReportEntity(
    month: month,
    hasRecords:
        cash.isNotEmpty ||
        extras.isNotEmpty ||
        products.isNotEmpty ||
        expenses.isNotEmpty ||
        accesses.isNotEmpty ||
        transactions.isNotEmpty ||
        centers.isNotEmpty,
    services: [
      for (final key in serviceNames.keys)
        ReportServiceUsers(
          label: serviceNames[key]!,
          women: serviceWomen[key] ?? 0,
          men: serviceMen[key] ?? 0,
        ),
    ],
    incomeLines: [
      for (final key in serviceNames.keys)
        ReportIncomeLine(
          kind: ReportIncomeKind.service,
          label: serviceNames[key]!,
          value: serviceAmount[key] ?? 0,
        ),
      if (appFromCustomers != 0)
        ReportIncomeLine(
          kind: ReportIncomeKind.app,
          label: 'user_app',
          value: appFromCustomers,
        ),
      for (final key in extraNames.keys)
        ReportIncomeLine(
          kind: ReportIncomeKind.extra,
          label: extraNames[key]!,
          value: extraAmount[key] ?? 0,
        ),
      for (final key in productNames.keys)
        ReportIncomeLine(
          kind: ReportIncomeKind.product,
          label: productNames[key]!,
          value: productAmount[key] ?? 0,
        ),
      if (products.isEmpty && cashProduct != 0)
        ReportIncomeLine(
          kind: ReportIncomeKind.cashProduct,
          label: '',
          value: cashProduct,
        ),
      if (extras.isEmpty && cashRenting != 0)
        ReportIncomeLine(
          kind: ReportIncomeKind.rentingOthers,
          label: '',
          value: cashRenting,
        ),
    ],
    expenseLines: [
      for (final e in spend.entries) ReportAmountLine(e.key, e.value),
    ],
    // The digital system counts every unlock, not only the customer app's.
    appIncome: accesses.fold<num>(0, (a, r) => a + r.price),
    packageIncome: transactions.fold<num>(0, (a, t) => a + t.amount),
    bkashCollected: centers
        .where((c) => c.channel.toLowerCase() == 'bkash')
        .fold<num>(0, (a, c) => a + c.amount),
  );
}

/// `Drinking Water` and `drinking-water` group together.
String _key(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'[\s-]+'), '_');

bool _isFemale(String gender) {
  final g = gender.toLowerCase();

  return g == 'female' || g == 'f' || g == 'women' || g.startsWith('fem');
}

bool _isMale(String gender) {
  final g = gender.toLowerCase();

  return g == 'male' || g == 'm' || g == 'men' || g.startsWith('mal');
}
