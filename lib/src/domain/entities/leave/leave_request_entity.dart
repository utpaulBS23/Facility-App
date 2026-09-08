import 'leave_policy_entity.dart';
import 'leave_status.dart';
import 'leave_type.dart';
import 'shift_status.dart';

class LeaveApplicantEntity {
  const LeaveApplicantEntity({
    required this.id,
    required this.name,
    this.groupName,
  });

  final int id;
  final String name;
  final String? groupName;
}

class LeaveApprovalStepEntity {
  const LeaveApprovalStepEntity({
    required this.stepNumber,
    required this.approverRole,
    this.approver,
    required this.status,
    this.decidedAt,
    this.rejectionNote,
  });

  final int stepNumber;
  final String approverRole;
  final LeaveApplicantEntity? approver;
  final LeaveStatus status;
  final String? decidedAt;
  final String? rejectionNote;
}

class LeaveShiftDetailEntity {
  const LeaveShiftDetailEntity({
    required this.id,
    required this.shiftDate,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.facilityId,
    required this.facilityName,
    required this.status,
  });

  final int id;
  final String shiftDate;
  final String shiftName;
  final String startTime;
  final String endTime;
  final int facilityId;
  final String facilityName;
  final ShiftStatus status;
}

class LeaveRequestEntity {
  const LeaveRequestEntity({
    required this.id,
    required this.referenceCode,
    this.applicant,
    this.createdBy,
    required this.leavePolicy,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    required this.leaveType,
    this.reason,
    this.coverAttendant,
    this.attachments = const [],
    required this.status,
    this.shifts = const [],
    this.approvalSteps = const [],
    required this.createdAt,
    required this.canAction,
  });

  final int id;
  final String referenceCode;
  final LeaveApplicantEntity? applicant;
  final LeaveApplicantEntity? createdBy;
  final LeavePolicyEntity leavePolicy;
  final String startDate;
  final String endDate;
  final int daysCount;
  final LeaveType leaveType;
  final String? reason;
  final LeaveApplicantEntity? coverAttendant;
  final List<String> attachments;
  final LeaveStatus status;
  final List<LeaveShiftDetailEntity> shifts;
  final List<LeaveApprovalStepEntity> approvalSteps;
  final String createdAt;

  /// Server-derived UX flag: true when the logged-in caller can approve or
  /// reject this request right now. Treat as display-only — the server
  /// re-checks authorization on the actual approve/reject endpoints.
  final bool canAction;

  bool isFiledOnBehalf() {
    if (createdBy == null || applicant == null) return false;
    return createdBy!.id != applicant!.id;
  }

  String submitterName() {
    if (createdBy != null && applicant != null && createdBy!.id != applicant!.id) {
      return createdBy!.name;
    }
    return applicant?.name ?? leavePolicy.name;
  }
}
