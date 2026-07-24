part of 'apply_leave_page.dart';

class MockLeaveRequest {
  MockLeaveRequest({
    required this.id,
    required this.employeeName,
    required this.status,
    required this.statusColor,
    required this.leaveType,
    required this.dateRange,
    required this.location,
    required this.timeAgo,
  });

  final int id;
  String employeeName;
  String status;
  Color statusColor;
  String leaveType;
  String dateRange;
  String location;
  String timeAgo;
}

class LeaveRequestsPage extends StatefulWidget {
  const LeaveRequestsPage({super.key});

  @override
  State<LeaveRequestsPage> createState() => _LeaveRequestsPageState();
}

class _LeaveRequestsPageState extends State<LeaveRequestsPage> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Pending',
    'Manager Approval',
    'Approved',
  ];

  late List<MockLeaveRequest> _allRequests;

  @override
  void initState() {
    super.initState();
    // Default mock data matching the blueprint
    _allRequests = [
      MockLeaveRequest(
        id: 1,
        employeeName: 'Kamal Hossain',
        status: 'Pending',
        statusColor: const Color(0xFFF2994A), // Orange
        leaveType: 'Sick Leave',
        dateRange: 'Feb 12, 2026 → Feb 14, 2026',
        location: '📍 Mirpur-10, Dhaka',
        timeAgo: '2 hours ago',
      ),
      MockLeaveRequest(
        id: 2,
        employeeName: 'Nasima Akter',
        status: 'Manager approval',
        statusColor: const Color(0xFF2F80ED), // Blue
        leaveType: 'Annual Leave',
        dateRange: 'Feb 16, 2026 → Feb 19, 2026',
        location: '📍 Gulshan-2 Toilet',
        timeAgo: '2 hours ago',
      ),
      MockLeaveRequest(
        id: 3,
        employeeName: 'Rashedul Islam',
        status: 'Approved',
        statusColor: const Color(0xFF27AE60), // Green
        leaveType: 'Casual Leave',
        dateRange: 'Feb 20, 2026 → Feb 22, 2026',
        location: '📍 Dhanmondi, Dhaka',
        timeAgo: '1 day ago',
      ),
      MockLeaveRequest(
        id: 4,
        employeeName: 'Tania Sultana',
        status: 'Rejected',
        statusColor: const Color(0xFFEB5757), // Red
        leaveType: 'Sick Leave',
        dateRange: 'Feb 25, 2026 → Feb 26, 2026',
        location: '📍 Banani, Dhaka',
        timeAgo: '2 days ago',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onApprove(int id) {
    setState(() {
      final requestIndex = _allRequests.indexWhere((r) => r.id == id);
      if (requestIndex != -1) {
        _allRequests[requestIndex] = MockLeaveRequest(
          id: id,
          employeeName: _allRequests[requestIndex].employeeName,
          status: 'Approved',
          statusColor: const Color(0xFF27AE60), // Green
          leaveType: _allRequests[requestIndex].leaveType,
          dateRange: _allRequests[requestIndex].dateRange,
          location: _allRequests[requestIndex].location,
          timeAgo: 'Just now',
        );
      }
    });
  }

  void _onReject(int id) {
    setState(() {
      final requestIndex = _allRequests.indexWhere((r) => r.id == id);
      if (requestIndex != -1) {
        _allRequests[requestIndex] = MockLeaveRequest(
          id: id,
          employeeName: _allRequests[requestIndex].employeeName,
          status: 'Rejected',
          statusColor: const Color(0xFFEB5757), // Red
          leaveType: _allRequests[requestIndex].leaveType,
          dateRange: _allRequests[requestIndex].dateRange,
          location: _allRequests[requestIndex].location,
          timeAgo: 'Just now',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    // Calculate dynamic summary counts
    final waitingForApprovalCount = _allRequests
        .where((r) => r.status.toLowerCase() == 'pending')
        .length;
    final managerApprovalCount = _allRequests
        .where((r) => r.status.toLowerCase() == 'manager approval')
        .length;

    // Filter requests
    final filteredRequests = _allRequests.where((r) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Pending') {
        return r.status.toLowerCase() == 'pending';
      }
      if (_selectedFilter == 'Manager Approval') {
        return r.status.toLowerCase() == 'manager approval';
      }
      if (_selectedFilter == 'Approved') {
        return r.status.toLowerCase() == 'approved';
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: color.primary,
                size: 28,
              ),
              Text(
                context.locale.back,
                style: textStyle.labelXl.copyWith(
                  color: color.primary,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
        title: Headline2xlTinyText(context.locale.leaveRequests),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.s16,
              spacing.s16,
              spacing.s16,
              spacing.s8,
            ),
            child: Row(
              children: [
                _LeaveSupervisorSummaryCard(
                  count: waitingForApprovalCount,
                  title: context.locale.waitingForApproval,
                ),
                Gap(spacing.s12),
                _LeaveSupervisorSummaryCard(
                  count: managerApprovalCount,
                  title: context.locale.managerApproval,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s16,
              vertical: spacing.s8,
            ),
            child: AppTextField.search(
              controller: _searchController,
              hint: context.locale.search,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s16,
              vertical: spacing.s8,
            ),
            child: _LeaveFilterBar(
              selectedFilter: _selectedFilter,
              filters: _filters,
              onFilterSelected: (filter) {
                setState(() => _selectedFilter = filter);
              },
            ),
          ),
          Expanded(
            child: filteredRequests.isEmpty
                ? Center(
                    child: Text(
                      context.locale.noRequestsFound,
                      style: textStyle.bodyMedium.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(spacing.s16),
                    itemCount: filteredRequests.length,
                    separatorBuilder: (context, index) => Gap(spacing.s12),
                    itemBuilder: (context, index) {
                      final request = filteredRequests[index];
                      return GestureDetector(
                        onTap: () async {
                          final updated = await context.pushNamed<MockLeaveRequest>(
                            Routes.leaveDetails,
                            extra: request,
                          );
                          if (updated != null && mounted) {
                            setState(() {
                              final index = _allRequests.indexWhere((r) => r.id == updated.id);
                              if (index != -1) {
                                _allRequests[index] = updated;
                              }
                            });
                          }
                        },
                        child: _LeaveRequestActionCard(
                          request: request,
                          onApprove: () => _onApprove(request.id),
                          onReject: () => _onReject(request.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(Routes.applyLeave);
        },
        backgroundColor: color.primary,
        foregroundColor: color.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ),
    );
  }
}
