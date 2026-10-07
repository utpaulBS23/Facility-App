import 'package:dart_mappable/dart_mappable.dart';

part 'toilet_details_model.mapper.dart';

/// `GET /partners/{partnerId}/facilities/{facilityId}`. The body is the
/// facility itself, not wrapped in `data`.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletDetailsModel with ToiletDetailsModelMappable {
  const ToiletDetailsModel({
    required this.id,
    this.code,
    this.distanceKm,
    this.consumerAccess,
    this.incomeTargetAndGoal,
    this.monthlyProgress,
    this.managementInformation,
    this.supplyStock = const [],
    this.attendance,
  });

  final int id;
  final ToiletPlaceholderValueModel? code;
  final ToiletPlaceholderValueModel? distanceKm;
  final ToiletConsumerAccessModel? consumerAccess;
  final ToiletIncomeTargetModel? incomeTargetAndGoal;
  final ToiletMonthlyProgressModel? monthlyProgress;
  final ToiletManagementInfoModel? managementInformation;
  final List<ToiletSupplyStockModel> supplyStock;
  final ToiletAttendanceModel? attendance;

  static const fromJson = ToiletDetailsModelMapper.fromJson;
}

/// `{value, label?, is_placeholder}`: the server marks values it does not
/// measure yet with `is_placeholder: true`.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletPlaceholderValueModel with ToiletPlaceholderValueModelMappable {
  const ToiletPlaceholderValueModel({
    this.value,
    this.label,
    this.isPlaceholder,
  });

  final dynamic value;
  final String? label;
  final bool? isPlaceholder;

  static const fromJson = ToiletPlaceholderValueModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletConsumerAccessModel with ToiletConsumerAccessModelMappable {
  const ToiletConsumerAccessModel({
    this.today,
    this.thisWeek,
    this.thisMonth,
    this.hourly = const [],
    this.peakHoursLabel,
  });

  final int? today;
  final int? thisWeek;
  final int? thisMonth;
  final List<ToiletHourlyModel> hourly;
  final String? peakHoursLabel;

  static const fromJson = ToiletConsumerAccessModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletHourlyModel with ToiletHourlyModelMappable {
  const ToiletHourlyModel({
    required this.hour,
    this.count,
    this.isPeak,
  });

  final int hour;
  final int? count;
  final bool? isPeak;

  static const fromJson = ToiletHourlyModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletIncomeTargetModel with ToiletIncomeTargetModelMappable {
  const ToiletIncomeTargetModel({
    this.dailyTarget,
    this.todayAchieved,
    this.monthlyTarget,
    this.monthAchieved,
  });

  final num? dailyTarget;
  final num? todayAchieved;
  final num? monthlyTarget;
  final num? monthAchieved;

  static const fromJson = ToiletIncomeTargetModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletMonthlyProgressModel with ToiletMonthlyProgressModelMappable {
  const ToiletMonthlyProgressModel({
    this.month,
    this.target,
    this.achieved,
    this.remaining,
    this.percentComplete,
    this.daysLeft,
    this.dailyPaceNeeded,
  });

  /// `YYYY-MM`.
  final String? month;
  final num? target;
  final num? achieved;
  final num? remaining;
  final num? percentComplete;
  final int? daysLeft;
  final num? dailyPaceNeeded;

  static const fromJson = ToiletMonthlyProgressModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletManagementInfoModel with ToiletManagementInfoModelMappable {
  const ToiletManagementInfoModel({
    this.airQuality,
    this.cleaningFrequency,
    this.lastCleaningAt,
  });

  final ToiletPlaceholderValueModel? airQuality;
  final ToiletPlaceholderValueModel? cleaningFrequency;
  final ToiletPlaceholderValueModel? lastCleaningAt;

  static const fromJson = ToiletManagementInfoModelMapper.fromJson;
}

/// One stocked item; `status` is ok, low or out.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletSupplyStockModel with ToiletSupplyStockModelMappable {
  const ToiletSupplyStockModel({
    this.itemName,
    this.unit,
    this.currentQty,
    this.status,
  });

  final String? itemName;
  final String? unit;
  final num? currentQty;
  final String? status;

  static const fromJson = ToiletSupplyStockModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletAttendanceModel with ToiletAttendanceModelMappable {
  const ToiletAttendanceModel({this.summary, this.staff = const []});

  final ToiletAttendanceSummaryModel? summary;
  final List<ToiletStaffModel> staff;

  static const fromJson = ToiletAttendanceModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletAttendanceSummaryModel with ToiletAttendanceSummaryModelMappable {
  const ToiletAttendanceSummaryModel({
    this.present,
    this.late,
    this.notCheckedIn,
    this.total,
  });

  final int? present;
  final int? late;
  final int? notCheckedIn;
  final int? total;

  static const fromJson = ToiletAttendanceSummaryModelMapper.fromJson;
}

/// One person on the shift. TODO: the sample response had an empty list, so
/// the keys here are from the backend notes (name, phone, role, status,
/// check-in time).
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ToiletStaffModel with ToiletStaffModelMappable {
  const ToiletStaffModel({
    this.name,
    this.phone,
    this.role,
    this.status,
    this.checkInTime,
  });

  final String? name;
  final String? phone;
  final String? role;
  final String? status;
  final String? checkInTime;

  static const fromJson = ToiletStaffModelMapper.fromJson;
}
