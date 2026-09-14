import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import 'leave_requests_provider.dart';

part 'leave_request_details_provider.g.dart';

@riverpod
Future<LeaveRequestEntity> leaveRequestDetails(
  Ref ref,
  int leaveRequestId,
) async {
  ref.listen(leaveRequestsProvider, (previous, next) {
    if (previous?.isLoading == true && next.hasValue && !next.hasError) {
      ref.invalidateSelf();
    }
  });

  final result = await ref
      .read(getLeaveRequestDetailsUseCaseProvider)
      .call(leaveRequestId);

  return result.when(
    success: (data) => data!,
    error: (error) => throw error,
  );
}
