import 'package:dart_mappable/dart_mappable.dart';

part 'shift_template_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftTemplateDataModel with ShiftTemplateDataModelMappable {
  ShiftTemplateDataModel({
    required this.id,
    this.partnerId,
    this.name,
    this.startTime,
    this.endTime,
    this.durationHours,
    this.isActive,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @MappableField(key: 'partner_id')
  final int? partnerId;
  final String? name;
  @MappableField(key: 'start_time')
  final String? startTime;
  @MappableField(key: 'end_time')
  final String? endTime;
  @MappableField(key: 'duration_hours')
  final String? durationHours;
  @MappableField(key: 'is_active')
  final bool? isActive;
  final String? notes;
  @MappableField(key: 'created_at')
  final String? createdAt;
  @MappableField(key: 'updated_at')
  final String? updatedAt;

  static const fromJson = ShiftTemplateDataModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class ShiftTemplateListResponseModel
    with ShiftTemplateListResponseModelMappable {
  ShiftTemplateListResponseModel({
    required this.success,
    this.message,
    this.data = const [],
  });

  final bool success;
  final String? message;
  final List<ShiftTemplateDataModel> data;

  static const fromJson = ShiftTemplateListResponseModelMapper.fromJson;
}
