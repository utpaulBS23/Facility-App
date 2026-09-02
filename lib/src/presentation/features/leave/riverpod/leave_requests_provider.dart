import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/leave/leave_filter.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import 'apply_leave_provider/submit_leave_request_provider.dart';

part 'leave_requests_provider.g.dart';

enum LeaveTab {
  myLeave,
  leaveApprovals,
}

@riverpod
class LeaveRequests extends _$LeaveRequests {
  String _searchQuery = '';
  LeaveFilter _selectedFilter = LeaveFilter.all;
  LeaveTab _currentTab = LeaveTab.myLeave;

  LeaveTab get currentTab => _currentTab;

  @override
  Future<List<LeaveRequestEntity>> build() async {
    ref.listen(submitLeaveRequestProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        ref.invalidateSelf();
      }
    });

    return fetch(
      tab: _currentTab,
      search: _searchQuery,
      filter: _selectedFilter,
    );
  }

  Future<List<LeaveRequestEntity>> fetch({
    LeaveTab? tab,
    String search = '',
    LeaveFilter filter = LeaveFilter.all,
  }) async {
    if (tab != null) _currentTab = tab;
    _searchQuery = search;
    _selectedFilter = filter;

    state = const AsyncValue.loading();

    final result = _currentTab == LeaveTab.leaveApprovals
        ? await ref
            .read(getLeaveApprovalsUseCaseProvider)
            .call(status: filter.status)
        : await ref
            .read(getMyLeavesUseCaseProvider)
            .call(status: filter.status);

    return switch (result) {
      Success(:final data) => _onFetchSuccess(data ?? const []),
      Error(:final error) => _onFetchError(error),
      _ => _onFetchError(Failure.emptyResponse('load leave requests')),
    };
  }

  List<LeaveRequestEntity> _onFetchSuccess(List<LeaveRequestEntity> list) {
    state = AsyncValue.data(list);
    return list;
  }

  List<LeaveRequestEntity> _onFetchError(Failure error) {
    state = AsyncValue.error(error, StackTrace.current);
    return const [];
  }

  void setTab(LeaveTab tab) {
    if (_currentTab == tab) return;
    fetch(tab: tab, search: _searchQuery, filter: _selectedFilter);
  }

  void search(String query) {
    fetch(tab: _currentTab, search: query, filter: _selectedFilter);
  }

  void filter(LeaveFilter filter) {
    fetch(tab: _currentTab, search: _searchQuery, filter: filter);
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
