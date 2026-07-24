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
    this.phone,
    required this.isPrimary,
  });

  final int id;
  final String fullName;
  final String? phone;
  final bool isPrimary;
}

/// One attendant's assignment to a shift slot.
class ShiftAssignmentEntity {
  const ShiftAssignmentEntity({
    required this.id,
    required this.attendant,
    required this.isSlotLead,
    this.assignedAt,
    this.unassignedAt,
    this.unassignedReason,
  });

  final int id;
  final ShiftAttendantEntity attendant;
  final bool isSlotLead;
  final String? assignedAt;
  final String? unassignedAt;
  final String? unassignedReason;

  /// WHY: the backend keeps unassigned rows with `unassigned_at` set, so a
  /// non-null value means this person is no longer on the slot and must not
  /// be counted as assigned.
  bool get isActive => unassignedAt == null;
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
    this.weeklyRosterId,
    required this.shiftTemplateId,
    required this.facility,
    required this.shiftTemplateName,
    required this.shiftDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.notes,
    this.assignments = const [],
    this.attendant,
    this.isSlotLead = false,
    this.minAttendants = 0,
    this.maxAttendants = 0,
    this.assignedCount = 0,
    this.checkedInCount = 0,
    this.checkedOutCount = 0,
    this.slotStatus = '',
  });

  final int id;
  final int? weeklyRosterId;
  final int shiftTemplateId;
  final ShiftFacilityEntity facility;
  final String shiftTemplateName;
  final String shiftDate;
  final String startTime;
  final String endTime;
  final String status;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? notes;

  /// Staffing as reported by the supervisor endpoint.
  final List<ShiftAssignmentEntity> assignments;

  /// The logged-in attendant on their own shift (attendant endpoint only).
  final ShiftAttendantEntity? attendant;

  /// Whether the logged-in attendant leads this slot (attendant endpoint only).
  final bool isSlotLead;

  /// Slot capacity, reported by the supervisor endpoint only. Defaults to 0
  /// on the attendant endpoint, which does not send these.
  final int minAttendants;
  final int maxAttendants;

  /// WHY: the backend's own count, kept rather than derived from
  /// [assignments] — the two can disagree (e.g. if the list is paginated or
  /// filtered server-side), and the backend's figure is authoritative.
  final int assignedCount;
  final int checkedInCount;
  final int checkedOutCount;

  /// Raw slot state (e.g. `open`). Kept as a string because the full value set
  /// is not yet known — promote to an enum once the backend documents it.
  final String slotStatus;

  /// Attendants currently on the slot — excludes unassigned rows.
  List<ShiftAttendantEntity> get assignedAttendants => [
    for (final assignment in assignments)
      if (assignment.isActive) assignment.attendant,
  ];

  /// Whether the slot has room for another attendant.
  bool get hasFreeCapacity =>
      maxAttendants > 0 && assignedCount < maxAttendants;

  /// Whether the slot has met its minimum staffing requirement.
  bool get isMinimumStaffed => assignedCount >= minAttendants;
}

class RosterFacilityEntity {
  const RosterFacilityEntity({
    required this.id,
    required this.name,
    this.nameBn,
  });

  final int id;
  final String name;
  final String? nameBn;
}

class RosterCreatorEntity {
  const RosterCreatorEntity({
    required this.id,
    required this.fullName,
    required this.role,
  });

  final int id;
  final String fullName;
  final String role;
}

class RosterEntity {
  const RosterEntity({
    required this.id,
    required this.facilityId,
    this.facility,
    this.createdBy,
    required this.weekStartDate,
    required this.weekEndDate,
    required this.status,
    this.publishedAt,
    this.totalShifts = 0,
    this.filledShifts = 0,
    this.notes,
    this.offDays = const [],
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int facilityId;
  final RosterFacilityEntity? facility;
  final RosterCreatorEntity? createdBy;
  final String weekStartDate;
  final String weekEndDate;
  final String status;
  final String? publishedAt;
  final int totalShifts;
  final int filledShifts;
  final String? notes;
  final List<int> offDays;
  final String? createdAt;
  final String? updatedAt;
}

class RosterListEntity {
  const RosterListEntity({
    required this.rosters,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final List<RosterEntity> rosters;
  final int currentPage;
  final int lastPage;
  final int total;
}

class RosterShiftStatsEntity {
  const RosterShiftStatsEntity({
    this.totalShifts = 0,
    this.assignedShifts = 0,
    this.unassignedShifts = 0,
  });

  final int totalShifts;
  final int assignedShifts;
  final int unassignedShifts;
}

class RosterShiftsEntity {
  const RosterShiftsEntity({required this.shifts, required this.stats});

  final List<ShiftEntity> shifts;
  final RosterShiftStatsEntity stats;
}
