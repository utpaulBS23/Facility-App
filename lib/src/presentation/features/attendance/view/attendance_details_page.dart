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
  late bool _canReview;

  @override
  void initState() {
    super.initState();
    _current = widget.attendance;
    // WHY: gate on the real backend permissions rather than inferring
    // "supervisor" from the absence of attendance.check_in — the backend now
    // ships attendance.approve/.reject explicitly, so the proxy is obsolete.
    // Read once in initState: permissions never change mid-session.
    final session = ref.read(getUserSessionUseCaseProvider).call();
    _canReview =
        session?.canAny(const [
          UserPermission.attendanceApprove,
          UserPermission.attendanceReject,
        ]) ??
        false;
  }

  void _onApprove() {
    ref
        .read(approveAttendanceProvider.notifier)
        .approve(attendanceId: _current.id);
  }

  void _onReject() {
    ref
        .read(rejectAttendanceProvider.notifier)
        .reject(attendanceId: _current.id);
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
    final isPending = _current.status == 'pending';

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        // WHY: iOS-style back button — icon + label mimic native feel.
        leading: GestureDetector(
          onTap: context.pop,
          child: Row(
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: context.color.primary,
                size: 28,
              ),
              Text(
                context.locale.back,
                style: context.textStyle.labelXl.copyWith(
                  color: context.color.primary,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
        title: Headline2xlTinyText(context.locale.attendanceDetails),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(child: _AttendanceDetailsBody(detail: _current)),
          if (_canReview && isPending)
            _ApproveRejectBar(
              onApprove: _onApprove,
              onReject: _onReject,
              isApproving: isApproving,
              isRejecting: isRejecting,
            ),
        ],
      ),
    );
  }
}
