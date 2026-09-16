import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'selected_expense_category_provider.dart';

part 'selected_expense_facility_provider.g.dart';

@riverpod
class SelectedExpenseFacility extends _$SelectedExpenseFacility {
  @override
  int? build() {
    ref.listen(selectedExpenseCategoryProvider, (previous, next) {
      ref.invalidateSelf();
    });

    return null;
  }

  void select(int? facilityId) {
    state = facilityId;
  }
}
