import 'package:facility_management_app/src/core/base/base.dart';

abstract base class LocationRepository extends Repository {
  Future<Result<String?, Failure>> getDeviceCountry();

  Future<Result<List<String>, Failure>> getCountries();
}
