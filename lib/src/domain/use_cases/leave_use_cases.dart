import '../../core/base/result.dart';
import '../entities/leave/leave_attendant_entity.dart';
import '../entities/leave/leave_balance_entity.dart';
import '../entities/leave/leave_policy_entity.dart';
import '../entities/leave/leave_request_entity.dart';
import '../repositories/leave_repository.dart';

final class GetLeavePoliciesUseCase {
  GetLeavePoliciesUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<List<LeavePolicyEntity>, String>> call(
    int partnerId, {
    int? page,
    int? perPage,
  }) async {
    final result = await repository.getLeavePolicies(
      partnerId,
      page: page,
      perPage: perPage,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}

final class GetLeaveBalancesUseCase {
  GetLeaveBalancesUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<List<LeaveBalanceEntity>, String>> call(
    int partnerId, {
    int? year,
    int? leavePolicyId,
    int? attendantId,
    int? page,
    int? perPage,
  }) async {
    final result = await repository.getLeaveBalances(
      partnerId,
      year: year,
      leavePolicyId: leavePolicyId,
      attendantId: attendantId,
      page: page,
      perPage: perPage,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}

final class RequestLeaveUseCase {
  RequestLeaveUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, String>> call(
    int partnerId,
    RequestLeaveParams params,
  ) async {
    final result = await repository.requestLeave(partnerId, params);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}

final class GetMyLeavesUseCase {
  GetMyLeavesUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<List<LeaveRequestEntity>, String>> call(
    int partnerId, {
    String? status,
  }) async {
    final result = await repository.getMyLeaves(partnerId, status: status);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}

final class GetLeaveRequestDetailsUseCase {
  GetLeaveRequestDetailsUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, String>> call(
    int partnerId,
    int leaveRequestId,
  ) async {
    final result = await repository.getLeaveRequestDetails(
      partnerId,
      leaveRequestId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}

final class CancelLeaveUseCase {
  CancelLeaveUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, String>> call(
    int partnerId,
    int leaveRequestId,
  ) async {
    final result = await repository.cancelLeave(partnerId, leaveRequestId);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}

final class GetLeaveAttendantsUseCase {
  GetLeaveAttendantsUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<List<LeaveAttendantEntity>, String>> call(
    int partnerId,
  ) async {
    final result = await repository.getLeaveAttendants(partnerId);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}

final class GetLeaveApprovalsUseCase {
  GetLeaveApprovalsUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<List<LeaveRequestEntity>, String>> call(
    int partnerId, {
    String? status,
  }) async {
    final result = await repository.getLeaveApprovals(partnerId, status: status);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}

final class ApproveLeaveUseCase {
  ApproveLeaveUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, String>> call(
    int partnerId,
    int leaveRequestId,
  ) async {
    final result = await repository.approveLeave(partnerId, leaveRequestId);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}

final class RejectLeaveUseCase {
  RejectLeaveUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, String>> call(
    int partnerId,
    int leaveRequestId, {
    String? reason,
  }) async {
    final result = await repository.rejectLeave(
      partnerId,
      leaveRequestId,
      reason: reason,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Unexpected error'),
    };
  }
}
