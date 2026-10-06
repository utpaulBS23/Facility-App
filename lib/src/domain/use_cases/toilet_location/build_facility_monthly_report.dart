import '../../entities/toilet_location/facility_monthly_report_entity.dart';
import '../../entities/toilet_location/facility_report_sources_entity.dart';

/// Adds up one facility's month from the raw records.
///
/// WHY this exact arithmetic: it mirrors the admin web's Facility Wise Report
/// PDF, so a facility shows the same figures in both places. Notable rules:
/// * a record counts when its date starts with [month] (`YYYY-MM`) and it
///   belongs to [facilityId];
/// * extra income counts only when approved, dated by `submitted_at`;
/// * "product sales" is the product-sale entries (sanitary pads apart), or the
///   cash sheets' product amount when the facility has no product entries;
/// * "other income" is every extra income that is not laundry or locker, plus
///   the cash sheets' renting/others amount when there is no extra income.
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
  final items = [for (final c in cash) ...c.items];

  num amountOf(String service) => items
      .where((i) => _key(i.service) == service)
      .fold<num>(0, (a, i) => a + i.amount);

  ReportUserCount users(String service) {
    num count(bool Function(String) gender) => items
        .where((i) => _key(i.service) == service && gender(i.gender))
        .fold<num>(0, (a, i) => a + i.quantity);

    return ReportUserCount(women: count(_isFemale), men: count(_isMale));
  }

  final extras = [
    for (final e in sources.extras)
      if (e.status == 'approved' &&
          inMonth(e.submittedAt) &&
          mine(e.facilityId))
        e,
  ];
  num extrasWhere(bool Function(String type) test) => extras
      .where((e) => test(_key(e.type)))
      .fold<num>(0, (a, e) => a + e.amount);
  final laundry = extrasWhere((t) => t.contains('laundry'));
  final locker = extrasWhere((t) => t.contains('locker'));
  final otherExtras = extrasWhere(
    (t) => !t.contains('laundry') && !t.contains('locker'),
  );

  final products = [
    for (final p in sources.products)
      if (inMonth(p.date) && mine(p.facilityId)) p,
  ];
  bool isPad(ProductSaleRecord p) =>
      p.productName.toLowerCase().contains('sanitary');
  final padRevenue = products
      .where(isPad)
      .fold<num>(0, (a, p) => a + p.revenue);
  final shopRevenue = products
      .where((p) => !isPad(p))
      .fold<num>(0, (a, p) => a + p.revenue);

  final cashProduct = cash.fold<num>(0, (a, c) => a + c.productSelling);
  final cashRenting = cash.fold<num>(0, (a, c) => a + c.rentingOthers);

  final accesses = [
    for (final a in sources.accesses)
      if (mine(a.facilityId)) a,
  ];
  final appIncome = accesses
      .where((a) => a.unlockedVia == 'user_app')
      .fold<num>(0, (a, r) => a + r.price);
  // The digital system's "app income" counts every unlock, not only the
  // customer app's; the income line above counts the customer app's.
  final appUnlockIncome = accesses.fold<num>(0, (a, r) => a + r.price);

  final packageIncome = sources.transactions
      .where((t) => inMonth(t.date) && mine(t.facilityId))
      .fold<num>(0, (a, t) => a + t.amount);

  final bkash = sources.centers
      .where(
        (c) =>
            inMonth(c.date) &&
            mine(c.facilityId) &&
            c.channel.toLowerCase() == 'bkash',
      )
      .fold<num>(0, (a, c) => a + c.amount);

  final spend = <String, num>{};
  for (final e in sources.expenses) {
    if (!inMonth(e.date) || !mine(e.facilityId)) continue;
    final category = e.category.isEmpty ? 'other' : e.category;
    spend[category] = (spend[category] ?? 0) + e.amount;
  }

  return FacilityMonthlyReportEntity(
    month: month,
    toiletUsers: users('toilet'),
    urinalUsers: users('urinal'),
    showerUsers: users('shower'),
    drinkingWaterUsers: users('drinking_water'),
    incomeLines: [
      ReportAmountLine('toilet', amountOf('toilet')),
      ReportAmountLine('urinal', amountOf('urinal')),
      ReportAmountLine('shower', amountOf('shower')),
      ReportAmountLine('drinking_water', amountOf('drinking_water')),
      const ReportAmountLine('subscription', 0),
      ReportAmountLine('app', appIncome),
      ReportAmountLine('laundry', laundry),
      ReportAmountLine(
        'product_sales',
        shopRevenue != 0 || products.isNotEmpty ? shopRevenue : cashProduct,
      ),
      ReportAmountLine(
        'other_income',
        otherExtras + (extras.isEmpty ? cashRenting : 0),
      ),
      ReportAmountLine('sanitary_pad', padRevenue),
      ReportAmountLine('locker', locker),
    ],
    expenseLines: [
      for (final e in spend.entries) ReportAmountLine(e.key, e.value),
    ],
    appIncome: appUnlockIncome,
    packageIncome: packageIncome,
    bkashCollected: bkash,
  );
}

/// `Drinking Water` and `drinking-water` both become `drinking_water`.
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
