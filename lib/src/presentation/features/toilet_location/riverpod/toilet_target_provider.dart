import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/toilet_location/toilet_target_entity.dart';

part 'toilet_target_provider.g.dart';

@riverpod
Future<ToiletTargetEntity> toiletTarget(Ref ref, int facilityId) async {
  final yearMonth = DateFormat('yyyy-MM').format(DateTime.now());

  final result = await ref
      .read(getToiletTargetUseCaseProvider)
      .call(facilityId: facilityId, yearMonth: yearMonth);

  return result.when(
    success: (data) => data!,
    error: (error) => throw error,
  );
}
