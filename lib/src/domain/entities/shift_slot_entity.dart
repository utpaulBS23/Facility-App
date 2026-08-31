/// What an attendant may do next on a slot.
///
/// WHY typed: the app branches on this to decide which check-in/out flow to
/// offer. Unknown values map to [none] rather than throwing, so a newer
/// backend action never breaks the shift list — it simply offers no action.
enum SlotAction {
  checkIn('check_in'),
  checkOut('check_out'),
  completed('completed'),
  none('');

  const SlotAction(this.key);

  final String key;

  static SlotAction fromKey(String? key) => switch (key) {
    'check_in' => SlotAction.checkIn,
    'check_out' => SlotAction.checkOut,
    'completed' => SlotAction.completed,
    _ => SlotAction.none,
  };
}

class SlotFacilityEntity {
  const SlotFacilityEntity({
    required this.id,
    required this.name,
    required this.address,
  });

  final int id;
  final String name;

  /// Empty when the slots payload omits it — the address row is then hidden
  /// rather than rendered blank.
  final String address;
}

class SlotAttendanceEntity {
  const SlotAttendanceEntity({
    required this.id,
    this.checkInTime,
    this.checkOutTime,
    required this.approvalStatus,
    required this.lateByMinutes,
    this.checkInDistanceMeters,
    this.checkInSelfieUrl,
    this.checkOutSelfieUrl,
  });

  final int id;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String approvalStatus;
  final int lateByMinutes;
  final int? checkInDistanceMeters;
  final String? checkInSelfieUrl;
  final String? checkOutSelfieUrl;

  bool get isLate => lateByMinutes > 0;
}

class SlotAttendantEntity {
  const SlotAttendantEntity({
    required this.userId,
    this.assignmentId,
    required this.name,
    required this.staffCode,
    this.phoneNumber,
    required this.isSlotLead,
    required this.isMe,
    required this.action,
    this.attendance,
    this.earlyWindowOpens,
    this.lateCheckinDeadline,
    required this.isUnassigned,
    this.unassignedReason,
  });

  final int userId;

  /// `shift_assignments.id` — addresses the unassign and make-slot-lead
  /// endpoints, which take an assignment id, not a user/slot pair.
  ///
  /// WHY nullable: defensive against an older payload or a row where the
  /// backend genuinely omits it. Actions that need it stay hidden in the UI
  /// when it's absent — there is nothing to fall back to that would work.
  final int? assignmentId;
  final String name;
  final String staffCode;
  final String? phoneNumber;
  final bool isSlotLead;

  /// True on the caller's own row.
  final bool isMe;
  final SlotAction action;
  final SlotAttendanceEntity? attendance;
  final String? earlyWindowOpens;
  final String? lateCheckinDeadline;

  /// Taken off the slot — excluded from active staffing.
  final bool isUnassigned;
  final String? unassignedReason;
}

class ShiftSlotEntity {
  const ShiftSlotEntity({
    required this.shiftSlotId,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.slotStatus,
    required this.assignedCount,
    required this.maxAttendants,
    required this.checkedInCount,
    required this.checkedOutCount,
    required this.supervisorName,
    this.attendants = const [],
    this.weeklyRosterId,
  });

  final int shiftSlotId;
  final String startTime;
  final String endTime;
  final num durationHours;

  /// Raw slot state (`open`, `completed`, `partial_miss`, …). Kept as a string
  /// because the full value set is not yet documented.
  final String slotStatus;
  final int assignedCount;
  final int maxAttendants;
  final int checkedInCount;
  final int checkedOutCount;

  /// Supervisor who owns this slot. Empty when the payload omits it.
  final String supervisorName;
  final List<SlotAttendantEntity> attendants;

  /// The roster this slot belongs to — required by the assign-attendant
  /// endpoint's URL. Nullable until the shift-slots response carries it.
  final int? weeklyRosterId;

  /// Attendants still on the slot.
  List<SlotAttendantEntity> get activeAttendants => [
    for (final attendant in attendants)
      if (!attendant.isUnassigned) attendant,
  ];

  /// The caller's own row on this slot, if they are on it.
  SlotAttendantEntity? get me {
    for (final attendant in attendants) {
      if (attendant.isMe) return attendant;
    }
    return null;
  }

  bool get isMine => me != null;

  bool get hasFreeCapacity =>
      maxAttendants > 0 && assignedCount < maxAttendants;
}

/// The caller's actionable slot for the day, as decided by the backend.
class ActiveSlotEntity {
  const ActiveSlotEntity({
    required this.shiftSlotId,
    required this.startTime,
    required this.endTime,
    required this.action,
    required this.isSlotLead,
    required this.message,
    required this.supervisorName,
  });

  final int shiftSlotId;
  final String startTime;
  final String endTime;
  final SlotAction action;
  final bool isSlotLead;

  /// Backend-authored guidance (e.g. "Your shift starts soon…"). Displayed
  /// as-is — the server owns this copy.
  final String message;
  final String supervisorName;
}

class SlotSummaryEntity {
  const SlotSummaryEntity({
    required this.totalSlots,
    required this.inProgress,
    required this.open,
    required this.missed,
    required this.totalAssigned,
    required this.totalCheckedIn,
  });

  final int totalSlots;
  final int inProgress;
  final int open;
  final int missed;
  final int totalAssigned;
  final int totalCheckedIn;
}

/// One facility's shift slots for one day.
class ShiftSlotsEntity {
  const ShiftSlotsEntity({
    required this.date,
    required this.day,
    this.facility,
    this.activeSlot,
    this.slots = const [],
    this.summary,
  });

  final String date;
  final String day;
  final SlotFacilityEntity? facility;
  final ActiveSlotEntity? activeSlot;
  final List<ShiftSlotEntity> slots;
  final SlotSummaryEntity? summary;

  /// Slots the caller is personally assigned to — the attendant experience.
  List<ShiftSlotEntity> get mySlots => [
    for (final slot in slots)
      if (slot.isMine) slot,
  ];
}
