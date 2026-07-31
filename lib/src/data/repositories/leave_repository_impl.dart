import '../../core/base/base.dart';
import '../../domain/entities/leave/apply_leave_params.dart';
import '../../domain/entities/leave/leave_attendant_entity.dart';
import '../../domain/entities/leave/leave_balance_entity.dart';
import '../../domain/entities/leave/leave_policy_entity.dart';
import '../../domain/entities/leave/leave_request_entity.dart';
import '../../domain/entities/leave/leave_status.dart';
import '../../domain/repositories/leave_repository.dart';
import '../extension/leave_mapper.dart';
import '../models/leave/leave_response_models.dart';
import '../services/network/rest_client.dart';

final class LeaveRepositoryImpl extends LeaveRepository {
  LeaveRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<List<LeavePolicyEntity>, Failure>> getLeavePolicies(
    int partnerId,
  ) {
    return asyncGuard(() async {
      final response = await remote.getLeavePolicies(partnerId: partnerId);
      final responseModel = LeavePolicyListResponseModel.fromJson(
        response.data,
      );

      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<List<LeaveBalanceEntity>, Failure>> getLeaveBalances(
    int partnerId, {
    int? year,
    int? leavePolicyId,
    int? attendantId,
  }) {
    return asyncGuard(() async {
      final response = await remote.getLeaveBalances(
        partnerId: partnerId,
        year: year,
        leavePolicyId: leavePolicyId,
        attendantId: attendantId,
      );
      final responseModel = LeaveBalanceListResponseModel.fromJson(
        response.data,
      );

      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<LeaveRequestEntity, Failure>> requestLeave(
    int partnerId,
    ApplyLeaveParams params,
  ) {
    return asyncGuard(() async {
      final response = await remote.requestLeave(
        partnerId: partnerId,
        body: params.toJson(),
      );
      final responseModel = LeaveRequestResponseModel.fromJson(response.data);

      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<List<LeaveRequestEntity>, Failure>> getMyLeaves(
    int partnerId, {
    LeaveStatus? status,
  }) {
    return asyncGuard(() async {
      final response = await remote.getMyLeaves(
        partnerId: partnerId,
        status: status?.toWireString(),
      );
      final responseModel = LeaveRequestListResponseModel.fromJson(
        response.data,
      );

      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<LeaveRequestEntity, Failure>> getLeaveRequestDetails(
    int partnerId,
    int leaveRequestId,
  ) {
    return asyncGuard(() async {
      final response = await remote.getLeaveRequestDetails(
        partnerId: partnerId,
        leaveRequestId: leaveRequestId,
      );
      final responseModel = LeaveRequestResponseModel.fromJson(response.data);

      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<LeaveRequestEntity, Failure>> cancelLeave(
    int partnerId,
    int leaveRequestId,
  ) {
    return asyncGuard(() async {
      final response = await remote.cancelLeave(
        partnerId: partnerId,
        leaveRequestId: leaveRequestId,
      );
      final responseModel = LeaveRequestResponseModel.fromJson(response.data);

      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<List<LeaveAttendantEntity>, Failure>> getLeaveAttendants(
    int partnerId,
  ) {
    return asyncGuard(() async {
      final response = await remote.getLeaveAttendants(partnerId: partnerId);
      final responseModel = LeaveAttendantListResponseModel.fromJson(
        response.data,
      );

      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<List<LeaveRequestEntity>, Failure>> getLeaveApprovals(
    int partnerId, {
    LeaveStatus? status,
  }) {
    return asyncGuard(() async {
      final response = await remote.getLeaveApprovals(
        partnerId: partnerId,
        status: status?.toWireString(),
      );
      final responseModel = LeaveRequestListResponseModel.fromJson(
        response.data,
      );

      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<LeaveRequestEntity, Failure>> approveLeave(
    int partnerId,
    int leaveRequestId,
  ) {
    return asyncGuard(() async {
      final response = await remote.approveLeave(
        partnerId: partnerId,
        leaveRequestId: leaveRequestId,
      );
      final responseModel = LeaveRequestResponseModel.fromJson(response.data);

      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<LeaveRequestEntity, Failure>> rejectLeave(
    int partnerId,
    int leaveRequestId, {
    String? reason,
  }) {
    return asyncGuard(() async {
      final response = await remote.rejectLeave(
        partnerId: partnerId,
        leaveRequestId: leaveRequestId,
        body: reason.toRejectLeaveBody(),
      );
      final responseModel = LeaveRequestResponseModel.fromJson(response.data);

      return responseModel.toEntity();
    });
  }
}
