import '../../core/base/base.dart';
import '../entities/common/paginated_list_entity.dart';
import '../entities/leave/leave_attendant_entity.dart';
import '../entities/leave/leave_balance_entity.dart';
import '../entities/leave/leave_policy_entity.dart';
import '../entities/leave/leave_request_entity.dart';
import '../entities/leave/leave_status.dart';
import '../repositories/leave_repository.dart';

final class GetLeavePoliciesUseCase {
  GetLeavePoliciesUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<List<LeavePolicyEntity>, Failure>> call(
    int partnerId,
  ) async {
    final result = await repository.getLeavePolicies(partnerId);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      // WHY: Result's generated variants aren't exhaustiveness-checkable by
      // the analyzer here, so this wildcard stays reachable-in-practice-never
      // but required for compilation.
      _ => const Error(
          Failure(type: FailureType.unknown, message: 'Unexpected error'),
        ),
    };
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
      Error(:final error) => Error(error),
      // WHY: Result's generated variants aren't exhaustiveness-checkable by
      // the analyzer here, so this wildcard stays reachable-in-practice-never
      // but required for compilation.
      _ => const Error(
          Failure(type: FailureType.unknown, message: 'Unexpected error'),
        ),
    };
  }
}

final class RequestLeaveUseCase {
  RequestLeaveUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    int partnerId,
    RequestLeaveParams params,
  ) async {
    final result = await repository.requestLeave(partnerId, params);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      // WHY: Result's generated variants aren't exhaustiveness-checkable by
      // the analyzer here, so this wildcard stays reachable-in-practice-never
      // but required for compilation.
      _ => const Error(
          Failure(type: FailureType.unknown, message: 'Unexpected error'),
        ),
    };
  }
}

final class GetMyLeavesUseCase {
  GetMyLeavesUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<PaginatedListEntity<LeaveRequestEntity>, Failure>> call(
    int partnerId, {
    LeaveStatus? status,
    int? page,
    int? pageSize,
  }) async {
    final result = await repository.getMyLeaves(
      partnerId,
      status: status,
      page: page,
      pageSize: pageSize,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      // WHY: Result's generated variants aren't exhaustiveness-checkable by
      // the analyzer here, so this wildcard stays reachable-in-practice-never
      // but required for compilation.
      _ => const Error(
          Failure(type: FailureType.unknown, message: 'Unexpected error'),
        ),
    };
  }
}

final class GetLeaveRequestDetailsUseCase {
  GetLeaveRequestDetailsUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    int partnerId,
    int leaveRequestId,
  ) async {
    final result = await repository.getLeaveRequestDetails(
      partnerId,
      leaveRequestId,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      // WHY: Result's generated variants aren't exhaustiveness-checkable by
      // the analyzer here, so this wildcard stays reachable-in-practice-never
      // but required for compilation.
      _ => const Error(
          Failure(type: FailureType.unknown, message: 'Unexpected error'),
        ),
    };
  }
}

final class CancelLeaveUseCase {
  CancelLeaveUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    int partnerId,
    int leaveRequestId,
  ) async {
    final result = await repository.cancelLeave(partnerId, leaveRequestId);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      // WHY: Result's generated variants aren't exhaustiveness-checkable by
      // the analyzer here, so this wildcard stays reachable-in-practice-never
      // but required for compilation.
      _ => const Error(
          Failure(type: FailureType.unknown, message: 'Unexpected error'),
        ),
    };
  }
}

final class GetLeaveAttendantsUseCase {
  GetLeaveAttendantsUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<List<LeaveAttendantEntity>, Failure>> call(
    int partnerId,
  ) async {
    final result = await repository.getLeaveAttendants(partnerId);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      // WHY: Result's generated variants aren't exhaustiveness-checkable by
      // the analyzer here, so this wildcard stays reachable-in-practice-never
      // but required for compilation.
      _ => const Error(
          Failure(type: FailureType.unknown, message: 'Unexpected error'),
        ),
    };
  }
}

final class GetLeaveApprovalsUseCase {
  GetLeaveApprovalsUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<PaginatedListEntity<LeaveRequestEntity>, Failure>> call(
    int partnerId, {
    LeaveStatus? status,
    int? page,
    int? pageSize,
  }) async {
    final result = await repository.getLeaveApprovals(
      partnerId,
      status: status,
      page: page,
      pageSize: pageSize,
    );
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      // WHY: Result's generated variants aren't exhaustiveness-checkable by
      // the analyzer here, so this wildcard stays reachable-in-practice-never
      // but required for compilation.
      _ => const Error(
          Failure(type: FailureType.unknown, message: 'Unexpected error'),
        ),
    };
  }
}

final class ApproveLeaveUseCase {
  ApproveLeaveUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    int partnerId,
    int leaveRequestId,
  ) async {
    final result = await repository.approveLeave(partnerId, leaveRequestId);
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      // WHY: Result's generated variants aren't exhaustiveness-checkable by
      // the analyzer here, so this wildcard stays reachable-in-practice-never
      // but required for compilation.
      _ => const Error(
          Failure(type: FailureType.unknown, message: 'Unexpected error'),
        ),
    };
  }
}

final class RejectLeaveUseCase {
  RejectLeaveUseCase(this.repository);
  final LeaveRepository repository;

  Future<Result<LeaveRequestEntity, Failure>> call(
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
      Error(:final error) => Error(error),
      // WHY: Result's generated variants aren't exhaustiveness-checkable by
      // the analyzer here, so this wildcard stays reachable-in-practice-never
      // but required for compilation.
      _ => const Error(
          Failure(type: FailureType.unknown, message: 'Unexpected error'),
        ),
    };
  }
}
