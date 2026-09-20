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
  });

  final int id;
  final String name;
  final String address;
  final ToiletStatus status;
  final double averageRating;
  final double lat;
  final double lng;
  final String mapsLink;
}

class ToiletSummaryEntity {
  const ToiletSummaryEntity({this.total = 0, this.active = 0});

  final int total;
  final int active;
}
