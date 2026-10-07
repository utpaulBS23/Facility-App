import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/toilet_location/toilet_entity.dart';
import '../../domain/entities/toilet_location/toilet_list_page_entity.dart';
import '../../domain/entities/toilet_location/toilet_status.dart';
import '../../domain/entities/toilet_location/toilet_target_entity.dart';
import '../../domain/entities/toilet_location/toilet_details_entity.dart';
import '../models/toilet_location/toilet_details_model.dart';
import '../models/toilet_location/toilet_model.dart';
import '../models/toilet_location/toilet_response_model.dart';
import '../models/toilet_location/toilet_target_model.dart';

extension ToiletModelMapper on ToiletModel {
  ToiletEntity toEntity() {
    return ToiletEntity(
      id: id,
      name: name,
      address: address ?? '',
      status: ToiletStatus.fromWireString(status),
      averageRating: averageRating ?? 0,
      lat: lat ?? 0,
      lng: lng ?? 0,
      mapsLink: mapsLink ?? '',
      facilityType: facilityType ?? '',
      supervisorName: supervisor?['name']?.toString() ?? '',
      openingTime: openingTime,
      closingTime: closingTime,
      is24Hours: is24Hours ?? false,
      operatingDays: operatingDays ?? const [],
      isFree: isFree ?? false,
      usageFee: usageFee ?? 0,
      disableFriendly: disableFriendly ?? false,
      visitsToday: visitsToday ?? 0,
      revenue: revenue ?? 0,
    );
  }
}

extension ToiletSummaryModelMapper on ToiletSummaryModel {
  ToiletSummaryEntity toEntity() {
    return ToiletSummaryEntity(total: total ?? 0, active: active ?? 0);
  }
}

extension ToiletListResponseModelToEntity on ToiletListResponseModel {
  ToiletListPageEntity toEntity() {
    final items = data.map((model) => model.toEntity()).toList();
    final curPage = meta?.currentPage ?? 1;
    final size = meta?.perPage ?? 20;
    final total = meta?.total ?? items.length;
    final hasMore = meta?.lastPage != null
        ? curPage < meta!.lastPage!
        : (curPage * size) < total;

    return ToiletListPageEntity(
      list: PaginatedListEntity<ToiletEntity>(
        items: items,
        currentPage: curPage,
        pageSize: size,
        totalRecords: total,
        hasMore: hasMore,
      ),
      summary: summary?.toEntity() ?? const ToiletSummaryEntity(),
    );
  }
}

extension ToiletTargetModelMapper on ToiletTargetModel {
  ToiletTargetEntity toEntity() {
    return ToiletTargetEntity(
      supervisorName: supervisorName ?? '',
      supervisorNameBn: supervisorNameBn ?? '',
      targetRevenue: targetRevenue,
      actualRevenue: actualRevenue ?? 0,
      hasActuals: actualRevenue != null,
      hasTarget: true,
      targetProfit: targetProfit ?? 0,
      targetAttendancePct: targetAttendancePct ?? 0,
      targetCompliancePct: targetCompliancePct ?? 0,
    );
  }
}

extension ToiletTargetListResponseModelToEntity
    on ToiletTargetListResponseModel {
  /// Empty `data` means no target has been set for this facility/month yet
  /// — not an error, so this returns a "not set" entity instead of `null`.
  ToiletTargetEntity toEntity() {
    if (data.isEmpty) {
      return const ToiletTargetEntity(
        supervisorName: '',
        targetRevenue: 0,
        actualRevenue: 0,
        hasActuals: false,
        hasTarget: false,
        targetProfit: 0,
        targetAttendancePct: 0,
        targetCompliancePct: 0,
      );
    }
    return data.first.toEntity();
  }
}

extension ToiletPlaceholderValueMapper on ToiletPlaceholderValueModel? {
  /// The label (or the value) as text, or null while the server marks it as a
  /// placeholder or sends nothing.
  String? get text {
    final model = this;
    if (model == null || model.isPlaceholder == true) return null;
    final label = model.label;
    if (label != null && label.isNotEmpty) return label;
    final value = model.value;

    return value == null ? null : value.toString();
  }
}

extension ToiletDetailsModelToEntity on ToiletDetailsModel {
  ToiletDetailsEntity toEntity() {
    final access = consumerAccess;
    final income = incomeTargetAndGoal;
    final progress = monthlyProgress;
    final management = managementInformation;
    final summary = attendance?.summary;
    final distance = distanceKm;

    return ToiletDetailsEntity(
      id: id,
      code: code.text,
      distanceKm: distance == null || distance.isPlaceholder == true
          ? null
          : distance.value is num
          ? distance.value as num
          : null,
      visitsToday: access?.today ?? 0,
      visitsThisWeek: access?.thisWeek ?? 0,
      visitsThisMonth: access?.thisMonth ?? 0,
      hourly: [
        for (final h in access?.hourly ?? const <ToiletHourlyModel>[])
          ToiletHourlyVisit(
            hour: h.hour,
            count: h.count ?? 0,
            isPeak: h.isPeak ?? false,
          ),
      ],
      peakHoursLabel: access?.peakHoursLabel,
      dailyTarget: income?.dailyTarget ?? 0,
      todayAchieved: income?.todayAchieved ?? 0,
      monthlyTarget: income?.monthlyTarget ?? 0,
      monthAchieved: income?.monthAchieved ?? 0,
      progressTarget: progress?.target ?? 0,
      progressAchieved: progress?.achieved ?? 0,
      progressRemaining: progress?.remaining ?? 0,
      percentComplete: progress?.percentComplete ?? 0,
      daysLeft: progress?.daysLeft ?? 0,
      airQuality: management?.airQuality.text,
      cleaningFrequency: management?.cleaningFrequency.text,
      lastCleaningAt: management?.lastCleaningAt.text,
      supplyStock: [
        for (final s in supplyStock)
          if ((s.itemName ?? '').isNotEmpty)
            ToiletSupplyItem(
              name: s.itemName!,
              level: ToiletSupplyLevel.fromWire(s.status),
              unit: s.unit ?? '',
              quantity: s.currentQty,
            ),
      ],
      present: summary?.present ?? 0,
      late: summary?.late ?? 0,
      notCheckedIn: summary?.notCheckedIn ?? 0,
      staff: [
        for (final p in attendance?.staff ?? const <ToiletStaffModel>[])
          ToiletStaffMember(
            name: p.name ?? '',
            phone: p.phone ?? '',
            role: p.role ?? '',
            status: ToiletStaffStatus.fromWire(p.status),
            checkInTime: p.checkInTime,
          ),
      ],
    );
  }
}
