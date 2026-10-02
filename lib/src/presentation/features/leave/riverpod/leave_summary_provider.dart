import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_summary_entity.dart';
import 'leave_requests_provider.dart';

part 'leave_summary_provider.g.dart';

/// Counts for the leave approvals screen's top cards. Only watched on the
/// approvals tab, because the endpoint needs an approval permission.
@riverpod
class LeaveSummary extends _$LeaveSummary {
  @override
  Future<LeaveSummaryEntity> build() async {
    // WHY: approve, reject, cancel and a newly filed request all end with the
    // list reloading, and each one changes these counts. Same listener as
    // leaveRequestDetails.
    ref.listen(leaveRequestsProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && !next.hasError) {
        ref.invalidateSelf();
      }
    });

    return fetch();
  }

  Future<LeaveSummaryEntity> fetch({int? facilityId}) async {
    final result = await ref
        .read(getLeaveApprovalsSummaryUseCaseProvider)
        .call(facilityId: facilityId);

    return result.when(
      success: (data) => data!,
      error: (error) => throw error,
    );
  }
}
