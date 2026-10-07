import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/toilet_location/toilet_details_entity.dart';

part 'toilet_details_provider.g.dart';

/// Everything the toilet details page shows from the facility details
/// endpoint: access numbers, income goal, management info, stock, attendance.
@riverpod
Future<ToiletDetailsEntity> toiletDetails(Ref ref, int facilityId) async {
  final result = await ref
      .read(getToiletDetailsUseCaseProvider)
      .call(facilityId: facilityId);

  return result.when(success: (data) => data!, error: (error) => throw error);
}
