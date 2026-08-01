import '../../core/base/base.dart';
import '../entities/leave/create_leave_request.dart';
import '../entities/leave/leave_attendant_entity.dart';
import '../entities/leave/leave_balance_entity.dart';
import '../entities/leave/leave_policy_entity.dart';
import '../entities/leave/leave_request_entity.dart';
import '../entities/leave/leave_status.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/leave_repository.dart';

final class GetLeavePoliciesUseCase {
  GetLeavePoliciesUseCase({
    required this.leaveRepository,
    required this.authRepository,
  });

  final LeaveRepository leaveRepository;
  final AuthenticationRepository authRepository;

  Future<Result<List<LeavePolicyEntity>, Failure>> call() async {
    final partnerId = authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await leaveRepository.getLeavePolicies(partnerId);

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class GetLeaveBalancesUseCase {
  GetLeaveBalancesUseCase({
    required this.leaveRepository,
    required this.authRepository,
  });

  final LeaveRepository leaveRepository;
  final AuthenticationRepository authRepository;

  Future<Result<List<LeaveBalanceEntity>, Failure>> call({
    int? year,
    int? leavePolicyId,
    int? attendantId,
  }) async {
    final partnerId = authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await leaveRepository.getLeaveBalances(
      partnerId,
      year: year,
      leavePolicyId: leavePolicyId,
      attendantId: attendantId,
    );

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class RequestLeaveUseCase {
  RequestLeaveUseCase({
    required this.leaveRepository,
    required this.authRepository,
  });

  final LeaveRepository leaveRepository;
  final AuthenticationRepository authRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    CreateLeaveRequest params,
  ) async {
    final partnerId = authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await leaveRepository.requestLeave(partnerId, params);

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class GetMyLeavesUseCase {
  GetMyLeavesUseCase({
    required this.leaveRepository,
    required this.authRepository,
  });

  final LeaveRepository leaveRepository;
  final AuthenticationRepository authRepository;

  Future<Result<List<LeaveRequestEntity>, Failure>> call({
    LeaveStatus? status,
  }) async {
    final partnerId = authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await leaveRepository.getMyLeaves(partnerId, status: status);

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class GetLeaveRequestDetailsUseCase {
  GetLeaveRequestDetailsUseCase({
    required this.leaveRepository,
    required this.authRepository,
  });

  final LeaveRepository leaveRepository;
  final AuthenticationRepository authRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(int leaveRequestId) async {
    final partnerId = authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await leaveRepository.getLeaveRequestDetails(
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
    required this.leaveRepository,
    required this.authRepository,
  });

  final LeaveRepository leaveRepository;
  final AuthenticationRepository authRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(int leaveRequestId) async {
    final partnerId = authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await leaveRepository.cancelLeave(partnerId, leaveRequestId);

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class GetLeaveAttendantsUseCase {
  GetLeaveAttendantsUseCase({
    required this.leaveRepository,
    required this.authRepository,
  });

  final LeaveRepository leaveRepository;
  final AuthenticationRepository authRepository;

  Future<Result<List<LeaveAttendantEntity>, Failure>> call() async {
    final partnerId = authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await leaveRepository.getLeaveAttendants(partnerId);

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class GetLeaveApprovalsUseCase {
  GetLeaveApprovalsUseCase({
    required this.leaveRepository,
    required this.authRepository,
  });

  final LeaveRepository leaveRepository;
  final AuthenticationRepository authRepository;

  Future<Result<List<LeaveRequestEntity>, Failure>> call({
    LeaveStatus? status,
  }) async {
    final partnerId = authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await leaveRepository.getLeaveApprovals(
      partnerId,
      status: status,
    );

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class ApproveLeaveUseCase {
  ApproveLeaveUseCase({
    required this.leaveRepository,
    required this.authRepository,
  });

  final LeaveRepository leaveRepository;
  final AuthenticationRepository authRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(int leaveRequestId) async {
    final partnerId = authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await leaveRepository.approveLeave(partnerId, leaveRequestId);

    return result.when(
      success: (data) => Success(data: data),
      error: (error) => Error(error),
    );
  }
}

final class RejectLeaveUseCase {
  RejectLeaveUseCase({
    required this.leaveRepository,
    required this.authRepository,
  });

  final LeaveRepository leaveRepository;
  final AuthenticationRepository authRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    int leaveRequestId, {
    String? reason,
  }) async {
    final partnerId = authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    final result = await leaveRepository.rejectLeave(
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
