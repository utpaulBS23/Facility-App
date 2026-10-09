import 'package:retrofit/retrofit.dart' show HttpResponse;

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/toilet_location/toilet_filter.dart';
import '../../domain/entities/toilet_location/toilet_list_page_entity.dart';
import '../../domain/entities/toilet_location/toilet_target_entity.dart';
import '../../domain/repositories/toilet_location_repository.dart';
import '../../domain/entities/toilet_location/facility_report_sources_entity.dart';
import '../extension/facility_report_sources_mapper.dart';
import '../extension/facility_wise_report_mapper.dart';
import '../models/facility_report/facility_report_source_models.dart';
import '../extension/toilet_location_mapper.dart';
import '../../domain/entities/toilet_location/facility_wise_report_entity.dart';
import '../models/toilet_location/facility_wise_report_model.dart';
import '../../domain/entities/toilet_location/toilet_details_entity.dart';
import '../models/toilet_location/toilet_details_model.dart';
import '../models/toilet_location/toilet_response_model.dart';
import '../models/toilet_location/toilet_target_model.dart';
import '../services/network/rest_client.dart';

final class ToiletLocationRepositoryImpl extends ToiletLocationRepository {
  ToiletLocationRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<ToiletListPageEntity, Failure>> getToilets(
    ToiletListQueryFilter filter,
  ) {
    return asyncGuard(() async {
      final response = await remote.getFacilities(
        partnerId: filter.partnerId!,
        status: filter.status?.toWireString(),
        page: filter.page,
        perPage: filter.pageSize,
      );
      final responseModel = ToiletListResponseModel.fromJson(response.data);
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<ToiletDetailsEntity, Failure>> getToiletDetails({
    required int partnerId,
    required int facilityId,
  }) {
    return asyncGuard(() async {
      final response = await remote.getFacilityDetails(
        partnerId: partnerId,
        facilityId: facilityId,
      );
      return ToiletDetailsModel.fromJson(response.data).toEntity();
    });
  }

  @override
  Future<Result<ToiletTargetEntity, Failure>> getToiletTarget({
    required int partnerId,
    required int facilityId,
    required String yearMonth,
  }) {
    return asyncGuard(() async {
      final response = await remote.getFacilityWiseTargets(
        partnerId: partnerId,
        facilityId: facilityId,
        yearMonth: yearMonth,
      );
      final responseModel = ToiletTargetListResponseModel.fromJson(
        response.data,
      );
      return responseModel.toEntity();
    });
  }

  @override
  Future<Result<FacilityReportSources, Failure>> getFacilityReportSources({
    required int partnerId,
    required String month,
  }) {
    return asyncGuard(() async {
      final from = '$month-01';
      final to = _lastDay(month);

      // WHY all at once: the report adds up every record of the month; the
      // seven lists do not depend on each other.
      final results = await Future.wait([
        _all(
          (p) => remote.getCashCollections(
            partnerId: partnerId,
            month: month,
            page: p,
            perPage: _pageSize,
          ),
        ),
        _all(
          (p) => remote.getAdditionalIncomes(
            partnerId: partnerId,
            status: 'approved',
            from: from,
            to: to,
            page: p,
            perPage: _pageSize,
          ),
        ),
        _all(
          (p) => remote.getProductSaleEntries(
            partnerId: partnerId,
            month: month,
            page: p,
            perPage: _pageSize,
          ),
        ),
        _all(
          (p) => remote.getFacilityExpenses(
            partnerId: partnerId,
            from: from,
            to: to,
            page: p,
            perPage: _pageSize,
          ),
        ),
        _all(
          (p) => remote.getFacilityAccesses(
            partnerId: partnerId,
            month: month,
            page: p,
            perPage: _pageSize,
          ),
        ),
        _all(
          (p) => remote.getCenterCollections(
            partnerId: partnerId,
            month: month,
            page: p,
            perPage: _pageSize,
          ),
        ),
        _all(
          (p) => remote.getTransactions(
            partnerId: partnerId,
            type: 'package_purchase',
            from: from,
            to: to,
            page: p,
            perPage: _pageSize,
          ),
        ),
      ]);

      return FacilityReportSources(
        cash: [
          for (final r in results[0])
            ReportCashCollectionModel.fromJson(r).toRecord(),
        ],
        extras: [
          for (final r in results[1])
            ReportExtraIncomeModel.fromJson(r).toRecord(),
        ],
        products: [
          for (final r in results[2])
            ReportProductSaleModel.fromJson(r).toRecord(),
        ],
        expenses: [
          for (final r in results[3]) ReportExpenseModel.fromJson(r).toRecord(),
        ],
        accesses: [
          for (final r in results[4]) ReportAccessModel.fromJson(r).toRecord(),
        ],
        centers: [
          for (final r in results[5])
            ReportCenterCollectionModel.fromJson(r).toRecord(),
        ],
        transactions: [
          for (final r in results[6])
            ReportTransactionModel.fromJson(r).toRecord(),
        ],
      );
    });
  }

  static const _pageSize = 100;

  /// `2026-08` to `2026-08-31`.
  static String _lastDay(String month) {
    final parts = month.split('-');
    final last = DateTime(int.parse(parts[0]), int.parse(parts[1]) + 1, 0);

    return '$month-${last.day.toString().padLeft(2, '0')}';
  }

  /// Every row of a paged list: pages are read until `meta.last_page`.
  Future<List<Map<String, dynamic>>> _all(
    Future<HttpResponse> Function(int page) fetch,
  ) async {
    final rows = <Map<String, dynamic>>[];
    var page = 1;
    var lastPage = 1;
    do {
      final response = await fetch(page);
      final body = response.data as Map<String, dynamic>;
      rows.addAll([
        for (final r in (body['data'] as List? ?? const []))
          Map<String, dynamic>.from(r as Map),
      ]);
      final meta = body['meta'];
      lastPage = meta is Map ? (meta['last_page'] as num?)?.toInt() ?? 1 : 1;
      page++;
    } while (page <= lastPage);

    return rows;
  }

  @override
  Future<Result<FacilityWiseReportEntity, Failure>> getFacilityWiseReport({
    required int partnerId,
    required int facilityId,
    required String month,
  }) {
    return asyncGuard(() async {
      final response = await remote.getFacilityWiseReport(
        partnerId: partnerId,
        month: month,
        facilityId: facilityId,
      );
      return FacilityWiseReportResponseModel.fromJson(response.data).toEntity();
    });
  }
}
