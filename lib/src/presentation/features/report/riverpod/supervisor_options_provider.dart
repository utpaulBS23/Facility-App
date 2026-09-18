import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/partner_staff_entity.dart';

part 'supervisor_options_provider.g.dart';

@riverpod
Future<List<PartnerStaffEntity>> supervisorOptions(Ref ref) async {
  final result = await ref
      .read(getPartnerStaffUseCaseProvider)
      .call(role: 'supervisor');
  return switch (result) {
    Success(:final data) => data ?? [],
    Error() => [],
    _ => [],
  };
}
