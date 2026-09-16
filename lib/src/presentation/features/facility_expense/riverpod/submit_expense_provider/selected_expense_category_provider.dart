import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../domain/entities/master_data_entity.dart';

part 'selected_expense_category_provider.g.dart';

@riverpod
class SelectedExpenseCategory extends _$SelectedExpenseCategory {
  @override
  MasterDataItemEntity? build() => null;

  void select(MasterDataItemEntity? category) {
    state = category;
  }
}
