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

  @override
  void initState() {
    super.initState();
    _current = widget.attendance;
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

    final isSupervisor =
        ref.read(getCurrentUserUseCaseProvider).call()?.userRole ==
            UserRole.supervisor;
    final isApproving = ref.watch(approveAttendanceProvider).isLoading;
    final isRejecting = ref.watch(rejectAttendanceProvider).isLoading;
    final isPending = _current.status == 'pending';

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
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
          if (isSupervisor && isPending)
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

class _ApproveRejectBar extends StatelessWidget {
  const _ApproveRejectBar({
    required this.onApprove,
    required this.onReject,
    required this.isApproving,
    required this.isRejecting,
  });

  final VoidCallback onApprove;
  final VoidCallback onReject;
  final bool isApproving;
  final bool isRejecting;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final padding = context.dimensions.padding;
    final busy = isApproving || isRejecting;

    return Container(
      padding: EdgeInsets.fromLTRB(
        padding.p16,
        spacing.s12,
        padding.p16,
        spacing.s32,
      ),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border(top: BorderSide(color: context.color.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: busy ? null : onReject,
              style: OutlinedButton.styleFrom(
                foregroundColor: context.color.error,
                side: BorderSide(color: context.color.error),
              ),
              child: isRejecting
                  ? const LoadingIndicator()
                  : Text(context.locale.reject),
            ),
          ),
          Gap(spacing.s12),
          Expanded(
            child: FilledButton(
              onPressed: busy ? null : onApprove,
              child: isApproving
                  ? const LoadingIndicator()
                  : Text(context.locale.approve),
            ),
          ),
        ],
      ),
    );
  }
}
