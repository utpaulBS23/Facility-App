// Created: 2026-04-08

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/base/exceptions.dart';

/// Service for accessing device location and geocoding.
abstract class LocationService {
  /// Gets the current position of the device.
  ///
  /// Throws [CustomException.validation] (field `location_service_disabled`
  /// or `location_permission_denied`) when location can't be obtained, so
  /// callers can tell the two causes apart and prompt accordingly.
  Future<Position> getCurrentPosition();

  /// Converts coordinates to a human-readable address.
  Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  });
}

final class LocationServiceImpl implements LocationService {
  @override
  Future<Position> getCurrentPosition() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const CustomException.validation(
        message: 'Location permission denied.',
        field: 'location_permission_denied',
      );
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const CustomException.validation(
        message: 'Location services are disabled.',
        field: 'location_service_disabled',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  @override
  Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isEmpty) return null;

    final place = placemarks.first;
    final parts = <String>[];

    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      parts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      parts.add(place.locality!);
    }

    return parts.isEmpty ? null : parts.join(', ');
  }
}
