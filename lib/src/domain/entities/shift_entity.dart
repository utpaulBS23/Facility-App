class ShiftAttendantEntity {
  const ShiftAttendantEntity({
    required this.id,
    required this.fullName,
    this.phone,
  });

  final int id;
  final String fullName;
  final String? phone;
}

class ShiftSupervisorEntity {
  const ShiftSupervisorEntity({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.isPrimary,
  });

  final int id;
  final String fullName;
  final String phone;
  final bool isPrimary;
}

class ShiftFacilityEntity {
  const ShiftFacilityEntity({
    required this.id,
    required this.name,
    required this.address,
    this.supervisor,
  });

  final int id;
  final String name;
  final String address;
  final ShiftSupervisorEntity? supervisor;
}

class ShiftEntity {
  const ShiftEntity({
    required this.id,
    required this.facility,
    required this.shiftTemplateName,
    required this.shiftDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.notes,
    this.attendants = const [],
  });

  final int id;
  final ShiftFacilityEntity facility;
  final String shiftTemplateName;
  final String shiftDate;
  final String startTime;
  final String endTime;
  final String status;
  final String? checkInTime;
  final String? checkOutTime;
  final String? notes;
  final List<ShiftAttendantEntity> attendants;
}
