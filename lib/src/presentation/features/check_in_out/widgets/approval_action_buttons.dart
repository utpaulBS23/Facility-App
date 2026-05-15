part of '../view/shift_check_in_page.dart';

/// Bottom action buttons — Withdraw (outlined) and Refresh (filled).
/// Matches Figma node 13052:27586.
class _ApprovalActionButtons extends StatelessWidget {
  const _ApprovalActionButtons({
    required this.onWithdraw,
    required this.onRefresh,
    required this.onNeedFace,
    required this.attendanceStatue,
    this.isWithdrawing = false,
    this.isRefreshing = false,
  });

  final VoidCallback onWithdraw;
  final VoidCallback onRefresh;
  final VoidCallback onNeedFace;
  final AttendanceStatue attendanceStatue;
  final bool isWithdrawing;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final isLoading = isWithdrawing || isRefreshing;
    final isPending = attendanceStatue == AttendanceStatue.pending;

    return Column(
      children: [
        if (isPending) ...[
          SizedBox(
            width: double.infinity,
            height: spacing.s56,
            child: OutlinedButton(
              onPressed: isLoading ? null : onWithdraw,
              child: isWithdrawing
                  ? const LoadingIndicator()
                  : Text(context.locale.withdraw),
            ),
          ),
          Gap(spacing.s16),
        ],
        SizedBox(
          width: double.infinity,
          height: spacing.s56,
          child: FilledButton(
            onPressed: isLoading
                ? null
                : switch (attendanceStatue) {
                    AttendanceStatue.pending => onRefresh,
                    AttendanceStatue.success =>
                      () => context.goNamed(Routes.shift),
                    AttendanceStatue.reject =>
                      () => context.goNamed(Routes.login),
                    AttendanceStatue.needFace => onNeedFace,
                  },
            child: isRefreshing
                ? const LoadingIndicator()
                : Text(switch (attendanceStatue) {
                    AttendanceStatue.pending => context.locale.refresh,
                    AttendanceStatue.success => context.locale.home,
                    AttendanceStatue.reject => context.locale.login,
                    AttendanceStatue.needFace =>
                      context.locale.selfieVerification,
                  }),
          ),
        ),
      ],
    );
  }
}
