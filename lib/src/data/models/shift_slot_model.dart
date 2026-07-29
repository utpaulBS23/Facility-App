import 'package:dart_mappable/dart_mappable.dart';

part 'shift_slot_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class SlotFacilityModel with SlotFacilityModelMappable {
  SlotFacilityModel({required this.id, this.name, this.address});

  final int id;
  final String? name;
  final String? address;

  static const fromJson = SlotFacilityModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class SlotAttendanceModel with SlotAttendanceModelMappable {
  SlotAttendanceModel({
    required this.id,
    this.checkInTime,
    this.checkOutTime,
    this.approvalStatus,
    this.lateByMinutes,
    this.checkInDistanceMeters,
    this.checkInSelfieUrl,
    this.checkOutSelfieUrl,
  });

  final int id;
  @MappableField(key: 'check_in_time')
  final String? checkInTime;
  @MappableField(key: 'check_out_time')
  final String? checkOutTime;
  @MappableField(key: 'approval_status')
  final String? approvalStatus;
  @MappableField(key: 'late_by_minutes')
  final int? lateByMinutes;
  @MappableField(key: 'check_in_distance_meters')
  final int? checkInDistanceMeters;
  @MappableField(key: 'check_in_selfie_url')
  final String? checkInSelfieUrl;
  @MappableField(key: 'check_out_selfie_url')
  final String? checkOutSelfieUrl;

  static const fromJson = SlotAttendanceModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class SlotAttendantModel with SlotAttendantModelMappable {
  SlotAttendantModel({
    required this.userId,
    this.name,
    this.staffCode,
    this.isSlotLead,
    this.isMe,
    this.action,
    this.attendance,
    this.earlyWindowOpens,
    this.lateCheckinDeadline,
    this.unassigned,
    this.unassignedReason,
  });

  @MappableField(key: 'user_id')
  final int userId;
  final String? name;
  @MappableField(key: 'staff_code')
  final String? staffCode;
  @MappableField(key: 'is_slot_lead')
  final bool? isSlotLead;

  /// Marks the caller's own row within the slot.
  @MappableField(key: 'is_me')
  final bool? isMe;

  /// What this person may do next (`check_in`, `completed`, …); null when no
  /// action is available to them.
  final String? action;
  final SlotAttendanceModel? attendance;

  // Only present while a check-in window is relevant.
  @MappableField(key: 'early_window_opens')
  final String? earlyWindowOpens;
  @MappableField(key: 'late_checkin_deadline')
  final String? lateCheckinDeadline;

  // Only present once someone has been taken off the slot.
  final bool? unassigned;
  @MappableField(key: 'unassigned_reason')
  final String? unassignedReason;

  static const fromJson = SlotAttendantModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftSlotModel with ShiftSlotModelMappable {
  ShiftSlotModel({
    required this.shiftSlotId,
    this.startTime,
    this.endTime,
    this.durationHours,
    this.slotStatus,
    this.assignedCount,
    this.maxAttendants,
    this.checkedInCount,
    this.checkedOutCount,
    this.supervisorName,
    this.attendants = const [],
    this.weeklyRosterId,
  });

  @MappableField(key: 'shift_slot_id')
  final int shiftSlotId;
  @MappableField(key: 'start_time')
  final String? startTime;
  @MappableField(key: 'end_time')
  final String? endTime;
  @MappableField(key: 'duration_hours')
  final num? durationHours;
  @MappableField(key: 'slot_status')
  final String? slotStatus;
  @MappableField(key: 'assigned_count')
  final int? assignedCount;
  @MappableField(key: 'max_attendants')
  final int? maxAttendants;
  @MappableField(key: 'checked_in_count')
  final int? checkedInCount;
  @MappableField(key: 'checked_out_count')
  final int? checkedOutCount;
  @MappableField(key: 'supervisor_name')
  final String? supervisorName;
  final List<SlotAttendantModel> attendants;
  @MappableField(key: 'roster_id')
  final int? weeklyRosterId;

  static const fromJson = ShiftSlotModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ActiveSlotModel with ActiveSlotModelMappable {
  ActiveSlotModel({
    required this.shiftSlotId,
    this.startTime,
    this.endTime,
    this.action,
    this.isSlotLead,
    this.message,
  });

  @MappableField(key: 'shift_slot_id')
  final int shiftSlotId;
  @MappableField(key: 'start_time')
  final String? startTime;
  @MappableField(key: 'end_time')
  final String? endTime;
  final String? action;
  @MappableField(key: 'is_slot_lead')
  final bool? isSlotLead;
  final String? message;

  static const fromJson = ActiveSlotModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class SlotSummaryModel with SlotSummaryModelMappable {
  SlotSummaryModel({
    this.totalSlots,
    this.inProgress,
    this.open,
    this.missed,
    this.totalAssigned,
    this.totalCheckedIn,
  });

  @MappableField(key: 'total_slots')
  final int? totalSlots;
  @MappableField(key: 'in_progress')
  final int? inProgress;
  final int? open;
  final int? missed;
  @MappableField(key: 'total_assigned')
  final int? totalAssigned;
  @MappableField(key: 'total_checked_in')
  final int? totalCheckedIn;

  static const fromJson = SlotSummaryModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftSlotsDataModel with ShiftSlotsDataModelMappable {
  ShiftSlotsDataModel({
    this.date,
    this.day,
    this.facility,
    this.activeSlot,
    this.slots = const [],
    this.summary,
  });

  final String? date;
  final String? day;
  final SlotFacilityModel? facility;
  @MappableField(key: 'active_slot')
  final ActiveSlotModel? activeSlot;
  final List<ShiftSlotModel> slots;
  final SlotSummaryModel? summary;

  static const fromJson = ShiftSlotsDataModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftSlotsResponseModel with ShiftSlotsResponseModelMappable {
  ShiftSlotsResponseModel({required this.success, this.message, this.data});

  final bool success;
  final String? message;
  final ShiftSlotsDataModel? data;

  static const fromJson = ShiftSlotsResponseModelMapper.fromJson;
}
