import '../../core/base/exceptions.dart';
import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/leave/leave_attendant_entity.dart';
import '../../domain/entities/leave/leave_balance_entity.dart';
import '../../domain/entities/leave/leave_policy_entity.dart';
import '../../domain/entities/leave/leave_request_entity.dart';
import '../../domain/repositories/leave_repository.dart';
import '../models/leave/leave_attendant_model.dart';
import '../models/leave/leave_balance_model.dart';
import '../models/leave/leave_policy_model.dart';
import '../models/leave/leave_request_model.dart';
import '../models/leave/leave_response_models.dart';

extension LeavePolicyModelToEntity on LeavePolicyModel {
  LeavePolicyEntity toEntity() => LeavePolicyEntity(
        id: id,
        name: name,
        leaveType: leaveType,
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
        name: name,
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
        canAction: canAction ?? false,
        shifts: shifts.map((s) => s.toEntity()).toList(),
        approvalSteps: approvalSteps.map((s) => s.toEntity()).toList(),
        createdAt: createdAt,
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

extension LeavePolicyListResponseModelToEntity on LeavePolicyListResponseModel {
  List<LeavePolicyEntity> toEntity() =>
      data.map((model) => model.toEntity()).toList();
}

extension LeaveBalanceListResponseModelToEntity on LeaveBalanceListResponseModel {
  List<LeaveBalanceEntity> toEntity() =>
      data.map((model) => model.toEntity()).toList();
}

extension LeaveRequestResponseModelToEntity on LeaveRequestResponseModel {
  LeaveRequestEntity toEntity() => data!.toEntity();
}

extension LeaveRequestListResponseModelToEntity on LeaveRequestListResponseModel {
  PaginatedListEntity<LeaveRequestEntity> toEntity() {
    final items = data.map((model) => model.toEntity()).toList();
    final curPage = page ?? 1;
    final size = pageSize ?? 20;
    final total = totalRecords ?? items.length;
    final hasMore = (curPage * size) < total;

    return PaginatedListEntity<LeaveRequestEntity>(
      items: items,
      currentPage: curPage,
      pageSize: size,
      totalRecords: total,
      hasMore: hasMore,
    );
  }
}

extension LeaveAttendantListResponseModelToEntity on LeaveAttendantListResponseModel {
  List<LeaveAttendantEntity> toEntity() =>
      data.map((model) => model.toEntity()).toList();
}

extension RejectLeaveReasonMapper on String? {
  /// Wire body for `POST .../leave-requests/{id}/reject` — omits
  /// `rejection_reason` entirely when no reason was given.
  Map<String, dynamic> toRejectLeaveBody() {
    final reason = this;
    return reason != null && reason.isNotEmpty
        ? {'rejection_reason': reason}
        : <String, dynamic>{};
  }
}

extension RequestLeaveParamsMapper on RequestLeaveParams {
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
