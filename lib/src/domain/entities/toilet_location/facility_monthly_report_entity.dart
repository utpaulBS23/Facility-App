// The monthly report of one facility, worked out from the day-to-day records
// (cash collected, extra income, product sales, expenses, app unlocks,
// package purchases, remittances). It copies how the admin web's "Facility
// Wise Report" PDF adds them up, so the two agree.
//
// WHY no fixed list of services or income types: every income line carries the
// name the server sent (a service name, an extra-income type, a product name),
// so a new service or income type shows up without an app release.

/// A labelled amount: an expense line.
class ReportAmountLine {
  const ReportAmountLine(this.key, this.value);

  /// The expense category as sent.
  final String key;
  final num value;
}

/// Where an income line comes from, which decides how the UI names it.
enum ReportIncomeKind {
  /// A service on the cash sheets (`Toilet`, `Shower`...), named as sent.
  service,

  /// An approved extra income, [ReportIncomeLine.label] is its type key.
  extra,

  /// A product sold, named as sent.
  product,

  /// The cash sheets' product amount, used when no product sales exist.
  cashProduct,

  /// The cash sheets' renting and others amount, used when there is no extra
  /// income.
  rentingOthers,

  /// Customer-app unlocks; [ReportIncomeLine.label] is the unlock source key.
  app,
}

class ReportIncomeLine {
  const ReportIncomeLine({
    required this.kind,
    required this.label,
    required this.value,
  });

  final ReportIncomeKind kind;

  /// The name or key the server sent.
  final String label;
  final num value;
}

/// People served by one service, by gender.
class ReportServiceUsers {
  const ReportServiceUsers({
    required this.label,
    required this.women,
    required this.men,
  });

  /// The service name as sent.
  final String label;
  final num women;
  final num men;

  num get total => women + men;
}

class FacilityMonthlyReportEntity {
  const FacilityMonthlyReportEntity({
    required this.month,
    required this.hasRecords,
    required this.services,
    required this.incomeLines,
    required this.expenseLines,
    required this.appIncome,
    required this.packageIncome,
    required this.bkashCollected,
  });

  /// `YYYY-MM`.
  final String month;

  /// False when the facility has no record of any kind in the month.
  final bool hasRecords;

  final List<ReportServiceUsers> services;

  /// Every income line the records produced, in report order.
  final List<ReportIncomeLine> incomeLines;

  /// Expense by category, only categories with spend.
  final List<ReportAmountLine> expenseLines;

  /// Income from every app unlock, and from package purchases.
  final num appIncome;
  final num packageIncome;

  /// Remitted to bKash this month.
  final num bkashCollected;

  num get totalIncome => incomeLines.fold<num>(0, (a, l) => a + l.value);
  num get totalExpense => expenseLines.fold<num>(0, (a, l) => a + l.value);
  num get profitLoss => totalIncome - totalExpense;

  num get totalUsers => services.fold<num>(0, (a, s) => a + s.total);

  /// What the digital system earned: app unlocks plus packages.
  num get digitalIncome => appIncome + packageIncome;
}
