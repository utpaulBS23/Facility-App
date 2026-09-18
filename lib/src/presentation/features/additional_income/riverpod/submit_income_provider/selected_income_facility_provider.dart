import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_income_facility_provider.g.dart';

@riverpod
class SelectedIncomeFacility extends _$SelectedIncomeFacility {
  @override
  int? build() => null;

  void select(int? facilityId) {
    state = facilityId;
  }
}
