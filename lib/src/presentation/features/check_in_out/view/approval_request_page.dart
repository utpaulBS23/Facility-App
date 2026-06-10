part of 'shift_check_in_page.dart';

class ApprovalRequestPage extends ConsumerStatefulWidget {
  const ApprovalRequestPage({
    super.key,
    required this.attendance,
    required this.withdrawRoute,
  });

  final ManualAttendanceResponseEntity attendance;
  final String withdrawRoute;

  @override
  ConsumerState<ApprovalRequestPage> createState() =>
      _ApprovalRequestPageState();
}

class _ApprovalRequestPageState extends ConsumerState<ApprovalRequestPage> {
  late ManualAttendanceResponseEntity _current;

  @override
  void initState() {
    super.initState();
    _current = widget.attendance;
  }

  AttendanceStatue get _statue => switch (_current.status) {
    'approved' => AttendanceStatue.success,
    'rejected' => AttendanceStatue.reject,
    'need_face' => AttendanceStatue.needFace,
    _ => AttendanceStatue.pending,
  };

  int? get _partnerId =>
      ref.read(getCurrentUserUseCaseProvider).call()?.partnerId;

  void _onRefresh() {
    final partnerId = _partnerId;
    if (partnerId == null) return;
    ref.read(refreshAttendanceProvider.notifier).refresh(
      partnerId: partnerId,
      shiftId: _current.shiftId,
    );
  }

  void _onWithdraw() {
    final partnerId = _partnerId;
    if (partnerId == null) return;
    ref.read(withdrawAttendanceProvider.notifier).withdraw(
      partnerId: partnerId,
      attendanceId: _current.id,
    );
  }

  void _navigateBack() {
    if (widget.withdrawRoute == Routes.shiftCheckOut) {
      context.goNamed(Routes.shiftCheckOut, extra: _current.shiftId);
    } else {
      context.goNamed(widget.withdrawRoute);
    }
  }

  void _onNeedFace() => _navigateBack();

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
    ref.listen(refreshAttendanceProvider, (_, next) {
      if (next is AsyncData && next.value != null) {
        setState(() => _current = next.value!);
      } else if (next is AsyncError) {
        _showError(next.error!);
      }
    });

    ref.listen(withdrawAttendanceProvider, (_, next) {
      if (next is AsyncData && next.value == true) {
        _navigateBack();
      } else if (next is AsyncError) {
        _showError(next.error!);
      }
    });

    final isRefreshing = ref.watch(refreshAttendanceProvider).isLoading;
    final isWithdrawing = ref.watch(withdrawAttendanceProvider).isLoading;
    final spacing = context.dimensions.spacing;
    final statue = _statue;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Headline2xlTinyText(context.locale.approvalRequest),
        ),
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.dimensions.padding.p16,
              ),
              child: Column(
                spacing: context.dimensions.padding.p16,
                children: [
                  _ApprovalHeroSection(statue),
                  _AttendanceInfoCard(attendance: _current),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.dimensions.padding.p16,
                spacing.s16,
                context.dimensions.padding.p16,
                spacing.s16,
              ),
              child: _ApprovalActionButtons(
                attendanceStatue: statue,
                onWithdraw: _onWithdraw,
                onRefresh: _onRefresh,
                onNeedFace: _onNeedFace,
                isRefreshing: isRefreshing,
                isWithdrawing: isWithdrawing,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceInfoCard extends StatelessWidget {
  const _AttendanceInfoCard({required this.attendance});

  final ManualAttendanceResponseEntity attendance;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final locale = context.locale;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dimensions.padding.p16),
      decoration: BoxDecoration(
        color: colors.onPrimary,
        borderRadius: BorderRadius.circular(dimensions.radius.r12),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyRegularText.secondary(locale.attendanceDetails),
          Gap(dimensions.spacing.s8),
          _ContactInfoItem(
            icon: Icons.info_outline,
            label: locale.status,
            value: attendance.status,
          ),
          Gap(dimensions.spacing.s8),
          _ContactInfoItem(
            icon: Icons.access_time_outlined,
            label: locale.checkInTime,
            value: attendance.checkInTime != null
                ? DateFormatter.timestamp(attendance.checkInTime!)
                : '—',
          ),
          Gap(dimensions.spacing.s8),
          _ContactInfoItem(
            icon: Icons.location_on_outlined,
            label: locale.location,
            value: attendance.address,
          ),
          Gap(dimensions.spacing.s8),
          _ContactInfoItem(
            icon: Icons.comment_outlined,
            label: locale.reason,
            value: attendance.reason,
          ),
          if (attendance.approverName != null) ...[
            Gap(dimensions.spacing.s8),
            _ContactInfoItem(
              icon: Icons.person_outline,
              label: locale.approvedBy,
              value: attendance.approverName!,
            ),
          ],
        ],
      ),
    );
  }
}
