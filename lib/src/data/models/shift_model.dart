import 'package:dart_mappable/dart_mappable.dart';

part 'shift_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftSupervisorModel with ShiftSupervisorModelMappable {
  ShiftSupervisorModel({
    required this.id,
    this.fullName,
    this.phone,
    this.isPrimary,
  });

  final int id;
  // WHY: supervisor objects use `name`/`phone_number`, unlike the attendant
  // objects in the same payload which use `full_name`/`phone`.
  @MappableField(key: 'name')
  final String? fullName;
  @MappableField(key: 'phone_number')
  final String? phone;
  @MappableField(key: 'is_primary')
  final bool? isPrimary;

  static const fromJson = ShiftSupervisorModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftFacilityModel with ShiftFacilityModelMappable {
  ShiftFacilityModel({
    required this.id,
    this.name,
    this.nameBn,
    this.address,
    this.addressBn,
    this.supervisor,
  });

  final int id;
  final String? name;
  @MappableField(key: 'name_bn')
  final String? nameBn;
  final String? address;
  @MappableField(key: 'address_bn')
  final String? addressBn;
  final ShiftSupervisorModel? supervisor;

  static const fromJson = ShiftFacilityModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftTemplateModel with ShiftTemplateModelMappable {
  ShiftTemplateModel({required this.id, this.name});

  final int id;
  final String? name;

  static const fromJson = ShiftTemplateModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftAttendantModel with ShiftAttendantModelMappable {
  ShiftAttendantModel({
    required this.id,
    this.fullName,
    this.phone,
  });

  final int id;
  @MappableField(key: 'full_name')
  final String? fullName;
  final String? phone;

  static const fromJson = ShiftAttendantModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftAssignmentModel with ShiftAssignmentModelMappable {
  ShiftAssignmentModel({
    required this.id,
    this.attendant,
    this.isSlotLead,
    this.assignedAt,
    this.unassignedAt,
    this.unassignedReason,
  });

  final int id;
  final ShiftAttendantModel? attendant;
  @MappableField(key: 'is_slot_lead')
  final bool? isSlotLead;
  @MappableField(key: 'assigned_at')
  final String? assignedAt;
  @MappableField(key: 'unassigned_at')
  final String? unassignedAt;
  @MappableField(key: 'unassigned_reason')
  final String? unassignedReason;

  static const fromJson = ShiftAssignmentModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftModel with ShiftModelMappable {
  ShiftModel({
    required this.id,
    this.weeklyRosterId,
    required this.facility,
    required this.shiftTemplate,
    this.assignments = const [],
    this.attendant,
    this.isSlotLead,
    this.minAttendants,
    this.maxAttendants,
    this.assignedCount,
    this.checkedInCount,
    this.checkedOutCount,
    this.slotStatus,
    required this.shiftDate,
    required this.startTime,
    required this.endTime,
    this.durationHours,
    this.status,
    this.checkInTime,
    this.checkOutTime,
    this.actualDuration,
    this.isOvertime,
    this.notes,
  });

  final int id;
  @MappableField(key: 'weekly_roster_id')
  final int? weeklyRosterId;
  final ShiftFacilityModel facility;
  @MappableField(key: 'shift_template')
  final ShiftTemplateModel shiftTemplate;

  // WHY: the two shift endpoints report staffing differently. The supervisor
  // endpoint (`manage-shifts`) sends `assignments: [...]`; the attendant
  // endpoint (`my-shifts`) sends a singular `attendant` plus a top-level
  // `is_slot_lead`. Neither ever sends `attendants`, which is what this model
  // used to read — so the assigned list was always empty.
  final List<ShiftAssignmentModel> assignments;
  final ShiftAttendantModel? attendant;
  @MappableField(key: 'is_slot_lead')
  final bool? isSlotLead;

  // Slot capacity — supervisor endpoint only.
  @MappableField(key: 'min_attendants')
  final int? minAttendants;
  @MappableField(key: 'max_attendants')
  final int? maxAttendants;
  @MappableField(key: 'assigned_count')
  final int? assignedCount;
  @MappableField(key: 'checked_in_count')
  final int? checkedInCount;
  @MappableField(key: 'checked_out_count')
  final int? checkedOutCount;
  @MappableField(key: 'slot_status')
  final String? slotStatus;
  @MappableField(key: 'shift_date')
  final String shiftDate;
  @MappableField(key: 'start_time')
  final String startTime;
  @MappableField(key: 'end_time')
  final String endTime;
  @MappableField(key: 'duration_hours')
  final String? durationHours;
  final String? status;
  @MappableField(key: 'check_in_time')
  final String? checkInTime;
  @MappableField(key: 'check_out_time')
  final String? checkOutTime;
  @MappableField(key: 'actual_duration')
  final String? actualDuration;
  @MappableField(key: 'is_overtime')
  final bool? isOvertime;
  final String? notes;

  static const fromJson = ShiftModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftResponseModel with ShiftResponseModelMappable {
  ShiftResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<ShiftModel> data;

  static const fromJson = ShiftResponseModelMapper.fromJson;
}
