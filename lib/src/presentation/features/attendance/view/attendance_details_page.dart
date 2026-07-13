part of 'attendance_page.dart';

class AttendanceDetailsPage extends ConsumerStatefulWidget {
  const AttendanceDetailsPage({super.key, required this.attendance});

  final AttendanceItemEntity attendance;

  @override
  ConsumerState<AttendanceDetailsPage> createState() =>
      _AttendanceDetailsPageState();
}

class _AttendanceDetailsPageState
    extends ConsumerState<AttendanceDetailsPage> {
  late AttendanceItemEntity _current;
  late bool _isSupervisor;

  @override
  void initState() {
    super.initState();
    _current = widget.attendance;
    // WHY: read once in initState — permissions never change mid-session,
    // avoids repeated ref.read inside build(). Supervisor variant = not a
    // shift attendant, since user_role no longer exists.
    _isSupervisor = !(ref
            .read(getUserSessionUseCaseProvider)
            .call()
            ?.isShiftAttendant ??
        true);
  }

  int? get _partnerId =>
      ref.read(getCurrentUserUseCaseProvider).call()?.partnerId;

  void _onApprove() {
    final partnerId = _partnerId;
    if (partnerId == null) return;
    ref.read(approveAttendanceProvider.notifier).approve(
      partnerId: partnerId,
      attendanceId: _current.id,
    );
  }

  void _onReject() {
    final partnerId = _partnerId;
    if (partnerId == null) return;
    ref.read(rejectAttendanceProvider.notifier).reject(
      partnerId: partnerId,
      attendanceId: _current.id,
    );
  }

  void _showError(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
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
          Expanded(
            child: _AttendanceDetailsBody(detail: _current),
          ),
          if (_isSupervisor && isPending)
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

