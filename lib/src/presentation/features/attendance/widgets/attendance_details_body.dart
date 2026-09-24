part of '../view/attendance_page.dart';

class _AttendanceDetailsBody extends StatelessWidget {
  const _AttendanceDetailsBody({required this.detail});

  final AttendanceItemEntity detail;

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
          if (detail.checkInSelfie != null || detail.checkOutSelfie != null) ...[
            Gap(spacing.s8),
            _AttendanceSelfieSection(detail: detail),
          ],
          if (detail.checkInReviewer != null) ...[
            Gap(spacing.s8),
            _AttendanceDetailApproverCard(
              approver: detail.checkInReviewer!,
              label: context.locale.checkInReviewedBy,
            ),
          ],
          if (detail.checkOutReviewer != null) ...[
            Gap(spacing.s8),
            _AttendanceDetailApproverCard(
              approver: detail.checkOutReviewer!,
              label: context.locale.checkOutReviewedBy,
            ),
          ],
          if (detail.approver != null) ...[
            Gap(spacing.s8),
            _AttendanceDetailApproverCard(approver: detail.approver!),
          ],
        ],
      ),
    );
  }
}
