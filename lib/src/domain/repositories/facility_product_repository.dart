import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/facility_product/facility_product_entity.dart';
import '../entities/facility_product/facility_product_filter.dart';

abstract base class FacilityProductRepository extends Repository {
  Future<Result<List<FacilityProductEntity>, Failure>> getFacilityProducts(
    FacilityProductFilter filter,
  );
}
