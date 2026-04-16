// Created: 2026-04-08

/// Represents the current location information.
interface class LocationEntity {}

/// Response entity containing the formatted address of current location.
class LocationResponseEntity extends LocationEntity {
  LocationResponseEntity({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final String address;
  final double latitude;
  final double longitude;
}
