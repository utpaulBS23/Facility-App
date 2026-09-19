import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../domain/entities/facility_product/facility_product_entity.dart';
import 'selected_income_facility_provider.dart';

part 'selected_product_provider.g.dart';

@riverpod
class SelectedProduct extends _$SelectedProduct {
  @override
  FacilityProductEntity? build() {
    ref.listen(selectedIncomeFacilityProvider, (previous, next) {
      ref.invalidateSelf();
    });

    return null;
  }

  void select(FacilityProductEntity? product) {
    state = product;
  }
}
