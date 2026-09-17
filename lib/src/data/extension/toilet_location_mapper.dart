import '../../domain/entities/common/paginated_list_entity.dart';
import '../../domain/entities/toilet_location/toilet_entity.dart';
import '../../domain/entities/toilet_location/toilet_list_page_entity.dart';
import '../../domain/entities/toilet_location/toilet_status.dart';
import '../../domain/entities/toilet_location/toilet_target_entity.dart';
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

extension ToiletTargetListResponseModelToEntity on ToiletTargetListResponseModel {
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
