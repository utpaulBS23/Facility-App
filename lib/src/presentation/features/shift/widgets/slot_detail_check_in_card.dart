part of '../view/shift_tab.dart';

/// The caller's own attendance on this slot: check-in/out times and the
/// selfies captured with them.
///
/// WHY one card rather than a card per selfie: the times and the photographs
/// are the same record — split across cards the reader had to join "checked in
/// 08:02" to a thumbnail in the card below it. Each selfie keeps the design's
/// own pairing (direction icon + label beside a round thumbnail), so nothing is
/// matched by position.
class _SlotDetailCheckInCard extends StatelessWidget {
  const _SlotDetailCheckInCard({required this.attendance});

  final SlotAttendanceEntity attendance;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final checkIn = attendance.checkInTime != null
        ? DateFormatter.timestamp(attendance.checkInTime!)
        : null;
    final checkOut = attendance.checkOutTime != null
        ? DateFormatter.timestamp(attendance.checkOutTime!)
        : null;
    final checkInSelfie = attendance.checkInSelfieUrl;
    final checkOutSelfie = attendance.checkOutSelfieUrl;
    final hasSelfie = checkInSelfie != null || checkOutSelfie != null;
    final isPendingReview = AttendanceApprovalStatus.fromWireString(
      attendance.approvalStatus,
    ).isPendingStage;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        boxShadow: [
          BoxShadow(
            color: context.color.shadow,
            blurRadius: spacing.s14,
            offset: Offset(0, spacing.s2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.locale.attendantDetails,
                  style: context.textStyle.headline2xlTiny.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
              ),
              if (isPendingReview) ...[
                Gap(spacing.s8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.s8,
                    vertical: spacing.s4,
                  ),
                  decoration: BoxDecoration(
                    color: context.color.warningAlt,
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r6,
                    ),
                  ),
                  child: Text(
                    context.locale.pendingSupervisorApproval,
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Gap(spacing.s16),
          Row(
            children: [
              Expanded(
                child: _DateTimeTile(
                  icon: Icons.login_rounded,
                  label: context.locale.checkInTime,
                  value: checkIn ?? '—',
                ),
              ),
              Gap(spacing.s8),
              Expanded(
                child: _DateTimeTile(
                  icon: Icons.logout_rounded,
                  label: context.locale.checkOutTime,
                  value: checkOut ?? '—',
                ),
              ),
            ],
          ),
          if (hasSelfie) ...[
            Gap(spacing.s20),
            Text(
              context.locale.selfieVerification,
              style: context.textStyle.headline2xlTiny.copyWith(
                color: context.color.text.primary,
              ),
            ),
            Gap(spacing.s12),
            Row(
              children: [
                if (checkInSelfie != null)
                  Expanded(
                    child: _SlotSelfieEntry(
                      url: checkInSelfie,
                      label: context.locale.checkIn,
                      icon: Icons.login_rounded,
                      iconColor: context.color.success,
                    ),
                  ),
                if (checkInSelfie != null && checkOutSelfie != null)
                  Gap(spacing.s12),
                if (checkOutSelfie != null)
                  Expanded(
                    child: _SlotSelfieEntry(
                      url: checkOutSelfie,
                      label: context.locale.checkOut,
                      icon: Icons.logout_rounded,
                      iconColor: context.color.primary,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
