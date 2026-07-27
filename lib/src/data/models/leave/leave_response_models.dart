import 'package:dart_mappable/dart_mappable.dart';

import 'leave_attendant_model.dart';
import 'leave_balance_model.dart';
import 'leave_policy_model.dart';
import 'leave_request_model.dart';

part 'leave_response_models.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class LeavePolicyListResponseModel with LeavePolicyListResponseModelMappable {
  const LeavePolicyListResponseModel({
    this.success,
    this.data = const [],
  });

  final bool? success;
  final List<LeavePolicyModel> data;

  static const fromJson = LeavePolicyListResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveBalanceListResponseModel with LeaveBalanceListResponseModelMappable {
  const LeaveBalanceListResponseModel({
    this.success,
    this.data = const [],
  });

  final bool? success;
  final List<LeaveBalanceModel> data;

  static const fromJson = LeaveBalanceListResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveRequestResponseModel with LeaveRequestResponseModelMappable {
  const LeaveRequestResponseModel({
    this.success,
    this.data,
  });

  final bool? success;
  final LeaveRequestModel? data;

  static const fromJson = LeaveRequestResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveRequestListResponseModel with LeaveRequestListResponseModelMappable {
  const LeaveRequestListResponseModel({
    this.success,
    this.totalRecords,
    this.page,
    this.pageSize,
    this.data = const [],
  });

  final bool? success;
  @MappableField(key: 'total_records')
  final int? totalRecords;
  final int? page;
  @MappableField(key: 'page_size')
  final int? pageSize;
  final List<LeaveRequestModel> data;

  static const fromJson = LeaveRequestListResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.decode)
class LeaveAttendantListResponseModel with LeaveAttendantListResponseModelMappable {
  const LeaveAttendantListResponseModel({
    this.success,
    this.data = const [],
  });

  final bool? success;
  final List<LeaveAttendantModel> data;

  static const fromJson = LeaveAttendantListResponseModelMapper.fromJson;
}
