part of 'shift_check_in_page.dart';

/// Page shown after submitting a supervisor approval request.
///
/// Displays a "Waiting for Approval" hero, the auto-detected info card
/// (reused from check-in flow), and Withdraw / Refresh action buttons.
/// Matches Figma node 13052:27421.
class ApprovalRequestPage extends ConsumerWidget {
  const ApprovalRequestPage({super.key});

  void _onWithdraw(BuildContext context) {
    // TODO: Implement withdrawal of supervisor approval request
    context.pop();
  }

  void _onRefresh(WidgetRef ref) {
    // TODO: Implement refresh to check approval status
    ref.invalidate(checkInInfoProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: Headline2xlTinyText(context.locale.approvalRequest),
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
                  _ApprovalHeroSection(AttendanceStatue.reject),
                  const _AutoDetectedInfoCard(),
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
              attendanceStatue: AttendanceStatue.reject,
              onWithdraw: () => _onWithdraw(context),
              onRefresh: () => _onRefresh(ref),
            ),
          ),
        ],
      ),
    );
  }
}
