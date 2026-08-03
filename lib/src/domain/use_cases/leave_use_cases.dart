import '../../core/base/base.dart';
import '../entities/leave/create_leave_request.dart';
import '../entities/leave/leave_attendant_entity.dart';
import '../entities/leave/leave_balance_entity.dart';
import '../entities/leave/leave_policy_entity.dart';
import '../entities/leave/leave_request_entity.dart';
import '../entities/leave/leave_status.dart';
import '../repositories/leave_repository.dart';
import 'partner_use_case.dart';

final class GetLeavePoliciesUseCase extends PartnerUseCase {
  GetLeavePoliciesUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<List<LeavePolicyEntity>, Failure>> call() {
    return withPartnerId((partnerId) async {
      final result = await leaveRepository.getLeavePolicies(partnerId);

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('load leave policies')),
      };
    });
  }
}

final class GetLeaveBalancesUseCase extends PartnerUseCase {
  GetLeaveBalancesUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<List<LeaveBalanceEntity>, Failure>> call({
    int? year,
    int? leavePolicyId,
    int? attendantId,
  }) {
    return withPartnerId((partnerId) async {
      final result = await leaveRepository.getLeaveBalances(
        partnerId,
        year: year,
        leavePolicyId: leavePolicyId,
        attendantId: attendantId,
      );

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('load leave balances')),
      };
    });
  }
}

final class RequestLeaveUseCase extends PartnerUseCase {
  RequestLeaveUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    CreateLeaveRequest params,
  ) {
    return withPartnerId((partnerId) async {
      final result = await leaveRepository.requestLeave(partnerId, params);

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('request leave')),
      };
    });
  }
}

final class GetMyLeavesUseCase extends PartnerUseCase {
  GetMyLeavesUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<List<LeaveRequestEntity>, Failure>> call({
    LeaveStatus? status,
  }) {
    return withPartnerId((partnerId) async {
      final result = await leaveRepository.getMyLeaves(
        partnerId,
        status: status,
      );

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('load my leaves')),
      };
    });
  }
}

final class GetLeaveRequestDetailsUseCase extends PartnerUseCase {
  GetLeaveRequestDetailsUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(int leaveRequestId) {
    return withPartnerId((partnerId) async {
      final result = await leaveRepository.getLeaveRequestDetails(
        partnerId,
        leaveRequestId,
      );

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('load leave details')),
      };
    });
  }
}

final class CancelLeaveUseCase extends PartnerUseCase {
  CancelLeaveUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(int leaveRequestId) {
    return withPartnerId((partnerId) async {
      final result = await leaveRepository.cancelLeave(
        partnerId,
        leaveRequestId,
      );

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('cancel leave')),
      };
    });
  }
}

final class GetLeaveAttendantsUseCase extends PartnerUseCase {
  GetLeaveAttendantsUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<List<LeaveAttendantEntity>, Failure>> call() {
    return withPartnerId((partnerId) async {
      final result = await leaveRepository.getLeaveAttendants(partnerId);

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('load leave attendants')),
      };
    });
  }
}

final class GetLeaveApprovalsUseCase extends PartnerUseCase {
  GetLeaveApprovalsUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<List<LeaveRequestEntity>, Failure>> call({
    LeaveStatus? status,
  }) {
    return withPartnerId((partnerId) async {
      final result = await leaveRepository.getLeaveApprovals(
        partnerId,
        status: status,
      );

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('load leave approvals')),
      };
    });
  }
}

final class ApproveLeaveUseCase extends PartnerUseCase {
  ApproveLeaveUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(int leaveRequestId) {
    return withPartnerId((partnerId) async {
      final result = await leaveRepository.approveLeave(
        partnerId,
        leaveRequestId,
      );

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('approve leave')),
      };
    });
  }
}

final class RejectLeaveUseCase extends PartnerUseCase {
  RejectLeaveUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    int leaveRequestId, {
    String? reason,
  }) {
    return withPartnerId((partnerId) async {
      final result = await leaveRepository.rejectLeave(
        partnerId,
        leaveRequestId,
        reason: reason,
      );

      return switch (result) {
        Success(:final data) => Success(data: data),
        Error(:final error) => Error(error),
        _ => Error(Failure.emptyResponse('reject leave')),
      };
    });
  }
}
