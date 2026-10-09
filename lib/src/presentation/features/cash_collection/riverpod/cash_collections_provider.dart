import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/cash_collection/cash_collection_entity.dart';
import '../../../../domain/entities/cash_collection/cash_collection_filter.dart';

part 'cash_collections_provider.g.dart';

/// Manual income (cash collection) entries for [facilityId] (null = every
/// accessible facility) in [month] (`yyyy-MM`).
///
/// WHY one big page: the screen shows a month at a time with its summary
/// cards, so the first page of up to 100 entries covers it.
@riverpod
Future<CashCollectionListResultEntity> cashCollections(
  Ref ref, {
  int? facilityId,
  String? month,
}) async {
  final result = await ref
      .read(getCashCollectionsUseCaseProvider)
      .call(
        CashCollectionFilter(
          facilityId: facilityId,
          month: month,
          pageSize: 100,
        ),
      );

  return switch (result) {
    Success(:final data) =>
      data ?? const CashCollectionListResultEntity.empty(),
    Error(:final error) => throw error,
    _ => throw Failure.emptyResponse('get cash collections'),
  };
}
