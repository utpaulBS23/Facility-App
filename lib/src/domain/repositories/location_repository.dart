// Author: Md. Shahin Bashar
// Updated: 2026-04-08

import 'package:facility_management_app/src/core/base/base.dart';

import '../entities/location_entity.dart';

abstract base class LocationRepository extends Repository {
  Future<Result<LocationResponseEntity, Failure>> getCurrentLocation();
}
