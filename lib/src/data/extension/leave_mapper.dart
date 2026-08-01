import '../../domain/entities/leave/create_leave_request.dart';
import '../../domain/entities/leave/leave_attendant_entity.dart';
import '../../domain/entities/leave/leave_balance_entity.dart';
import '../../domain/entities/leave/leave_policy_entity.dart';
import '../../domain/entities/leave/leave_request_entity.dart';
import '../../domain/entities/leave/leave_status.dart';
import '../../domain/entities/leave/leave_type.dart';
import '../../domain/entities/leave/shift_status.dart';
import '../models/leave/leave_attendant_model.dart';
import '../models/leave/leave_balance_model.dart';
import '../models/leave/leave_policy_model.dart';
import '../models/leave/leave_request_model.dart';
import '../models/leave/leave_response_models.dart';

extension LeavePolicyModelToEntity on LeavePolicyModel {
  LeavePolicyEntity toEntity() {
    return LeavePolicyEntity(
      id: id,
      name: name,
      leaveType: LeaveType.fromWireString(leaveType),
      defaultDaysPerYear: defaultDaysPerYear ?? 0.0,
      requiresApproval: requiresApproval ?? true,
      canCarryForward: canCarryForward ?? false,
    );
  }
}

extension LeaveBalanceModelToEntity on LeaveBalanceModel {
  LeaveBalanceEntity toEntity() {
    return LeaveBalanceEntity(
      id: id,
      leavePolicy: leavePolicy?.toEntity(),
      allocatedDays: allocatedDays ?? 0.0,
      usedDays: usedDays ?? 0.0,
      pendingDays: pendingDays ?? 0.0,
      remainingDays: remainingDays ?? 0.0,
    );
  }
}

extension LeaveApplicantModelToEntity on LeaveApplicantModel {
  LeaveApplicantEntity toEntity() {
    return LeaveApplicantEntity(id: id, name: name);
  }
}

extension LeaveApprovalStepModelToEntity on LeaveApprovalStepModel {
  LeaveApprovalStepEntity toEntity() {
    return LeaveApprovalStepEntity(
      stepNumber: stepNumber,
      approverRole: approverRole,
      approver: approver?.toEntity(),
      status: LeaveStatus.fromWireString(status),
      decidedAt: decidedAt,
      rejectionNote: rejectionNote,
    );
  }
}

extension LeaveShiftDetailModelToEntity on LeaveShiftDetailModel {
  LeaveShiftDetailEntity toEntity() {
    return LeaveShiftDetailEntity(
      id: id,
      shiftDate: shiftDate,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      facilityId: facilityId,
      facilityName: facilityName,
      status: ShiftStatus.fromWireString(status),
    );
  }
}

extension LeaveRequestModelToEntity on LeaveRequestModel {
  LeaveRequestEntity toEntity() {
    return LeaveRequestEntity(
      id: id,
      referenceCode: referenceCode,
      applicant: applicant?.toEntity(),
      createdBy: createdBy?.toEntity(),
      leavePolicy: leavePolicy?.toEntity(),
      startDate: startDate,
      endDate: endDate,
      daysCount: daysCount,
      leaveType: LeaveType.fromWireString(leaveType),
      reason: reason,
      coverAttendant: coverAttendant?.toEntity(),
      attachments: attachments,
      status: LeaveStatus.fromWireString(status),
      shifts: shifts.map((s) => s.toEntity()).toList(),
      approvalSteps: approvalSteps.map((s) => s.toEntity()).toList(),
      createdAt: createdAt,
    );
  }
}

extension LeaveAttendantShiftModelToEntity on LeaveAttendantShiftModel {
  LeaveAttendantShiftEntity toEntity() {
    return LeaveAttendantShiftEntity(
      id: id,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      status: ShiftStatus.fromWireString(status),
    );
  }
}

extension LeaveAttendantModelToEntity on LeaveAttendantModel {
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

extension LeavePolicyListResponseModelToEntity on LeavePolicyListResponseModel {
  List<LeavePolicyEntity> toEntity() {
    return data.map((model) => model.toEntity()).toList();
  }
}

extension LeaveBalanceListResponseModelToEntity
    on LeaveBalanceListResponseModel {
  List<LeaveBalanceEntity> toEntity() {
    return data.map((model) => model.toEntity()).toList();
  }
}

extension LeaveRequestResponseModelToEntity on LeaveRequestResponseModel {
  LeaveRequestEntity toEntity() {
    final payload = data;
    if (payload == null) {
      throw const FormatException(
        'Missing data payload in LeaveRequestResponse',
      );
    }

    return payload.toEntity();
  }
}

extension LeaveRequestListResponseModelToEntity
    on LeaveRequestListResponseModel {
  List<LeaveRequestEntity> toEntity() {
    final items = data.map((model) => model.toEntity()).toList();

    return items;
  }
}

extension LeaveAttendantListResponseModelToEntity
    on LeaveAttendantListResponseModel {
  List<LeaveAttendantEntity> toEntity() =>
      data.map((model) => model.toEntity()).toList();
}

extension ApplyLeaveParamsMapper on CreateLeaveRequest {
  Map<String, dynamic> toJson() {
    return {
      'leave_policy_id': leavePolicyId,
      'start_date': startDate,
      'end_date': endDate,
      if (attendantId != null) 'attendant_id': attendantId,
      if (reason != null && reason!.isNotEmpty) 'reason': reason,
      if (coverAttendantId != null) 'cover_attendant_id': coverAttendantId,
      if (attachments.isNotEmpty) 'attachments': attachments,
    };
  }
}
