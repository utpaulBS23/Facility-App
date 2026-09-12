import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../domain/entities/master_data_entity.dart';

part 'selected_expense_paid_by_provider.g.dart';

@riverpod
class SelectedExpensePaidBy extends _$SelectedExpensePaidBy {
  @override
  MasterDataItemEntity? build() => null;

  void select(MasterDataItemEntity? paidBy) {
    state = paidBy;
  }
}
