import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../domain/entities/master_data_entity.dart';
import 'selected_expense_category_provider.dart';
import 'selected_expense_facility_provider.dart';

part 'selected_expense_paid_by_provider.g.dart';

@riverpod
class SelectedExpensePaidBy extends _$SelectedExpensePaidBy {
  @override
  MasterDataItemEntity? build() {
    ref.listen(selectedExpenseCategoryProvider, (previous, next) {
      ref.invalidateSelf();
    });
    ref.listen(selectedExpenseFacilityProvider, (previous, next) {
      ref.invalidateSelf();
    });

    return null;
  }

  void select(MasterDataItemEntity? paidBy) {
    state = paidBy;
  }
}
