import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/entities/leave/leave_type.dart';

part 'leave_policy_model.mapper.dart';

class StringToNullableDoubleHook extends MappingHook {
  const StringToNullableDoubleHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

class LeaveTypeHook extends MappingHook {
  const LeaveTypeHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value is String) {
      return LeaveType.fromWireString(value);
    }
    return value;
  }

  @override
  Object? beforeEncode(Object? value) {
    if (value is LeaveType) {
      return value.toWireString();
    }
    return value;
  }
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LeavePolicyModel with LeavePolicyModelMappable {
  const LeavePolicyModel({
    required this.id,
    this.partnerId,
    required this.name,
    required this.leaveType,
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
  @MappableField(key: 'partner_id')
  final int? partnerId;
  final String name;
  @MappableField(key: 'leave_type', hook: LeaveTypeHook())
  final LeaveType leaveType;
  @MappableField(key: 'default_days_per_year', hook: StringToNullableDoubleHook())
  final double? defaultDaysPerYear;
  @MappableField(key: 'max_consecutive_days')
  final int? maxConsecutiveDays;
  @MappableField(key: 'requires_approval')
  final bool? requiresApproval;
  @MappableField(key: 'can_carry_forward')
  final bool? canCarryForward;
  @MappableField(key: 'max_carry_forward_days', hook: StringToNullableDoubleHook())
  final double? maxCarryForwardDays;
  @MappableField(key: 'min_notice_days')
  final int? minNoticeDays;
  final String? color;
  final String? description;
  @MappableField(key: 'is_active')
  final bool? isActive;

  static const fromJson = LeavePolicyModelMapper.fromJson;
}
