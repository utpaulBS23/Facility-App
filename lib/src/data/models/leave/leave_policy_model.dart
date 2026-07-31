import 'package:dart_mappable/dart_mappable.dart';

part 'leave_policy_model.mapper.dart';

class StringToNullableDoubleHook extends MappingHook {
  const StringToNullableDoubleHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeavePolicyModel with LeavePolicyModelMappable {
  const LeavePolicyModel({
    required this.id,
    this.partnerId,
    required this.name,
    this.leaveType,
    this.defaultDaysPerYear,
    this.maxConsecutiveDays,
    this.requiresApproval,
    this.canCarryForward,
    this.maxCarryForwardDays,
    this.minNoticeDays,
    this.color,
    this.description,
    this.isActive,
  });

  final int id;
  final int? partnerId;
  final String name;
  final String? leaveType;
  @MappableField(hook: StringToNullableDoubleHook())
  final double? defaultDaysPerYear;
  final int? maxConsecutiveDays;
  final bool? requiresApproval;
  final bool? canCarryForward;
  @MappableField(hook: StringToNullableDoubleHook())
  final double? maxCarryForwardDays;
  final int? minNoticeDays;
  final String? color;
  final String? description;
  final bool? isActive;

  static const fromJson = LeavePolicyModelMapper.fromJson;
}
