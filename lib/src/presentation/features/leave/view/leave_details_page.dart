part of 'apply_leave_page.dart';

class LeaveDetailsPage extends StatefulWidget {
  const LeaveDetailsPage({super.key, required this.request});

  final MockLeaveRequest request;

  @override
  State<LeaveDetailsPage> createState() => _LeaveDetailsPageState();
}

class _LeaveDetailsPageState extends State<LeaveDetailsPage> {
  late MockLeaveRequest _request;

  @override
  void initState() {
    super.initState();
    _request = widget.request;
  }

  void _onApprove() {
    setState(() {
      _request = MockLeaveRequest(
        id: _request.id,
        employeeName: _request.employeeName,
        status: 'Approved',
        statusColor: const Color(0xFF27AE60), // Green
        leaveType: _request.leaveType,
        dateRange: _request.dateRange,
        location: _request.location,
        timeAgo: 'Just now',
      );
    });
    Navigator.of(context).pop(_request);
  }

  void _onReject() {
    setState(() {
      _request = MockLeaveRequest(
        id: _request.id,
        employeeName: _request.employeeName,
        status: 'Rejected',
        statusColor: const Color(0xFFEB5757), // Red
        leaveType: _request.leaveType,
        dateRange: _request.dateRange,
        location: _request.location,
        timeAgo: 'Just now',
      );
    });
    Navigator.of(context).pop(_request);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final isActionable = _request.status.toLowerCase() == 'pending' ||
        _request.status.toLowerCase() == 'manager approval';

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(_request),
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
        title: Headline2xlTinyText(context.locale.leaveDetails),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _LeaveDetailHeaderCard(request: _request),
                  Gap(spacing.s12),
                  _LeaveDetailInfoSection(request: _request),
                  Gap(spacing.s12),
                  _LeaveDetailShiftSection(request: _request),
                  Gap(spacing.s12),
                  _LeaveStatusTimeline(request: _request),
                ],
              ),
            ),
          ),
          if (isActionable)
            Container(
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                spacing.s12,
                spacing.s16,
                spacing.s20,
              ),
              decoration: BoxDecoration(
                color: color.onPrimary,
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
                border: Border(
                  top: BorderSide(color: color.borderSubtle),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _onApprove,
                      style: FilledButton.styleFrom(
                        backgroundColor: color.primary,
                        foregroundColor: color.onPrimary,
                        minimumSize: Size(double.infinity, spacing.s44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                      ),
                      child: Text(context.locale.approved),
                    ),
                  ),
                  Gap(spacing.s12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color.primary,
                        side: BorderSide(color: color.primary),
                        minimumSize: Size(double.infinity, spacing.s44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                      ),
                      child: Text(context.locale.rejection),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
