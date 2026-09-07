import 'travel_expense_status.dart';

/// UI tab filter for the travel-expenses list screen.
enum TravelExpenseListFilter {
  all,
  waiting,
  allowed,
  rejected;

  TravelExpenseStatus? get status => switch (this) {
    TravelExpenseListFilter.all => null,
    TravelExpenseListFilter.waiting => TravelExpenseStatus.waiting,
    TravelExpenseListFilter.allowed => TravelExpenseStatus.allowed,
    TravelExpenseListFilter.rejected => TravelExpenseStatus.rejected,
  };

  bool matches(TravelExpenseStatus status) {
    return switch (this) {
      TravelExpenseListFilter.all => true,
      TravelExpenseListFilter.waiting => status == TravelExpenseStatus.waiting,
      TravelExpenseListFilter.allowed => status == TravelExpenseStatus.allowed,
      TravelExpenseListFilter.rejected =>
        status == TravelExpenseStatus.rejected,
    };
  }
}
