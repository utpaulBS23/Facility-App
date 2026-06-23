import '../../domain/entities/visit_entity.dart';

extension VisitCheckInRequestEntityToJson on VisitCheckInRequestEntity {
  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
