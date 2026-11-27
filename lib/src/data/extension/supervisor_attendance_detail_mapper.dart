import '../../domain/entities/supervisor_attendance_detail_entity.dart';
import '../models/supervisor_attendance_detail_model.dart';
import 'date_time_parser.dart';

extension SupervisorAttendanceDetailModelToEntity
    on SupervisorAttendanceDetailModel {
  SupervisorAttendanceDetailEntity toEntity() =>
      SupervisorAttendanceDetailEntity(
        userId: userId,
        supervisorName: supervisorName ?? '',
        supervisorNameBn: supervisorNameBn ?? '',
        date: date ?? '',
        checkInAt: parseLocalIso(checkInAt),
        checkOutAt: parseLocalIso(checkOutAt),
        minutes: minutes,
        visitCount: visitCount ?? visits?.length ?? 0,
        facilitiesCount: facilitiesCount ?? 0,
        stillOnRound: stillOnRound ?? false,
        visits: (visits ?? const <SupervisorVisitModel>[])
            .map((visit) => visit.toEntity())
            .toList(),
      );
}

extension SupervisorVisitModelToEntity on SupervisorVisitModel {
  SupervisorVisitEntity toEntity() => SupervisorVisitEntity(
    taskId: taskId,
    visitId: visitId,
    title: title ?? '',
    titleBn: titleBn ?? '',
    status: status,
    visitType: visitType,
    facilityId: facilityId,
    facilityName: facilityName ?? '',
    facilityNameBn: facilityNameBn ?? '',
    locationType: locationType,
    officeName: officeName,
    officeNameBn: officeNameBn ?? '',
    address: address,
    scheduledStart: parseLocalIso(scheduledStartTime),
    scheduledEnd: parseLocalIso(scheduledEndTime),
    checkInAt: parseLocalIso(checkInAt),
    checkInDistanceMeters: checkInDistanceMeters,
    locationVerified: locationVerified,
    checkOutAt: parseLocalIso(checkOutAt),
    minutes: minutes,
    itemsTotal: itemsTotal,
    itemsCompleted: itemsCompleted,
    totalScore: totalScore,
    maxScore: maxScore,
    scorePercentage: scorePercentage,
    passMark: passMark,
    supervisorNotes: supervisorNotes,
  );
}
