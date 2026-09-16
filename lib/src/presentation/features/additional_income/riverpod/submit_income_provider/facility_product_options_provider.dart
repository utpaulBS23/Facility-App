import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/base.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../domain/entities/facility_product/facility_product_entity.dart';
import 'selected_income_facility_provider.dart';

part 'facility_product_options_provider.g.dart';

@riverpod
class FacilityProductOptions extends _$FacilityProductOptions {
  @override
  Future<List<FacilityProductEntity>> build() async {
    ref.listen(selectedIncomeFacilityProvider, (previous, next) {
      ref.invalidateSelf();
    });

    final facilityId = ref.read(selectedIncomeFacilityProvider);
    if (facilityId == null) return const [];

    final result = await ref
        .read(getFacilityProductsUseCaseProvider)
        .call(facilityId: facilityId);

    return switch (result) {
      Success(:final data) => data ?? const [],
      Error(:final error) => throw Exception(error.message),
      _ => throw Exception('Failed to load facility products'),
    };
  }
}
