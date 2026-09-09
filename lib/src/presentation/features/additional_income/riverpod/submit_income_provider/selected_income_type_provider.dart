import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../domain/entities/master_data_entity.dart';

part 'selected_income_type_provider.g.dart';

@riverpod
class SelectedIncomeType extends _$SelectedIncomeType {
  @override
  MasterDataItemEntity? build() => null;

  void select(MasterDataItemEntity? incomeType) {
    state = incomeType;
  }
}
