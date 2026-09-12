import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_expense_facility_provider.g.dart';

@riverpod
class SelectedExpenseFacility extends _$SelectedExpenseFacility {
  @override
  int? build() => null;

  void select(int? facilityId) {
    state = facilityId;
  }
}
