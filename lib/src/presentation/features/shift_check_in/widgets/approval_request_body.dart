// ignore_for_file: max_file_lines, max_method_lines
part of '../view/shift_check_in_page.dart';

/// Hero section with clock icon, title, and description for the approval
/// waiting state. Matches Figma node 13052:27513.
class _ApprovalHeroSection extends StatelessWidget {
  const _ApprovalHeroSection(this.attendanceStatue);

  final AttendanceStatue attendanceStatue;

  @override
  Widget build(BuildContext context) {
    return switch (attendanceStatue) {
      AttendanceStatue.pending => _PendingApprovalHeroSection(),
      AttendanceStatue.success => _SuccessApprovalHeroSection(),
      AttendanceStatue.reject => _RejectApprovalHeroSection(),
    };
  }
}

class _PendingApprovalHeroSection extends StatelessWidget {
  const _PendingApprovalHeroSection();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.s24),
      child: Column(
        children: [
          Gap(spacing.s40),
          // WHY: Amber circle with clock icon matches the Figma "waiting" hero.
          Container(
            width: spacing.s80,
            height: spacing.s80,
            decoration: BoxDecoration(
              color: context.color.warningAlt,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time_rounded,
              size: spacing.s40,
              color: context.color.warning,
            ),
          ),
          Gap(spacing.s12),
          HeadlineMediumText(
            context.locale.waitingForApproval,
            textAlign: TextAlign.center,
          ),
          Gap(spacing.s12),
          BodyRegularText.secondary(
            context.locale.waitingForApprovalMessage,
            textAlign: TextAlign.center,
          ),
          Gap(spacing.s24),
        ],
      ),
    );
  }
}

class _SuccessApprovalHeroSection extends StatelessWidget {
  const _SuccessApprovalHeroSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.dimensions.padding.p24),
      child: Column(
        children: [
          Assets.icons.success.svg(height: 80, width: 80),
          Gap(context.dimensions.spacing.s12),
          HeadlineMediumText(
            context.locale.approvalSuccess,
            textAlign: TextAlign.center,
          ),
          Gap(context.dimensions.spacing.s12),
          BodyRegularText.secondary(
            context.locale.approvalSuccessfulMessage,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RejectApprovalHeroSection extends StatelessWidget {
  const _RejectApprovalHeroSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.dimensions.padding.p24),
      child: Column(
        children: [
          Assets.icons.cancel.svg(height: 80, width: 80),
          Gap(context.dimensions.spacing.s12),
          HeadlineMediumText(
            context.locale.approvalFailed,
            textAlign: TextAlign.center,
          ),
          Gap(context.dimensions.spacing.s12),
          BodyRegularText.secondary(
            context.locale.approvalFailedMessage,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Bottom action buttons — Withdraw (outlined) and Refresh (filled).
/// Matches Figma node 13052:27586.
class _ApprovalActionButtons extends StatelessWidget {
  const _ApprovalActionButtons({
    required this.onWithdraw,
    required this.onRefresh,
    required this.attendanceStatue,
  });

  final VoidCallback onWithdraw;
  final VoidCallback onRefresh;
  final AttendanceStatue attendanceStatue;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: spacing.s56,
          child: OutlinedButton(
            onPressed: onWithdraw,
            child: Text(context.locale.withdraw),
          ),
        ),
        Gap(spacing.s16),
        SizedBox(
          width: double.infinity,
          height: spacing.s56,
          child: FilledButton(
            onPressed: switch (attendanceStatue) {
              .pending => onRefresh,
              .success => () => context.goNamed(Routes.home),
              .reject => onRefresh, // Allow refresh to check if status changed
            },
            child: Text(switch (attendanceStatue) {
              .success => context.locale.home,
              .reject => context.locale.refresh,
              .pending => context.locale.refresh,
            }),
          ),
        ),
      ],
    );
  }
}
