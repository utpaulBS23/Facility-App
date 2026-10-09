import 'package:dart_mappable/dart_mappable.dart';

part 'shift_slot_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class SlotFacilityModel with SlotFacilityModelMappable {
  SlotFacilityModel({required this.id, this.name, this.nameBn, this.address});

  final int id;
  final String? name;
  @MappableField(key: 'name_bn')
  final String? nameBn;
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
    this.isLate,
    this.lateCheckInByMinutes,
    this.checkInDistanceMeters,
    this.checkInSelfieUrl,
    this.checkOutSelfieUrl,
    this.lateCheckInReason,
    this.checkOutReason,
    this.lateCheckOutByMinutes,
    this.checkInReviewedBy,
    this.checkInReviewerName,
    this.checkInReviewerNameBn,
    this.checkInReviewedAt,
    this.checkOutReviewedBy,
    this.checkOutReviewerName,
    this.checkOutReviewerNameBn,
    this.checkOutReviewedAt,
  });

  final int id;
  @MappableField(key: 'check_in_time')
  final String? checkInTime;
  @MappableField(key: 'check_out_time')
  final String? checkOutTime;
  @MappableField(key: 'approval_status')
  final String? approvalStatus;
  @MappableField(key: 'is_late')
  final bool? isLate;
  @MappableField(key: 'late_check_in_by_minutes')
  final int? lateCheckInByMinutes;
  @MappableField(key: 'check_in_distance_meters')
  final int? checkInDistanceMeters;
  @MappableField(key: 'check_in_selfie_url')
  final String? checkInSelfieUrl;
  @MappableField(key: 'check_out_selfie_url')
  final String? checkOutSelfieUrl;
  @MappableField(key: 'late_check_in_reason')
  final String? lateCheckInReason;
  @MappableField(key: 'check_out_reason')
  final String? checkOutReason;
  @MappableField(key: 'late_check_out_by_minutes')
  final int? lateCheckOutByMinutes;
  @MappableField(key: 'check_in_reviewed_by')
  final int? checkInReviewedBy;
  @MappableField(key: 'check_in_reviewer_name')
  final String? checkInReviewerName;
  @MappableField(key: 'check_in_reviewer_name_bn')
  final String? checkInReviewerNameBn;
  @MappableField(key: 'check_in_reviewed_at')
  final String? checkInReviewedAt;
  @MappableField(key: 'check_out_reviewed_by')
  final int? checkOutReviewedBy;
  @MappableField(key: 'check_out_reviewer_name')
  final String? checkOutReviewerName;
  @MappableField(key: 'check_out_reviewer_name_bn')
  final String? checkOutReviewerNameBn;
  @MappableField(key: 'check_out_reviewed_at')
  final String? checkOutReviewedAt;

  static const fromJson = SlotAttendanceModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class SlotAttendantModel with SlotAttendantModelMappable {
  SlotAttendantModel({
    required this.userId,
    this.shiftAssignmentId,
    this.name,
    this.nameBn,
    this.staffCode,
    this.phoneNumber,
    this.phone,
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
  @MappableField(key: 'shift_assignment_id')
  final int? shiftAssignmentId;
  final String? name;
  @MappableField(key: 'name_bn')
  final String? nameBn;
  @MappableField(key: 'staff_code')
  final String? staffCode;
  @MappableField(key: 'phone_number')
  final String? phoneNumber;
  final String? phone;
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
    this.supervisorNameBn,
    this.attendants = const [],
    this.weeklyRosterId,
    this.checkInWindowAfterMinutes,
    this.checkOutWindowAfterMinutes,
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
  @MappableField(key: 'supervisor_name_bn')
  final String? supervisorNameBn;
  final List<SlotAttendantModel> attendants;
  @MappableField(key: 'roster_id')
  final int? weeklyRosterId;

  /// Grace periods: a check-in later than start plus this, or a check-out
  /// later than end plus this, is late and needs a reason.
  @MappableField(key: 'check_in_window_after_minutes')
  final int? checkInWindowAfterMinutes;
  @MappableField(key: 'check_out_window_after_minutes')
  final int? checkOutWindowAfterMinutes;

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
    this.supervisorName,
    this.supervisorNameBn,
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
  @MappableField(key: 'supervisor_name')
  final String? supervisorName;
  @MappableField(key: 'supervisor_name_bn')
  final String? supervisorNameBn;

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
class ShiftSlotsFacilityModel with ShiftSlotsFacilityModelMappable {
  ShiftSlotsFacilityModel({
    required this.facilityId,
    this.facilityName,
    this.facilityNameBn,
    this.slots = const [],
    this.isPrimary = false,
    this.isRelief = false,
  });

  @MappableField(key: 'facility_id')
  final int facilityId;
  @MappableField(key: 'facility_name')
  final String? facilityName;
  @MappableField(key: 'facility_name_bn')
  final String? facilityNameBn;
  final List<ShiftSlotModel> slots;
  @MappableField(key: 'is_primary')
  final bool isPrimary;
  @MappableField(key: 'is_relief')
  final bool isRelief;

  static const fromJson = ShiftSlotsFacilityModelMapper.fromJson;
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
    this.facilities = const [],
  });

  final String? date;
  final String? day;
  final SlotFacilityModel? facility;
  @MappableField(key: 'active_slot')
  final ActiveSlotModel? activeSlot;
  final List<ShiftSlotModel> slots;
  final SlotSummaryModel? summary;
  final List<ShiftSlotsFacilityModel> facilities;

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
