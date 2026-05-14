part of '../view/shift_check_in_page.dart';

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
              .success => () => context.goNamed(Routes.shift),
              .reject => onRefresh,
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
