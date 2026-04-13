part of '../view/attendance_page.dart';

class _AttendanceDetailsBody extends StatelessWidget {
  const _AttendanceDetailsBody({required this.detail});

  final AttendanceDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        children: [
          _AttendanceDetailHeaderCard(detail: detail),
          Gap(spacing.s8),
          _AttendanceDetailMainCard(detail: detail),
          Gap(spacing.s8),
          _AttendanceDetailSelfieCard(selfieUrl: detail.selfieUrl),
          if (detail.supervisorApproval != null) ...[
            Gap(spacing.s8),
            _AttendanceDetailSupervisorCard(
              approval: detail.supervisorApproval!,
            ),
          ],
        ],
      ),
    );
  }
}
