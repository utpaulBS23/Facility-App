// Author: Claude AI Assistant
// Created: 2026-04-08

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Service for accessing device location and geocoding.
abstract class LocationService {
  /// Gets the current position of the device.
  Future<Position?> getCurrentPosition();

  /// Converts coordinates to a human-readable address.
  Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  });
}

final class LocationServiceImpl implements LocationService {
  @override
  Future<Position?> getCurrentPosition() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
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
