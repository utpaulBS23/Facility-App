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
    required this.supervisors,
  });

  final int id;
  final String name;
  final String address;
  final List<ShiftSupervisorEntity> supervisors;

  ShiftSupervisorEntity? get primarySupervisor =>
      supervisors.where((s) => s.isPrimary).firstOrNull ??
      supervisors.firstOrNull;
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
}
