import 'package:dart_mappable/dart_mappable.dart';
import '../../../domain/entities/leave/leave_status.dart';
import 'leave_policy_model.dart';

part 'leave_request_model.mapper.dart';

class LeaveStatusHook extends MappingHook {
  const LeaveStatusHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value is String) {
      return LeaveStatus.fromWireString(value);
    }
    return value;
  }

  @override
  Object? beforeEncode(Object? value) {
    if (value is LeaveStatus) {
      return value.toWireString();
    }
    return value;
  }
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveApplicantModel with LeaveApplicantModelMappable {
  const LeaveApplicantModel({
    required this.id,
    required this.name,
    this.email,
    this.groupName,
  });

  final int id;
  final String name;
  final String? email;
  @MappableField(key: 'group_name')
  final String? groupName;

  static const fromJson = LeaveApplicantModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveApprovalStepModel with LeaveApprovalStepModelMappable {
  const LeaveApprovalStepModel({
    required this.stepNumber,
    required this.approverRole,
    required this.status,
    this.approver,
    this.decidedAt,
    this.rejectionNote,
  });

  @MappableField(key: 'step_number')
  final int stepNumber;
  @MappableField(key: 'approver_role')
  final String approverRole;
  @MappableField(hook: LeaveStatusHook())
  final LeaveStatus status;
  final LeaveApplicantModel? approver;
  @MappableField(key: 'decided_at')
  final String? decidedAt;
  @MappableField(key: 'rejection_note')
  final String? rejectionNote;

  static const fromJson = LeaveApprovalStepModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveShiftDetailModel with LeaveShiftDetailModelMappable {
  const LeaveShiftDetailModel({
    required this.id,
    required this.facilityId,
    required this.facilityName,
    required this.shiftDate,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  final int id;
  @MappableField(key: 'facility_id')
  final int facilityId;
  @MappableField(key: 'facility_name')
  final String facilityName;
  @MappableField(key: 'shift_date')
  final String shiftDate;
  @MappableField(key: 'shift_name')
  final String shiftName;
  @MappableField(key: 'start_time')
  final String startTime;
  @MappableField(key: 'end_time')
  final String endTime;
  final String status;

  static const fromJson = LeaveShiftDetailModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveRequestModel with LeaveRequestModelMappable {
  const LeaveRequestModel({
    required this.id,
    required this.partnerId,
    required this.referenceCode,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    required this.leaveType,
    required this.status,
    required this.createdAt,
    this.applicant,
    this.createdBy,
    this.leavePolicy,
    this.reason,
    this.coverAttendant,
    this.attachments = const [],
    this.currentStep,
    this.canAction,
    this.shifts = const [],
    this.approvalSteps = const [],
    this.updatedAt,
  });

  final int id;
  @MappableField(key: 'partner_id')
  final int partnerId;
  @MappableField(key: 'reference_code')
  final String referenceCode;
  @MappableField(key: 'start_date')
  final String startDate;
  @MappableField(key: 'end_date')
  final String endDate;
  @MappableField(key: 'days_count')
  final int daysCount;
  @MappableField(key: 'leave_type')
  final String leaveType;
  @MappableField(hook: LeaveStatusHook())
  final LeaveStatus status;
  @MappableField(key: 'created_at')
  final String createdAt;
  final LeaveApplicantModel? applicant;
  @MappableField(key: 'created_by')
  final LeaveApplicantModel? createdBy;
  @MappableField(key: 'leave_policy')
  final LeavePolicyModel? leavePolicy;
  final String? reason;
  @MappableField(key: 'cover_attendant')
  final LeaveApplicantModel? coverAttendant;
  final List<String> attachments;
  @MappableField(key: 'current_step')
  final int? currentStep;
  @MappableField(key: 'can_action')
  final bool? canAction;
  final List<LeaveShiftDetailModel> shifts;
  @MappableField(key: 'approval_steps')
  final List<LeaveApprovalStepModel> approvalSteps;
  @MappableField(key: 'updated_at')
  final String? updatedAt;

  static const fromJson = LeaveRequestModelMapper.fromJson;
}
