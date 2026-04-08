// Author: Md. Shahin Bashar
// Updated: 2026-04-08

import '../../core/base/base.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../services/location/location_service.dart';

final class LocationRepositoryImpl extends LocationRepository {
  LocationRepositoryImpl(this._locationService);

  final LocationService _locationService;

  @override
  Future<Result<LocationResponseEntity, Failure>> getCurrentLocation() async {
    return asyncGuard(() async {
      final position = await _locationService.getCurrentPosition();
      if (position == null) {
        throw Exception('Unable to get current location');
      }

      if (position.isMocked) {
        throw Exception('You are using a mocked location');
      }

      final address = await _locationService.getAddressFromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      return LocationResponseEntity(
        address: address ?? 'Unknown location',
        latitude: position.latitude,
        longitude: position.longitude,
      );
    });
  }
}
