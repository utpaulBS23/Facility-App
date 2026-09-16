import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/facility_expense/facility_expense_entity.dart';
import '../../../../domain/entities/facility_expense/facility_expense_filter.dart';
import 'submit_expense_provider/submit_facility_expense_provider.dart';

part 'facility_expenses_list_provider.g.dart';

@riverpod
class FacilityExpensesList extends _$FacilityExpensesList {
  int? _selectedFacilityId;
  String? _selectedMonth;

  @override
  Future<FacilityExpenseListResultEntity> build() async {
    ref.listen(submitFacilityExpenseProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && !next.hasError) {
        ref.invalidateSelf();
      }
    });

    return fetch(facilityId: _selectedFacilityId, month: _selectedMonth);
  }

  /// [month] is `yyyy-MM`; mapped to an inclusive `from`/`to` date range
  /// covering that whole month.
  Future<FacilityExpenseListResultEntity> fetch({
    int? facilityId,
    String? month,
  }) async {
    _selectedFacilityId = facilityId;
    _selectedMonth = month;

    state = const AsyncValue.loading();

    String? from;
    String? to;
    if (month != null) {
      final parts = month.split('-');
      final year = int.parse(parts[0]);
      final monthNum = int.parse(parts[1]);
      final lastDay = DateTime(year, monthNum + 1, 0).day;
      from = '$month-01';
      to = '$month-${lastDay.toString().padLeft(2, '0')}';
    }

    final result = await ref
        .read(getFacilityExpensesUseCaseProvider)
        .call(FacilityExpenseFilter(facilityId: facilityId, from: from, to: to));

    return switch (result) {
      Success(:final data) =>
        _onFetchSuccess(data ?? const FacilityExpenseListResultEntity.empty()),
      Error(:final error) => _onFetchError(error),
      _ => _onFetchError(Failure.emptyResponse('get facility expenses')),
    };
  }

  FacilityExpenseListResultEntity _onFetchSuccess(
    FacilityExpenseListResultEntity result,
  ) {
    state = AsyncValue.data(result);
    return result;
  }

  FacilityExpenseListResultEntity _onFetchError(Failure error) {
    state = AsyncValue.error(error, StackTrace.current);
    return const FacilityExpenseListResultEntity.empty();
  }
}
