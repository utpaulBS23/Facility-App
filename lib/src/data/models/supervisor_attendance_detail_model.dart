import 'package:dart_mappable/dart_mappable.dart';

part 'supervisor_attendance_detail_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class SupervisorAttendanceDetailModel
    with SupervisorAttendanceDetailModelMappable {
  const SupervisorAttendanceDetailModel({
    required this.userId,
    this.supervisorName,
    this.supervisorNameBn,
    this.date,
    this.checkInAt,
    this.checkOutAt,
    this.minutes,
    this.visitCount,
    this.facilitiesCount,
    this.stillOnRound,
    this.visits,
  });

  final int userId;
  final String? supervisorName;
  final String? supervisorNameBn;
  final String? date;
  final String? checkInAt;
  final String? checkOutAt;
  final int? minutes;
  final int? visitCount;
  final int? facilitiesCount;
  final bool? stillOnRound;
  final List<SupervisorVisitModel>? visits;

  static const fromJson = SupervisorAttendanceDetailModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class SupervisorVisitModel with SupervisorVisitModelMappable {
  const SupervisorVisitModel({
    this.taskId,
    this.visitId,
    this.title,
    this.titleBn,
    this.status,
    this.visitType,
    this.facilityId,
    this.facilityName,
    this.facilityNameBn,
    this.locationType,
    this.officeId,
    this.officeName,
    this.officeNameBn,
    this.address,
    this.scheduledStartTime,
    this.scheduledEndTime,
    this.checkInAt,
    this.checkInDistanceMeters,
    this.locationVerified,
    this.checkOutAt,
    this.minutes,
    this.itemsTotal,
    this.itemsCompleted,
    this.totalScore,
    this.maxScore,
    this.scorePercentage,
    this.passMark,
    this.supervisorNotes,
  });

  final int? taskId;
  final int? visitId;
  final String? title;
  final String? titleBn;
  final String? status;
  final String? visitType;
  final int? facilityId;
  final String? facilityName;
  final String? facilityNameBn;
  final String? locationType;
  final int? officeId;
  final String? officeName;
  final String? officeNameBn;
  final String? address;
  final String? scheduledStartTime;
  final String? scheduledEndTime;
  final String? checkInAt;
  final num? checkInDistanceMeters;
  final bool? locationVerified;
  final String? checkOutAt;
  final int? minutes;
  final int? itemsTotal;
  final int? itemsCompleted;
  final num? totalScore;
  final num? maxScore;
  final num? scorePercentage;
  final num? passMark;
  final String? supervisorNotes;

  static const fromJson = SupervisorVisitModelMapper.fromJson;
}
