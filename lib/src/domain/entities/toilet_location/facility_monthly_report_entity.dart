// The monthly report of one facility, worked out from the day-to-day records
// (cash collected, extra income, product sales, expenses, app unlocks,
// package purchases, remittances). It copies how the admin web's "Facility
// Wise Report" PDF adds them up, so the two agree.

/// A labelled amount: a revenue or cost line.
class ReportAmountLine {
  const ReportAmountLine(this.key, this.value);

  /// Stable key (`toilet`, `laundry`, a raw expense category...) the UI labels.
  final String key;
  final num value;
}

/// Users served, by service and gender.
class ReportUserCount {
  const ReportUserCount({required this.women, required this.men});

  final num women;
  final num men;

  num get total => women + men;
}

class FacilityMonthlyReportEntity {
  const FacilityMonthlyReportEntity({
    required this.month,
    required this.toiletUsers,
    required this.urinalUsers,
    required this.showerUsers,
    required this.drinkingWaterUsers,
    required this.incomeLines,
    required this.expenseLines,
    required this.appIncome,
    required this.packageIncome,
    required this.bkashCollected,
  });

  /// `YYYY-MM`.
  final String month;

  final ReportUserCount toiletUsers;
  final ReportUserCount urinalUsers;
  final ReportUserCount showerUsers;
  final ReportUserCount drinkingWaterUsers;

  /// Every income line, in report order. Zero lines are kept; the UI decides
  /// which to show.
  final List<ReportAmountLine> incomeLines;

  /// Expense by category, including categories with no spend left out.
  final List<ReportAmountLine> expenseLines;

  /// Income from app unlocks, and from package purchases.
  final num appIncome;
  final num packageIncome;

  /// Remitted to bKash this month.
  final num bkashCollected;

  num incomeOf(String key) {
    for (final line in incomeLines) {
      if (line.key == key) return line.value;
    }

    return 0;
  }

  num get totalIncome => incomeLines.fold<num>(0, (a, l) => a + l.value);
  num get totalExpense => expenseLines.fold<num>(0, (a, l) => a + l.value);
  num get profitLoss => totalIncome - totalExpense;

  num get totalUsers =>
      toiletUsers.total +
      urinalUsers.total +
      showerUsers.total +
      drinkingWaterUsers.total;

  /// What the digital system earned: app unlocks plus packages.
  num get digitalIncome => appIncome + packageIncome;
}
