import '../../core/base/base.dart';
import '../entities/common/paginated_list_entity.dart';
import '../entities/leave/create_leave_request_entity.dart';
import '../entities/leave/leave_attendant_entity.dart';
import '../entities/leave/leave_balance_entity.dart';
import '../entities/leave/leave_filter.dart';
import '../entities/leave/leave_request_entity.dart';
import '../entities/leave/leave_summary_entity.dart';

abstract base class LeaveRepository extends Repository {

  Future<Result<List<LeaveBalanceEntity>, Failure>> getLeaveBalances(
    int partnerId, {
    int? year,
    int? leavePolicyId,
    int? attendantId,
  });

  Future<Result<LeaveRequestEntity, Failure>> requestLeave(
    int partnerId,
    CreateLeaveRequestEntity params,
  );

  Future<Result<List<LeaveRequestEntity>, Failure>> getMyLeaves(
    int partnerId, {
    LeaveFilter? filter,
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

  Future<Result<PaginatedListEntity<LeaveRequestEntity>, Failure>>
  getLeaveRequests(
    int partnerId, {
    LeaveFilter? filter,
    int? page,
    int? perPage,
  });

  Future<Result<LeaveSummaryEntity, Failure>> getLeaveApprovalsSummary(
    int partnerId, {
    int? facilityId,
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
