import '../../core/base/base.dart';
import '../entities/common/paginated_list_entity.dart';
import '../entities/leave/apply_leave_params.dart';
import '../entities/leave/leave_attendant_entity.dart';
import '../entities/leave/leave_balance_entity.dart';
import '../entities/leave/leave_policy_entity.dart';
import '../entities/leave/leave_request_entity.dart';
import '../entities/leave/leave_status.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/leave_repository.dart';

final class GetLeavePoliciesUseCase {
  GetLeavePoliciesUseCase({
    required this.repository,
    required AuthenticationRepository authRepository,
  }) : _authRepository = authRepository;

  final LeaveRepository repository;
  final AuthenticationRepository _authRepository;

  Future<Result<List<LeavePolicyEntity>, Failure>> call() async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await repository.getLeavePolicies(partnerId);

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class GetLeaveBalancesUseCase {
  GetLeaveBalancesUseCase({
    required this.repository,
    required AuthenticationRepository authRepository,
  }) : _authRepository = authRepository;

  final LeaveRepository repository;
  final AuthenticationRepository _authRepository;

  Future<Result<List<LeaveBalanceEntity>, Failure>> call({
    int? year,
    int? leavePolicyId,
    int? attendantId,
    int? page,
    int? pageSize,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await repository.getLeaveBalances(
      partnerId,
      year: year,
      leavePolicyId: leavePolicyId,
      attendantId: attendantId,
      page: page,
      pageSize: pageSize,
    );

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class RequestLeaveUseCase {
  RequestLeaveUseCase({
    required this.repository,
    required AuthenticationRepository authRepository,
  }) : _authRepository = authRepository;

  final LeaveRepository repository;
  final AuthenticationRepository _authRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    ApplyLeaveParams params,
  ) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await repository.requestLeave(partnerId, params);

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class GetMyLeavesUseCase {
  GetMyLeavesUseCase({
    required this.repository,
    required AuthenticationRepository authRepository,
  }) : _authRepository = authRepository;

  final LeaveRepository repository;
  final AuthenticationRepository _authRepository;

  Future<Result<PaginatedListEntity<LeaveRequestEntity>, Failure>> call({
    LeaveStatus? status,
    int? page,
    int? pageSize,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await repository.getMyLeaves(
      partnerId,
      status: status,
      page: page,
      pageSize: pageSize,
    );

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class GetLeaveRequestDetailsUseCase {
  GetLeaveRequestDetailsUseCase({
    required this.repository,
    required AuthenticationRepository authRepository,
  }) : _authRepository = authRepository;

  final LeaveRepository repository;
  final AuthenticationRepository _authRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(int leaveRequestId) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await repository.getLeaveRequestDetails(
      partnerId,
      leaveRequestId,
    );

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class CancelLeaveUseCase {
  CancelLeaveUseCase({
    required this.repository,
    required AuthenticationRepository authRepository,
  }) : _authRepository = authRepository;

  final LeaveRepository repository;
  final AuthenticationRepository _authRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(int leaveRequestId) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await repository.cancelLeave(partnerId, leaveRequestId);

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class GetLeaveAttendantsUseCase {
  GetLeaveAttendantsUseCase({
    required this.repository,
    required AuthenticationRepository authRepository,
  }) : _authRepository = authRepository;

  final LeaveRepository repository;
  final AuthenticationRepository _authRepository;

  Future<Result<List<LeaveAttendantEntity>, Failure>> call() async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await repository.getLeaveAttendants(partnerId);

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class GetLeaveApprovalsUseCase {
  GetLeaveApprovalsUseCase({
    required this.repository,
    required AuthenticationRepository authRepository,
  }) : _authRepository = authRepository;

  final LeaveRepository repository;
  final AuthenticationRepository _authRepository;

  Future<Result<PaginatedListEntity<LeaveRequestEntity>, Failure>> call({
    LeaveStatus? status,
    int? page,
    int? pageSize,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await repository.getLeaveApprovals(
      partnerId,
      status: status,
      page: page,
      pageSize: pageSize,
    );

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class ApproveLeaveUseCase {
  ApproveLeaveUseCase({
    required this.repository,
    required AuthenticationRepository authRepository,
  }) : _authRepository = authRepository;

  final LeaveRepository repository;
  final AuthenticationRepository _authRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(int leaveRequestId) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await repository.approveLeave(partnerId, leaveRequestId);

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class RejectLeaveUseCase {
  RejectLeaveUseCase({
    required this.repository,
    required AuthenticationRepository authRepository,
  }) : _authRepository = authRepository;

  final LeaveRepository repository;
  final AuthenticationRepository _authRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    int leaveRequestId, {
    String? reason,
  }) async {
    final partnerId = _authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await repository.rejectLeave(
      partnerId,
      leaveRequestId,
      reason: reason,
    );

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}
