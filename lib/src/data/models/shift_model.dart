import 'package:dart_mappable/dart_mappable.dart';

part 'shift_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftSupervisorModel with ShiftSupervisorModelMappable {
  ShiftSupervisorModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.isPrimary,
  });

  final int id;
  @MappableField(key: 'full_name')
  final String fullName;
  final String phone;
  @MappableField(key: 'is_primary')
  final int isPrimary;

  static const fromJson = ShiftSupervisorModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftFacilityModel with ShiftFacilityModelMappable {
  ShiftFacilityModel({
    required this.id,
    required this.name,
    required this.nameBn,
    required this.address,
    required this.addressBn,
    required this.supervisors,
  });

  final int id;
  final String name;
  @MappableField(key: 'name_bn')
  final String nameBn;
  final String address;
  @MappableField(key: 'address_bn')
  final String addressBn;
  final List<ShiftSupervisorModel> supervisors;

  static const fromJson = ShiftFacilityModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftTemplateModel with ShiftTemplateModelMappable {
  ShiftTemplateModel({required this.id, required this.name});

  final int id;
  final String name;

  static const fromJson = ShiftTemplateModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftAttendantModel with ShiftAttendantModelMappable {
  ShiftAttendantModel({
    required this.id,
    required this.fullName,
    this.phone,
  });

  final int id;
  @MappableField(key: 'full_name')
  final String fullName;
  final String? phone;

  static const fromJson = ShiftAttendantModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftModel with ShiftModelMappable {
  ShiftModel({
    required this.id,
    this.weeklyRosterId,
    required this.facility,
    required this.shiftTemplate,
    this.attendants = const [],
    required this.shiftDate,
    required this.startTime,
    required this.endTime,
    this.durationHours,
    required this.status,
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
  final List<ShiftAttendantModel> attendants;
  @MappableField(key: 'shift_date')
  final String shiftDate;
  @MappableField(key: 'start_time')
  final String startTime;
  @MappableField(key: 'end_time')
  final String endTime;
  @MappableField(key: 'duration_hours')
  final String? durationHours;
  final String status;
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
