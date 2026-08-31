import 'package:dart_mappable/dart_mappable.dart';

part 'my_attendance_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class MyAttendanceStatsModel with MyAttendanceStatsModelMappable {
  MyAttendanceStatsModel({
    this.records,
    this.supervisors,
    this.stillOnRound,
    this.daysCovered,
  });

  final int? records;
  final int? supervisors;

  @MappableField(key: 'still_on_round')
  final int? stillOnRound;

  @MappableField(key: 'days_covered')
  final int? daysCovered;

  static const fromJson = MyAttendanceStatsModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class MyAttendanceItemModel with MyAttendanceItemModelMappable {
  MyAttendanceItemModel({
    required this.userId,
    this.supervisorName,
    required this.facilityId,
    this.facilityName,
    this.date,
    this.checkInAt,
    this.checkOutAt,
    this.visitCount,
    this.hours,
  });

  @MappableField(key: 'user_id')
  final int userId;

  @MappableField(key: 'supervisor_name')
  final String? supervisorName;

  @MappableField(key: 'facility_id')
  final int facilityId;

  @MappableField(key: 'facility_name')
  final String? facilityName;

  final String? date;

  @MappableField(key: 'check_in_at')
  final String? checkInAt;

  @MappableField(key: 'check_out_at')
  final String? checkOutAt;

  @MappableField(key: 'visit_count')
  final int? visitCount;

  final double? hours;

  static const fromJson = MyAttendanceItemModelMapper.fromJson;
}
