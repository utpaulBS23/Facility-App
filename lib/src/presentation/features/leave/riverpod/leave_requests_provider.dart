import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/common/paginated_list_entity.dart';
import '../../../../domain/entities/leave/leave_filter.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import 'apply_leave_provider/submit_leave_request_provider.dart';

part 'leave_requests_provider.g.dart';

/// Holding any one of these means the user approves leave at some step.
const leaveApprovalPermissions = [
  UserPermission.leaveApproveStep1,
  UserPermission.leaveApproveStep2,
  UserPermission.leaveApproveStep3,
];

enum LeaveTab {
  myLeave,
  leaveApprovals,
}

@riverpod
class SelectedLeaveTab extends _$SelectedLeaveTab {
  @override
  LeaveTab build() {
    // WHY by permission: approvers land on the approvals they came to act on.
    // Anyone else would hit a 403 on that endpoint, so they start on My leave.
    final canApprove =
        ref.read(userSessionProvider)?.canAny(leaveApprovalPermissions) ??
        false;

    return canApprove ? LeaveTab.leaveApprovals : LeaveTab.myLeave;
  }

  void selectTab(LeaveTab tab) {
    state = tab;
  }
}

@riverpod
class LeaveRequests extends _$LeaveRequests {
  String _searchQuery = '';
  LeaveFilter _selectedFilter = LeaveFilter.all;
  int _page = 1;
  bool _hasMore = false;
  bool _loadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<LeaveRequestEntity>> build() async {
    ref.listen(submitLeaveRequestProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        ref.invalidateSelf();
      }
    });

    ref.listen(selectedLeaveTabProvider, (previous, next) {
      if (previous != next) {
        ref.invalidateSelf();
      }
    });

    final currentTab = ref.watch(selectedLeaveTabProvider);

    return _load(tab: currentTab, filter: _selectedFilter);
  }

  // WHY no `state` writes here: build() returns this future, and Riverpod
  // completes it itself. Setting state mid-build completes it twice and
  // throws "Future already completed".
  Future<List<LeaveRequestEntity>> _load({
    required LeaveTab tab,
    required LeaveFilter filter,
  }) async {
    if (tab == LeaveTab.leaveApprovals) {
      final result = await ref
          .read(getLeaveRequestsUseCaseProvider)
          .call(status: filter.status, page: 1);

      return switch (result) {
        Success(:final data) when data != null => _applyPage(data),
        Error(:final error) => throw error,
        _ => const [],
      };
    }

    // WHY not paginated: `my-leaves` returns the caller's own leaves in one
    // response.
    _page = 1;
    _hasMore = false;
    final result = await ref
        .read(getMyLeavesUseCaseProvider)
        .call(status: filter.status);

    return switch (result) {
      Success(:final data) => data ?? const [],
      Error(:final error) => throw error,
      _ => throw Failure.emptyResponse('load leave requests'),
    };
  }

  List<LeaveRequestEntity> _applyPage(PaginatedListEntity<LeaveRequestEntity> page) {
    _page = page.currentPage;
    _hasMore = page.hasMore;
    return page.items;
  }

  /// Appends the next approvals page. Does nothing while one is loading, at
  /// the end, or on the My leave tab.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !_hasMore || _loadingMore) return;

    _loadingMore = true;
    try {
      final result = await ref
          .read(getLeaveRequestsUseCaseProvider)
          .call(status: _selectedFilter.status, page: _page + 1);

      switch (result) {
        case Success(:final data) when data != null:
          state = AsyncValue.data([...current, ..._applyPage(data)]);
        case Success():
        case Error():
          // WHY quiet: the next scroll to the end tries again.
          break;
      }
    } finally {
      _loadingMore = false;
    }
  }

  /// Reloads outside of build (search, filter, retry) and publishes the result.
  Future<void> fetch({
    String search = '',
    LeaveFilter filter = LeaveFilter.all,
  }) async {
    _searchQuery = search;
    _selectedFilter = filter;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _load(tab: ref.read(selectedLeaveTabProvider), filter: filter),
    );
  }

  void search(String query) {
    fetch(search: query, filter: _selectedFilter);
  }

  void filter(LeaveFilter filter) {
    fetch(search: _searchQuery, filter: filter);
  }

  Future<void> approve(int leaveRequestId) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(approveLeaveUseCaseProvider)
        .call(leaveRequestId);
    result.when(
      success: (_) => ref.invalidateSelf(),
      error: (error) => state = AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<void> reject(int leaveRequestId, {String? reason}) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(rejectLeaveUseCaseProvider)
        .call(leaveRequestId, reason: reason);
    result.when(
      success: (_) => ref.invalidateSelf(),
      error: (error) => state = AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<void> cancel(int leaveRequestId) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(cancelLeaveUseCaseProvider)
        .call(leaveRequestId);
    result.when(
      success: (_) => ref.invalidateSelf(),
      error: (error) => state = AsyncValue.error(error, StackTrace.current),
    );
  }
}
