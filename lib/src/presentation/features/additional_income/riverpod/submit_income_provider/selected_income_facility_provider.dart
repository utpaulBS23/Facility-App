import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'selected_income_type_provider.dart';

part 'selected_income_facility_provider.g.dart';

@riverpod
class SelectedIncomeFacility extends _$SelectedIncomeFacility {
  @override
  int? build() {
    ref.listen(selectedIncomeTypeProvider, (previous, next) {
      ref.invalidateSelf();
    });

    return null;
  }

  void select(int? facilityId) {
    state = facilityId;
  }
}
