import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/toilet_location/toilet_entity.dart';
import 'toilets_provider.dart';

part 'toilet_by_id_provider.g.dart';

/// Toilet [facilityId] from the toilet list, or null if the list does not hold
/// it (or has not loaded).
///
/// WHY from the list: it already carries everything the details page shows
/// from the server, so no second request is made.
@riverpod
ToiletEntity? toiletById(Ref ref, int facilityId) {
  final page = ref.watch(toiletsProvider).valueOrNull;

  return page?.list.items.where((t) => t.id == facilityId).firstOrNull;
}
