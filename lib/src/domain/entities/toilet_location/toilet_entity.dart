import 'toilet_status.dart';

class ToiletEntity {
  const ToiletEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.status,
    required this.averageRating,
    required this.lat,
    required this.lng,
    required this.mapsLink,
    this.facilityType = '',
    this.supervisorName = '',
    this.openingTime,
    this.closingTime,
    this.is24Hours = false,
    this.operatingDays = const [],
    this.isFree = false,
    this.usageFee = 0,
    this.disableFriendly = false,
    this.visitsToday = 0,
    this.revenue = 0,
  });

  final int id;
  final String name;
  final String address;
  final ToiletStatus status;
  final double averageRating;
  final double lat;
  final double lng;
  final String mapsLink;
  final String facilityType;
  final String supervisorName;

  /// `HH:mm:ss`, as sent.
  final String? openingTime;
  final String? closingTime;
  final bool is24Hours;

  /// Lower-case weekday keys such as `sat`, `sun`.
  final List<String> operatingDays;
  final bool isFree;
  final num usageFee;
  final bool disableFriendly;
  final int visitsToday;
  final num revenue;
}

class ToiletSummaryEntity {
  const ToiletSummaryEntity({this.total = 0, this.active = 0});

  final int total;
  final int active;
}
