import '../../domain/entities/leave/leave_attendant_entity.dart';
import '../../domain/entities/leave/leave_balance_entity.dart';
import '../../domain/entities/leave/leave_policy_entity.dart';
import '../../domain/entities/leave/leave_request_entity.dart';
import '../models/leave/leave_attendant_model.dart';
import '../models/leave/leave_balance_model.dart';
import '../models/leave/leave_policy_model.dart';
import '../models/leave/leave_request_model.dart';

extension LeavePolicyModelToEntity on LeavePolicyModel {
  LeavePolicyEntity toEntity() => LeavePolicyEntity(
        id: id,
        name: name ?? '',
        leaveType: leaveType ?? 'annual',
        defaultDaysPerYear: defaultDaysPerYear ?? 0.0,
        requiresApproval: requiresApproval ?? true,
        canCarryForward: canCarryForward ?? false,
      );
}

extension LeaveBalanceModelToEntity on LeaveBalanceModel {
  LeaveBalanceEntity toEntity() => LeaveBalanceEntity(
        id: id,
        leavePolicy: leavePolicy?.toEntity(),
        allocatedDays: allocatedDays ?? 0.0,
        usedDays: usedDays ?? 0.0,
        pendingDays: pendingDays ?? 0.0,
        remainingDays: remainingDays ?? 0.0,
      );
}

extension LeaveApplicantModelToEntity on LeaveApplicantModel {
  LeaveApplicantEntity toEntity() => LeaveApplicantEntity(
        id: id,
        name: name ?? '',
      );
}

extension LeaveApprovalStepModelToEntity on LeaveApprovalStepModel {
  LeaveApprovalStepEntity toEntity() => LeaveApprovalStepEntity(
        stepNumber: stepNumber ?? 1,
        approverRole: approverRole ?? 'supervisor',
        approver: approver?.toEntity(),
        status: status ?? 'pending',
        decidedAt: decidedAt,
        rejectionNote: rejectionNote,
      );
}

extension LeaveShiftDetailModelToEntity on LeaveShiftDetailModel {
  LeaveShiftDetailEntity toEntity() => LeaveShiftDetailEntity(
        id: id,
        shiftDate: shiftDate ?? '',
        shiftName: shiftName ?? '',
        startTime: startTime ?? '',
        endTime: endTime ?? '',
        facilityId: facilityId ?? 0,
        facilityName: facilityName ?? '',
        status: status ?? 'scheduled',
      );
}

extension LeaveRequestModelToEntity on LeaveRequestModel {
  LeaveRequestEntity toEntity() => LeaveRequestEntity(
        id: id,
        referenceCode: referenceCode ?? '',
        applicant: applicant?.toEntity(),
        createdBy: createdBy?.toEntity(),
        leavePolicy: leavePolicy?.toEntity(),
        startDate: startDate ?? '',
        endDate: endDate ?? '',
        daysCount: daysCount ?? 1,
        leaveType: leaveType ?? 'annual',
        reason: reason,
        coverAttendant: coverAttendant?.toEntity(),
        attachments: attachments,
        status: status ?? 'pending_supervisor',
        canAction: canAction ?? false,
        shifts: shifts.map((s) => s.toEntity()).toList(),
        approvalSteps: approvalSteps.map((s) => s.toEntity()).toList(),
        createdAt: createdAt ?? '',
      );
}

extension LeaveAttendantShiftModelToEntity on LeaveAttendantShiftModel {
  LeaveAttendantShiftEntity toEntity() => LeaveAttendantShiftEntity(
        id: id,
        shiftName: shiftName ?? '',
        startTime: startTime ?? '',
        endTime: endTime ?? '',
        status: status ?? 'scheduled',
      );
}

extension LeaveAttendantModelToEntity on LeaveAttendantModel {
  LeaveAttendantEntity toEntity() => LeaveAttendantEntity(
        id: id,
        uid: uid ?? '',
        name: name ?? '',
        facilityId: facilityId ?? 0,
        facilityName: facilityName ?? '',
        shift: shift?.toEntity(),
      );
}
