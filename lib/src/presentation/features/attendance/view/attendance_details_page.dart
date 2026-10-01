part of 'attendance_page.dart';

class AttendanceDetailsPage extends ConsumerStatefulWidget {
  const AttendanceDetailsPage({super.key, required this.attendance});

  final AttendanceItemEntity attendance;

  @override
  ConsumerState<AttendanceDetailsPage> createState() =>
      _AttendanceDetailsPageState();
}

class _AttendanceDetailsPageState extends ConsumerState<AttendanceDetailsPage> {
  late AttendanceItemEntity _current;
  // WHY: UI-only for now — approve/reject take no body per the backend doc,
  // so there's nowhere to send a corrected time yet. Defaults to whichever
  // phase is currently pending so a supervisor can review/correct it before
  // that API support lands.
  late TimeOfDay _reviewTime;

  @override
  void initState() {
    super.initState();
    _current = widget.attendance;
    _reviewTime = TimeOfDay.fromDateTime(_defaultReviewDateTime);
  }

  bool get _isCheckOutPhase =>
      _current.approvalStatus == AttendanceApprovalStatus.pendingCheckOut;

  // WHY ownership check: check-out is self-only on the backend — a
  // supervisor viewing an attendant's entry can never check out on their
  // behalf, only the attendant themselves.
  bool get _showCheckOutButton =>
      _current.id != null &&
      _current.userId == ref.read(getCurrentUserUseCaseProvider).call()?.id &&
      _current.checkInTime != null &&
      _current.checkOutTime == null &&
      _current.approvalStatus != AttendanceApprovalStatus.rejectedCheckIn &&
      _current.approvalStatus != AttendanceApprovalStatus.rejected &&
      _current.approvalStatus != AttendanceApprovalStatus.absent;

  DateTime get _defaultReviewDateTime =>
      (_isCheckOutPhase ? _current.checkOutTime : _current.checkInTime) ??
      DateTime.now();

  void _onApprove() {
    if (_current.id == null) return;
    ref
        .read(approveAttendanceProvider.notifier)
        .approve(attendanceId: _current.id!);
  }

  void _onReject() {
    if (_current.id == null) return;
    ref
        .read(rejectAttendanceProvider.notifier)
        .reject(attendanceId: _current.id!);
  }

  void _onCheckOut(BuildContext context) {
    context.pushNamed(
      Routes.shiftCheckOut,
      extra: (attendanceId: _current.id!, checkInDate: _current.checkInTime),
    );
  }

  void _showError(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.localizedMessage(context)),
        backgroundColor: context.color.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(approveAttendanceProvider, (_, next) {
      if (next is AsyncData && next.value != null) {
        setState(() => _current = next.value!);
      } else if (next is AsyncError) {
        _showError(next.error!);
      }
    });

    ref.listen(rejectAttendanceProvider, (_, next) {
      if (next is AsyncData && next.value != null) {
        setState(() => _current = next.value!);
      } else if (next is AsyncError) {
        _showError(next.error!);
      }
    });

    final isApproving = ref.watch(approveAttendanceProvider).isLoading;
    final isRejecting = ref.watch(rejectAttendanceProvider).isLoading;
    final isPending = _current.approvalStatus.isPendingStage;
    final allowReject = _current.approvalStatus.isRejectable;
    // WHY independent checks instead of one OR-gate: a user holding only
    // attendance.reject (no attendance.approve) must never see an Approve
    // button they aren't allowed to press, and vice versa.
    final canApprove = ref.watch(
      userSessionProvider.select(
        (session) =>
            session?.canAny([UserPermission.attendanceApprove]) ?? false,
      ),
    );
    final canReject = ref.watch(
      userSessionProvider.select(
        (session) =>
            session?.canAny([UserPermission.attendanceReject]) ?? false,
      ),
    );
    final showApprove = isPending && canApprove;
    final showReject = allowReject && canReject;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.attendanceDetails),
      body: Column(
        children: [
          Expanded(child: _AttendanceDetailsBody(detail: _current)),
          // WHY gate on the real backend permissions rather than inferring
          // "supervisor" from the absence of attendance.check_in — the backend
          // ships attendance.approve/.reject explicitly, so the proxy is
          // obsolete. Approve and Reject are checked independently (see
          // canApprove/canReject above) so a reject-only reviewer never sees
          // an Approve button they can't press, and vice versa.
          if (isPending && (showApprove || showReject))
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.dimensions.padding.p16,
                    0,
                    context.dimensions.padding.p16,
                    context.dimensions.spacing.s8,
                  ),
                  child: AppTimeField(
                    label: _isCheckOutPhase
                        ? context.locale.checkOutTime
                        : context.locale.checkInTime,
                    time: _reviewTime,
                    onChanged: (time) => setState(() => _reviewTime = time),
                  ),
                ),
                _ApproveRejectBar(
                  onApprove: _onApprove,
                  onReject: _onReject,
                  isApproving: isApproving,
                  isRejecting: isRejecting,
                  allowReject: showReject,
                  allowApprove: showApprove,
                ),
              ],
            ),
          if (_showCheckOutButton)
            PermissionGate(
              permissions: const [UserPermission.attendanceCheckOut],
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.dimensions.padding.p16,
                    0,
                    context.dimensions.padding.p16,
                    context.dimensions.spacing.s16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: context.dimensions.spacing.s44,
                    child: FilledButton.icon(
                      onPressed: () => _onCheckOut(context),
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(context.locale.checkOut),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
