import '../../core/base/base.dart';
import '../entities/common/paginated_list_entity.dart';
import '../entities/leave/leave_attendant_entity.dart';
import '../entities/leave/leave_balance_entity.dart';
import '../entities/leave/leave_policy_entity.dart';
import '../entities/leave/leave_request_entity.dart';
import '../entities/leave/leave_status.dart';

class RequestLeaveParams {
  const RequestLeaveParams({
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
}

abstract base class LeaveRepository extends Repository {
  Future<Result<List<LeavePolicyEntity>, Failure>> getLeavePolicies(
    int partnerId,
  );

  Future<Result<List<LeaveBalanceEntity>, Failure>> getLeaveBalances(
    int partnerId, {
    int? year,
    int? leavePolicyId,
    int? attendantId,
    int? page,
    int? pageSize,
  });

  Future<Result<LeaveRequestEntity, Failure>> requestLeave(
    int partnerId,
    RequestLeaveParams params,
  );

  Future<Result<PaginatedListEntity<LeaveRequestEntity>, Failure>> getMyLeaves(
    int partnerId, {
    LeaveStatus? status,
    int? page,
    int? pageSize,
  });

  Future<Result<LeaveRequestEntity, Failure>> getLeaveRequestDetails(
    int partnerId,
    int leaveRequestId,
  );

  Future<Result<LeaveRequestEntity, Failure>> cancelLeave(
    int partnerId,
    int leaveRequestId,
  );

  Future<Result<List<LeaveAttendantEntity>, Failure>> getLeaveAttendants(
    int partnerId,
  );

  Future<Result<PaginatedListEntity<LeaveRequestEntity>, Failure>> getLeaveApprovals(
    int partnerId, {
    LeaveStatus? status,
    int? page,
    int? pageSize,
  });

  Future<Result<LeaveRequestEntity, Failure>> approveLeave(
    int partnerId,
    int leaveRequestId,
  );

  Future<Result<LeaveRequestEntity, Failure>> rejectLeave(
    int partnerId,
    int leaveRequestId, {
    String? reason,
  });
}
