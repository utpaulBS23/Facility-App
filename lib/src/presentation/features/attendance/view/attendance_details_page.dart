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
        ref.invalidate(monthlyAttendanceOverviewProvider);
      } else if (next is AsyncError) {
        _showError(next.error!);
      }
    });

    ref.listen(rejectAttendanceProvider, (_, next) {
      if (next is AsyncData && next.value != null) {
        setState(() => _current = next.value!);
        ref.invalidate(monthlyAttendanceOverviewProvider);
      } else if (next is AsyncError) {
        _showError(next.error!);
      }
    });

    final isApproving = ref.watch(approveAttendanceProvider).isLoading;
    final isRejecting = ref.watch(rejectAttendanceProvider).isLoading;
    final isPending = _current.approvalStatus.isPendingStage;
    final allowReject = _current.approvalStatus.isRejectable;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.attendanceDetails),
      body: Column(
        children: [
          Expanded(child: _AttendanceDetailsBody(detail: _current)),
          // WHY gate on the real backend permissions rather than inferring
          // "supervisor" from the absence of attendance.check_in — the backend
          // ships attendance.approve/.reject explicitly, so the proxy is
          // obsolete.
          if (isPending)
            PermissionGate(
              permissions: const [
                UserPermission.attendanceApprove,
                UserPermission.attendanceReject,
              ],
              builder: (context, canReview) => canReview
                  ? Column(
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
                            onChanged: (time) =>
                                setState(() => _reviewTime = time),
                          ),
                        ),
                        _ApproveRejectBar(
                          onApprove: _onApprove,
                          onReject: _onReject,
                          isApproving: isApproving,
                          isRejecting: isRejecting,
                          allowReject: allowReject,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}
