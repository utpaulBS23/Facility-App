part of 'shift_check_in_page.dart';

class ApprovalRequestPage extends StatelessWidget {
  const ApprovalRequestPage({super.key, required this.attendance});

  final ManualAttendanceResponseEntity attendance;

  AttendanceStatue get _statue => switch (attendance.status) {
    'approved' => AttendanceStatue.success,
    'rejected' => AttendanceStatue.reject,
    _ => AttendanceStatue.pending,
  };

  void _onWithdraw(BuildContext context) => context.pop();

  @override
  Widget build(BuildContext context) {
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
                  _AttendanceInfoCard(attendance: attendance),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.dimensions.padding.p16,
              spacing.s16,
              context.dimensions.padding.p16,
              spacing.s32,
            ),
            child: _ApprovalActionButtons(
              attendanceStatue: statue,
              onWithdraw: () => _onWithdraw(context),
              onRefresh: () {},
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
            value: attendance.checkInTime,
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
