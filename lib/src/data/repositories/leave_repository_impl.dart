import '../../core/base/base.dart';
import '../../domain/entities/leave/leave_attendant_entity.dart';
import '../../domain/entities/leave/leave_balance_entity.dart';
import '../../domain/entities/leave/leave_policy_entity.dart';
import '../../domain/entities/leave/leave_request_entity.dart';
import '../../domain/repositories/leave_repository.dart';
import '../models/leave/leave_attendant_model.dart';
import '../models/leave/leave_balance_model.dart';
import '../models/leave/leave_mapper.dart';
import '../models/leave/leave_policy_model.dart';
import '../models/leave/leave_request_model.dart';
import '../services/network/rest_client.dart';

final class LeaveRepositoryImpl extends LeaveRepository {
  LeaveRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<List<LeavePolicyEntity>, Failure>> getLeavePolicies(
    int partnerId, {
    int? page,
    int? perPage,
  }) {
    return asyncGuard(() async {
      final response = await remote.getLeavePolicies(
        partnerId: partnerId,
        page: page,
        perPage: perPage,
      );
      final rawList = response.data['data'] as List<dynamic>? ?? const [];
      final models = rawList
          .map((e) => LeavePolicyModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<LeaveBalanceEntity>, Failure>> getLeaveBalances(
    int partnerId, {
    int? year,
    int? leavePolicyId,
    int? attendantId,
    int? page,
    int? perPage,
  }) {
    return asyncGuard(() async {
      final response = await remote.getLeaveBalances(
        partnerId: partnerId,
        year: year,
        leavePolicyId: leavePolicyId,
        attendantId: attendantId,
        page: page,
        perPage: perPage,
      );
      final rawList = response.data['data'] as List<dynamic>? ?? const [];
      final models = rawList
          .map((e) => LeaveBalanceModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Result<LeaveRequestEntity, Failure>> requestLeave(
    int partnerId,
    RequestLeaveParams params,
  ) {
    return asyncGuard(() async {
      final response = await remote.requestLeave(
        partnerId: partnerId,
        body: params.toJson(),
      );
      final rawData = response.data['data'] as Map<String, dynamic>;
      final model = LeaveRequestModel.fromJson(rawData);
      return model.toEntity();
    });
  }

  @override
  Future<Result<List<LeaveRequestEntity>, Failure>> getMyLeaves(
    int partnerId, {
    String? status,
  }) {
    return asyncGuard(() async {
      final response = await remote.getMyLeaves(
        partnerId: partnerId,
        status: status,
      );
      final rawList = response.data['data'] as List<dynamic>? ?? const [];
      final models = rawList
          .map((e) => LeaveRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return models.map((m) => m.toEntity()).toList();
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
      final rawData = response.data['data'] as Map<String, dynamic>;
      final model = LeaveRequestModel.fromJson(rawData);
      return model.toEntity();
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
      final rawData = response.data['data'] as Map<String, dynamic>;
      final model = LeaveRequestModel.fromJson(rawData);
      return model.toEntity();
    });
  }

  @override
  Future<Result<List<LeaveAttendantEntity>, Failure>> getLeaveAttendants(
    int partnerId,
  ) {
    return asyncGuard(() async {
      final response = await remote.getLeaveAttendants(partnerId: partnerId);
      final rawList = response.data['data'] as List<dynamic>? ?? const [];
      final models = rawList
          .map((e) => LeaveAttendantModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<LeaveRequestEntity>, Failure>> getLeaveApprovals(
    int partnerId, {
    String? status,
  }) {
    return asyncGuard(() async {
      final response = await remote.getLeaveApprovals(
        partnerId: partnerId,
        status: status,
      );
      final rawList = response.data['data'] as List<dynamic>? ?? const [];
      final models = rawList
          .map((e) => LeaveRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return models.map((m) => m.toEntity()).toList();
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
      final rawData = response.data['data'] as Map<String, dynamic>;
      final model = LeaveRequestModel.fromJson(rawData);
      return model.toEntity();
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
        body: reason != null && reason.isNotEmpty
            ? {'rejection_reason': reason}
            : <String, dynamic>{},
      );
      final rawData = response.data['data'] as Map<String, dynamic>;
      final model = LeaveRequestModel.fromJson(rawData);
      return model.toEntity();
    });
  }
}
