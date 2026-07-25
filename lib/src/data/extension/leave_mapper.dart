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

extension LeaveBalanceModelToEntity on LeaveBalanceModel {
  LeaveBalanceEntity toEntity() => LeaveBalanceEntity(
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

extension LeaveApplicantModelToEntity on LeaveApplicantModel {
  LeaveApplicantEntity toEntity() => LeaveApplicantEntity(
        id: id,
        name: name,
        email: email,
        groupName: groupName,
      );
}

extension LeaveApprovalStepModelToEntity on LeaveApprovalStepModel {
  LeaveApprovalStepEntity toEntity() => LeaveApprovalStepEntity(
        stepNumber: stepNumber,
        approverRole: approverRole,
        approver: approver?.toEntity(),
        status: status,
        decidedAt: decidedAt,
        rejectionNote: rejectionNote,
      );
}

extension LeaveShiftDetailModelToEntity on LeaveShiftDetailModel {
  LeaveShiftDetailEntity toEntity() => LeaveShiftDetailEntity(
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

extension LeaveRequestModelToEntity on LeaveRequestModel {
  LeaveRequestEntity toEntity() => LeaveRequestEntity(
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

extension LeaveAttendantShiftModelToEntity on LeaveAttendantShiftModel {
  LeaveAttendantShiftEntity toEntity() => LeaveAttendantShiftEntity(
        id: id,
        shiftName: shiftName,
        startTime: startTime,
        endTime: endTime,
        status: status,
      );
}

extension LeaveAttendantModelToEntity on LeaveAttendantModel {
  LeaveAttendantEntity toEntity() => LeaveAttendantEntity(
        id: id,
        uid: uid,
        name: name,
        facilityId: facilityId,
        facilityName: facilityName,
        shift: shift?.toEntity(),
      );
}
