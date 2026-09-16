import 'package:dart_mappable/dart_mappable.dart';

part 'leave_models.mapper.dart';

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
  final double? defaultDaysPerYear;
  final int? maxConsecutiveDays;
  final bool? requiresApproval;
  final bool? canCarryForward;
  final double? maxCarryForwardDays;
  final int? minNoticeDays;
  final String? color;
  final String? description;
  final bool? isActive;

  static const fromJson = LeavePolicyModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeaveBalanceModel with LeaveBalanceModelMappable {
  const LeaveBalanceModel({
    required this.id,
    this.leavePolicy,
    this.year,
    this.allocatedDays,
    this.usedDays,
    this.carriedForwardDays,
    this.pendingDays,
    this.adjustedDays,
    this.totalAvailableDays,
    this.remainingDays,
    this.notes,
  });

  final int id;
  final LeavePolicyModel? leavePolicy;
  final int? year;
  final double? allocatedDays;
  final double? usedDays;
  final double? carriedForwardDays;
  final double? pendingDays;
  final double? adjustedDays;
  final double? totalAvailableDays;
  final double? remainingDays;
  final String? notes;

  static const fromJson = LeaveBalanceModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeaveAttendantShiftModel with LeaveAttendantShiftModelMappable {
  const LeaveAttendantShiftModel({
    required this.id,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    this.status,
  });

  final int id;
  final String shiftName;
  final String startTime;
  final String endTime;
  final String? status;

  static const fromJson = LeaveAttendantShiftModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeaveAttendantModel with LeaveAttendantModelMappable {
  const LeaveAttendantModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.facilityId,
    required this.facilityName,
    this.shift,
  });

  final int id;
  final String uid;
  final String name;
  final int facilityId;
  final String facilityName;
  final LeaveAttendantShiftModel? shift;

  static const fromJson = LeaveAttendantModelMapper.fromJson;
}

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
    this.partnerId,
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
  final int? partnerId;
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

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeavePolicyListResponseModel with LeavePolicyListResponseModelMappable {
  const LeavePolicyListResponseModel({
    this.success,
    this.data = const [],
  });

  final bool? success;
  final List<LeavePolicyModel> data;

  static const fromJson = LeavePolicyListResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeaveBalanceListResponseModel
    with LeaveBalanceListResponseModelMappable {
  const LeaveBalanceListResponseModel({
    this.success,
    this.data = const [],
  });

  final bool? success;
  final List<LeaveBalanceModel> data;

  static const fromJson = LeaveBalanceListResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeaveRequestResponseModel with LeaveRequestResponseModelMappable {
  const LeaveRequestResponseModel({
    this.success,
    this.data,
  });

  final bool? success;
  final LeaveRequestModel? data;

  static const fromJson = LeaveRequestResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeaveRequestListResponseModel
    with LeaveRequestListResponseModelMappable {
  const LeaveRequestListResponseModel({
    this.success,
    this.totalRecords,
    this.page,
    this.pageSize,
    this.data = const [],
  });

  final bool? success;
  final int? totalRecords;
  final int? page;
  final int? pageSize;
  final List<LeaveRequestModel> data;

  static const fromJson = LeaveRequestListResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class LeaveAttendantListResponseModel
    with LeaveAttendantListResponseModelMappable {
  const LeaveAttendantListResponseModel({
    this.success,
    this.data = const [],
  });

  final bool? success;
  final List<LeaveAttendantModel> data;

  static const fromJson = LeaveAttendantListResponseModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  ignoreNull: true,
)
class CreateLeaveRequestModel with CreateLeaveRequestModelMappable {
  const CreateLeaveRequestModel({
    required this.leavePolicyId,
    required this.startDate,
    required this.endDate,
    this.attendantId,
    this.reason,
    this.coverAttendantId,
    this.attachments = const [],
  });

  final int leavePolicyId;
  final String startDate;
  final String endDate;
  final int? attendantId;
  final String? reason;
  final int? coverAttendantId;
  final List<String> attachments;

  static const fromJson = CreateLeaveRequestModelMapper.fromJson;
}
