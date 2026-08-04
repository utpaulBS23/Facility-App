import 'package:dart_mappable/dart_mappable.dart';

import 'leave_policy_model.dart';

part 'leave_request_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
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
  final String? groupName;

  static const fromJson = LeaveApplicantModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeaveApprovalStepModel with LeaveApprovalStepModelMappable {
  const LeaveApprovalStepModel({
    required this.stepNumber,
    required this.approverRole,
    this.status,
    this.approver,
    this.decidedAt,
    this.rejectionNote,
  });

  final int stepNumber;
  final String approverRole;
  final String? status;
  final LeaveApplicantModel? approver;
  final String? decidedAt;
  final String? rejectionNote;

  static const fromJson = LeaveApprovalStepModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeaveShiftDetailModel with LeaveShiftDetailModelMappable {
  const LeaveShiftDetailModel({
    required this.id,
    required this.facilityId,
    required this.facilityName,
    required this.shiftDate,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    this.status,
  });

  final int id;
  final int facilityId;
  final String facilityName;
  final String shiftDate;
  final String shiftName;
  final String startTime;
  final String endTime;
  final String? status;

  static const fromJson = LeaveShiftDetailModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeaveRequestModel with LeaveRequestModelMappable {
  const LeaveRequestModel({
    required this.id,
    required this.partnerId,
    required this.referenceCode,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    this.leaveType,
    this.status,
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
  final int partnerId;
  final String referenceCode;
  final String startDate;
  final String endDate;
  final int daysCount;
  final String? leaveType;
  final String? status;
  final String createdAt;
  final LeaveApplicantModel? applicant;
  final LeaveApplicantModel? createdBy;
  final LeavePolicyModel? leavePolicy;
  final String? reason;
  final LeaveApplicantModel? coverAttendant;
  final List<String> attachments;
  final int? currentStep;
  final bool? canAction;
  final List<LeaveShiftDetailModel> shifts;
  final List<LeaveApprovalStepModel> approvalSteps;
  final String? updatedAt;

  static const fromJson = LeaveRequestModelMapper.fromJson;
}
