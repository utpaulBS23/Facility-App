part of 'apply_leave_page.dart';

class LeaveRequestsPage extends ConsumerStatefulWidget {
  const LeaveRequestsPage({super.key});

  @override
  ConsumerState<LeaveRequestsPage> createState() => _LeaveRequestsPageState();
}

class _LeaveRequestsPageState extends ConsumerState<LeaveRequestsPage> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<String> _filters = [
    'All',
    'Pending',
    'Manager Approval',
    'Approved',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _searchQuery = _searchController.text.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final approvalsState = ref.watch(leaveApprovalsProvider());

    final canApplyLeave =
        ref
            .watch(hasPermissionUseCaseProvider)
            .call(AppPermission.leaveRequest) ||
        ref
            .watch(hasPermissionUseCaseProvider)
            .call(AppPermission.leaveFileOnBehalf);

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Row(
            children: [
              Icon(Icons.chevron_left_rounded, color: color.primary, size: 28),
              Text(
                context.locale.back,
                style: context.textStyle.labelXl.copyWith(color: color.primary),
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
      body: approvalsState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (requests) => Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.s16,
                vertical: spacing.s8,
              ),
              child: _LeaveSupervisorSummaryCard(
                pendingCount: requests
                    .where((r) => r.status == 'pending_supervisor')
                    .length,
                managerCount: requests
                    .where((r) => r.status == 'pending_manager')
                    .length,
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
                filters: _filters,
                selectedFilter: _selectedFilter,
                onFilterSelected: (filter) =>
                    setState(() => _selectedFilter = filter),
              ),
            ),

            Expanded(
              child: _LeaveRequestsList(
                requests: requests,
                selectedFilter: _selectedFilter,
                searchQuery: _searchQuery,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: canApplyLeave
          ? FloatingActionButton(
              onPressed: () => context.pushNamed(Routes.applyLeave),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r12,
                ),
              ),

              backgroundColor: color.primary,
              child: const Icon(Icons.add, size: 28),
            )
          : null,
    );
  }
}
