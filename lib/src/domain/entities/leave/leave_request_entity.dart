import 'leave_policy_entity.dart';
import 'leave_status.dart';

class LeaveApplicantEntity {
  const LeaveApplicantEntity({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;
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
  final String status;
}

class LeaveRequestEntity {
  const LeaveRequestEntity({
    required this.id,
    required this.referenceCode,
    this.applicant,
    this.createdBy,
    this.leavePolicy,
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
  });

  final int id;
  final String referenceCode;
  final LeaveApplicantEntity? applicant;
  final LeaveApplicantEntity? createdBy;
  final LeavePolicyEntity? leavePolicy;
  final String startDate;
  final String endDate;
  final int daysCount;
  final String leaveType;
  final String? reason;
  final LeaveApplicantEntity? coverAttendant;
  final List<String> attachments;
  final LeaveStatus status;
  final List<LeaveShiftDetailEntity> shifts;
  final List<LeaveApprovalStepEntity> approvalSteps;
  final String createdAt;

  /// Visible approval steps for display: stops after the first rejected step.
  List<LeaveApprovalStepEntity> get visibleApprovalSteps {
    final result = <LeaveApprovalStepEntity>[];
    for (final step in approvalSteps) {
      result.add(step);
      if (step.status == LeaveStatus.rejected) {
        break;
      }
    }
    return result;
  }
}
