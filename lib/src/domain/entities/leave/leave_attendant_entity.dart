import 'shift_status.dart';

class LeaveAttendantShiftEntity {
  const LeaveAttendantShiftEntity({
    required this.id,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  final int id;
  final String shiftName;
  final String startTime;
  final String endTime;
  final ShiftStatus status;
}

class LeaveAttendantEntity {
  const LeaveAttendantEntity({
    required this.id,
    required this.uid,
    required this.name,
    required this.facilityId,
    required this.facilityName,
    this.shift,
  });

  final int id;
  final String uid;
  final String name;
  final int facilityId;
  final String facilityName;
  final LeaveAttendantShiftEntity? shift;
}
