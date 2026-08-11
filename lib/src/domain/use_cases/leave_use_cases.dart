import '../../core/base/base.dart';
import '../entities/leave/create_leave_request_entity.dart';
import '../entities/leave/leave_attendant_entity.dart';
import '../entities/leave/leave_balance_entity.dart';
import '../entities/leave/leave_request_entity.dart';
import '../entities/leave/leave_status.dart';
import '../repositories/leave_repository.dart';
import 'partner_use_case.dart';


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
  }) async {
    final partnerId = getPartnerId();
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
  }
}

final class RequestLeaveUseCase extends PartnerUseCase {
  RequestLeaveUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(
    CreateLeaveRequestEntity params,
  ) async {
    final partnerId = getPartnerId();
    final result = await leaveRepository.requestLeave(partnerId, params);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('request leave')),
    };
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
  }) async {
    final partnerId = getPartnerId();
    final result = await leaveRepository.getMyLeaves(
      partnerId,
      status: status,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('load my leaves')),
    };
  }
}

final class GetLeaveRequestDetailsUseCase extends PartnerUseCase {
  GetLeaveRequestDetailsUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(int leaveRequestId) async {
    final partnerId = getPartnerId();
    final result = await leaveRepository.getLeaveRequestDetails(
      partnerId,
      leaveRequestId,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('load leave details')),
    };
  }
}

final class CancelLeaveUseCase extends PartnerUseCase {
  CancelLeaveUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(int leaveRequestId) async {
    final partnerId = getPartnerId();
    final result = await leaveRepository.cancelLeave(
      partnerId,
      leaveRequestId,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('cancel leave')),
    };
  }
}

final class GetLeaveAttendantsUseCase extends PartnerUseCase {
  GetLeaveAttendantsUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<List<LeaveAttendantEntity>, Failure>> call() async {
    final partnerId = getPartnerId();
    final result = await leaveRepository.getLeaveAttendants(partnerId);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('load leave attendants')),
    };
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
  }) async {
    final partnerId = getPartnerId();
    final result = await leaveRepository.getLeaveApprovals(
      partnerId,
      status: status,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('load leave approvals')),
    };
  }
}

final class ApproveLeaveUseCase extends PartnerUseCase {
  ApproveLeaveUseCase({
    required this.leaveRepository,
    required super.authRepository,
  });

  final LeaveRepository leaveRepository;

  Future<Result<LeaveRequestEntity, Failure>> call(int leaveRequestId) async {
    final partnerId = getPartnerId();
    final result = await leaveRepository.approveLeave(
      partnerId,
      leaveRequestId,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('approve leave')),
    };
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
  }) async {
    final partnerId = getPartnerId();
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
  }
}
