import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/leave/leave_attendant_entity.dart';
import '../entities/leave/leave_balance_entity.dart';
import '../entities/leave/leave_policy_entity.dart';
import '../entities/leave/leave_request_entity.dart';
import '../repositories/leave_repository.dart';

final class GetLeavePoliciesUseCase {
  GetLeavePoliciesUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<List<LeavePolicyEntity>, Failure>> call(
    int partnerId, {
    int? page,
    int? perPage,
  }) {
    return repository.getLeavePolicies(partnerId, page: page, perPage: perPage);
  }
}

final class GetLeaveBalancesUseCase {
  GetLeaveBalancesUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<List<LeaveBalanceEntity>, Failure>> call(
    int partnerId, {
    int? year,
    int? leavePolicyId,
    int? attendantId,
    int? page,
    int? perPage,
  }) {
    return repository.getLeaveBalances(
      partnerId,
      year: year,
      leavePolicyId: leavePolicyId,
      attendantId: attendantId,
      page: page,
      perPage: perPage,
    );
  }
}

final class RequestLeaveUseCase {
  RequestLeaveUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    int partnerId,
    RequestLeaveParams params,
  ) {
    return repository.requestLeave(partnerId, params);
  }
}

final class GetMyLeavesUseCase {
  GetMyLeavesUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<List<LeaveRequestEntity>, Failure>> call(
    int partnerId, {
    String? status,
  }) {
    return repository.getMyLeaves(partnerId, status: status);
  }
}

final class GetLeaveRequestDetailsUseCase {
  GetLeaveRequestDetailsUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    int partnerId,
    int leaveRequestId,
  ) {
    return repository.getLeaveRequestDetails(partnerId, leaveRequestId);
  }
}

final class CancelLeaveUseCase {
  CancelLeaveUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    int partnerId,
    int leaveRequestId,
  ) {
    return repository.cancelLeave(partnerId, leaveRequestId);
  }
}

final class GetLeaveAttendantsUseCase {
  GetLeaveAttendantsUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<List<LeaveAttendantEntity>, Failure>> call(int partnerId) {
    return repository.getLeaveAttendants(partnerId);
  }
}

final class GetLeaveApprovalsUseCase {
  GetLeaveApprovalsUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<List<LeaveRequestEntity>, Failure>> call(
    int partnerId, {
    String? status,
  }) {
    return repository.getLeaveApprovals(partnerId, status: status);
  }
}

final class ApproveLeaveUseCase {
  ApproveLeaveUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    int partnerId,
    int leaveRequestId,
  ) {
    return repository.approveLeave(partnerId, leaveRequestId);
  }
}

final class RejectLeaveUseCase {
  RejectLeaveUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    int partnerId,
    int leaveRequestId, {
    String? reason,
  }) {
    return repository.rejectLeave(partnerId, leaveRequestId, reason: reason);
  }
}
