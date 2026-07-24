import '../../../domain/entities/leave/leave_attendant_entity.dart';
import '../../../domain/entities/leave/leave_balance_entity.dart';
import '../../../domain/entities/leave/leave_policy_entity.dart';
import '../../../domain/entities/leave/leave_request_entity.dart';
import 'leave_attendant_model.dart';
import 'leave_balance_model.dart';
import 'leave_policy_model.dart';
import 'leave_request_model.dart';

extension LeavePolicyModelMapper on LeavePolicyModel {
  LeavePolicyEntity toEntity() {
    return LeavePolicyEntity(
      id: id,
      partnerId: partnerId,
      name: name,
      leaveType: leaveType,
      defaultDaysPerYear: defaultDaysPerYear,
      maxConsecutiveDays: maxConsecutiveDays,
      requiresApproval: requiresApproval,
      canCarryForward: canCarryForward,
      maxCarryForwardDays: maxCarryForwardDays,
      minNoticeDays: minNoticeDays,
      color: color,
      description: description,
      isActive: isActive,
    );
  }
}

extension LeaveBalanceModelMapper on LeaveBalanceModel {
  LeaveBalanceEntity toEntity() {
    return LeaveBalanceEntity(
      id: id,
      leavePolicy: leavePolicy?.toEntity() ??
          LeavePolicyEntity(
            id: 0,
            partnerId: 0,
            name: 'Annual Leave',
            leaveType: 'annual',
            defaultDaysPerYear: 0,
            requiresApproval: true,
            canCarryForward: false,
            isActive: true,
          ),
      year: year,
      allocatedDays: allocatedDays,
      usedDays: usedDays,
      carriedForwardDays: carriedForwardDays,
      pendingDays: pendingDays,
      adjustedDays: adjustedDays,
      totalAvailableDays: totalAvailableDays,
      remainingDays: remainingDays,
      notes: notes,
    );
  }
}

extension LeaveApplicantModelMapper on LeaveApplicantModel {
  LeaveApplicantEntity toEntity() {
    return LeaveApplicantEntity(
      id: id,
      name: name,
      email: email,
      groupName: groupName,
    );
  }
}

extension LeaveApprovalStepModelMapper on LeaveApprovalStepModel {
  LeaveApprovalStepEntity toEntity() {
    return LeaveApprovalStepEntity(
      stepNumber: stepNumber,
      approverRole: approverRole,
      approver: approver?.toEntity(),
      status: status,
      decidedAt: decidedAt,
      rejectionNote: rejectionNote,
    );
  }
}

extension LeaveShiftDetailModelMapper on LeaveShiftDetailModel {
  LeaveShiftDetailEntity toEntity() {
    return LeaveShiftDetailEntity(
      id: id,
      shiftDate: shiftDate,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      facilityId: facilityId,
      facilityName: facilityName,
      status: status,
    );
  }
}

extension LeaveRequestModelMapper on LeaveRequestModel {
  LeaveRequestEntity toEntity() {
    return LeaveRequestEntity(
      id: id,
      referenceCode: referenceCode,
      partnerId: partnerId,
      applicant: applicant?.toEntity(),
      createdBy: createdBy?.toEntity(),
      leavePolicy: leavePolicy?.toEntity(),
      startDate: startDate,
      endDate: endDate,
      daysCount: daysCount,
      leaveType: leaveType,
      reason: reason,
      coverAttendant: coverAttendant?.toEntity(),
      attachments: attachments,
      status: status,
      currentStep: currentStep,
      canAction: canAction,
      shifts: shifts.map((s) => s.toEntity()).toList(),
      approvalSteps: approvalSteps.map((s) => s.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension LeaveAttendantShiftModelMapper on LeaveAttendantShiftModel {
  LeaveAttendantShiftEntity toEntity() {
    return LeaveAttendantShiftEntity(
      id: id,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      status: status,
    );
  }
}

extension LeaveAttendantModelMapper on LeaveAttendantModel {
  LeaveAttendantEntity toEntity() {
    return LeaveAttendantEntity(
      id: id,
      uid: uid,
      name: name,
      facilityId: facilityId,
      facilityName: facilityName,
      shift: shift?.toEntity(),
    );
  }
}
