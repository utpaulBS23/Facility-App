// Author: Md. Shahin Bashar
// Updated: 2026-04-08

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/base/base.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../services/location/location_service.dart';

final class LocationRepositoryImpl extends LocationRepository {
  LocationRepositoryImpl(this._locationService);

  final LocationService _locationService;

  String? _country;

  @override
  Future<Result<LocationResponseEntity, Failure>> getCurrentLocation() async {
    return asyncGuard(() async {
      final position = await _locationService.getCurrentPosition();
      if (position == null) {
        throw Exception('Unable to get current location');
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

  @override
  Future<Result<String?, Failure>> getDeviceCountry() async {
    return asyncGuard(() async {
      if (_country != null) return _country;

      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      _country = placemarks.isNotEmpty ? placemarks.first.country : null;

      return _country;
    });
  }

  @override
  Future<Result<List<String>, Failure>> getCountries() async {
    return asyncGuard(() async {
      return [
        'Australia',
        'India',
        'Singapore',
        'Germany',
        'France',
        'Italy',
        'Bangladesh',
        'Pakistan',
        'Iran',
        'Palestine',
        'Iraq',
        'China',
        'England',
        'Italy',
        'Spain',
        'UAE',
      ];
    });
  }
}
