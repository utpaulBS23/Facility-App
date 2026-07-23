import 'package:dart_mappable/dart_mappable.dart';

part 'attendant_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class AttendantAssignmentModel with AttendantAssignmentModelMappable {
  AttendantAssignmentModel({
    this.assignmentType,
    this.isPrimary,
    this.isActive,
    this.assignedAt,
    this.assignedBy,
  });

  @MappableField(key: 'assignment_type')
  final String? assignmentType;
  @MappableField(key: 'is_primary')
  final bool? isPrimary;
  @MappableField(key: 'is_active')
  final bool? isActive;
  @MappableField(key: 'assigned_at')
  final String? assignedAt;
  @MappableField(key: 'assigned_by')
  final String? assignedBy;

  static const fromJson = AttendantAssignmentModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class AttendantModel with AttendantModelMappable {
  AttendantModel({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.assignment,
  });

  final int id;
  final String? name;
  final String? email;
  @MappableField(key: 'phone_number')
  final String? phoneNumber;
  final AttendantAssignmentModel? assignment;

  static const fromJson = AttendantModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class AttendantResponseModel with AttendantResponseModelMappable {
  AttendantResponseModel({required this.success, required this.data});

  final bool success;
  final List<AttendantModel> data;

  static const fromJson = AttendantResponseModelMapper.fromJson;
}
