import 'package:dart_mappable/dart_mappable.dart';
import 'leave_policy_model.dart';

part 'leave_request_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveApplicantModel with LeaveApplicantModelMappable {
  const LeaveApplicantModel({
    required this.id,
    this.name,
    this.email,
    this.groupName,
  });

  final int id;
  final String? name;
  final String? email;
  @MappableField(key: 'group_name')
  final String? groupName;

  static const fromJson = LeaveApplicantModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveApprovalStepModel with LeaveApprovalStepModelMappable {
  const LeaveApprovalStepModel({
    this.stepNumber,
    this.approverRole,
    this.approver,
    this.status,
    this.decidedAt,
    this.rejectionNote,
  });

  @MappableField(key: 'step_number')
  final int? stepNumber;
  @MappableField(key: 'approver_role')
  final String? approverRole;
  final LeaveApplicantModel? approver;
  final String? status;
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
    this.shiftDate,
    this.shiftName,
    this.startTime,
    this.endTime,
    this.facilityId,
    this.facilityName,
    this.status,
  });

  final int id;
  @MappableField(key: 'shift_date')
  final String? shiftDate;
  @MappableField(key: 'shift_name')
  final String? shiftName;
  @MappableField(key: 'start_time')
  final String? startTime;
  @MappableField(key: 'end_time')
  final String? endTime;
  @MappableField(key: 'facility_id')
  final int? facilityId;
  @MappableField(key: 'facility_name')
  final String? facilityName;
  final String? status;

  static const fromJson = LeaveShiftDetailModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveRequestModel with LeaveRequestModelMappable {
  const LeaveRequestModel({
    required this.id,
    this.referenceCode,
    this.partnerId,
    this.applicant,
    this.createdBy,
    this.leavePolicy,
    this.startDate,
    this.endDate,
    this.daysCount,
    this.leaveType,
    this.reason,
    this.coverAttendant,
    this.attachments = const [],
    this.status,
    this.currentStep,
    this.canAction,
    this.shifts = const [],
    this.approvalSteps = const [],
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  @MappableField(key: 'reference_code')
  final String? referenceCode;
  @MappableField(key: 'partner_id')
  final int? partnerId;
  final LeaveApplicantModel? applicant;
  @MappableField(key: 'created_by')
  final LeaveApplicantModel? createdBy;
  @MappableField(key: 'leave_policy')
  final LeavePolicyModel? leavePolicy;
  @MappableField(key: 'start_date')
  final String? startDate;
  @MappableField(key: 'end_date')
  final String? endDate;
  @MappableField(key: 'days_count')
  final int? daysCount;
  @MappableField(key: 'leave_type')
  final String? leaveType;
  final String? reason;
  @MappableField(key: 'cover_attendant')
  final LeaveApplicantModel? coverAttendant;
  final List<String> attachments;
  final String? status;
  @MappableField(key: 'current_step')
  final int? currentStep;
  @MappableField(key: 'can_action')
  final bool? canAction;
  final List<LeaveShiftDetailModel> shifts;
  @MappableField(key: 'approval_steps')
  final List<LeaveApprovalStepModel> approvalSteps;
  @MappableField(key: 'created_at')
  final String? createdAt;
  @MappableField(key: 'updated_at')
  final String? updatedAt;

  static const fromJson = LeaveRequestModelMapper.fromJson;
}
