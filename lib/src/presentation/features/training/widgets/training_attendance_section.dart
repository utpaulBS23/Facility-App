part of '../view/training_session_details_page.dart';

/// The logged-in user's own attendance on the session: their current status,
/// plus Present / Absent buttons when they may mark attendance.
///
/// Renders nothing when the user is not enrolled in the session.
class _TrainingAttendanceSection extends ConsumerStatefulWidget {
  const _TrainingAttendanceSection({required this.session});

  final TrainingSessionEntity session;

  @override
  ConsumerState<_TrainingAttendanceSection> createState() =>
      _TrainingAttendanceSectionState();
}

class _TrainingAttendanceSectionState
    extends ConsumerState<_TrainingAttendanceSection> {
  bool _isMarking = false;

  Future<void> _mark({
    required int participantId,
    required TrainingCompletionStatus status,
  }) async {
    if (_isMarking) return;

    // WHY captured first: a successful mark refetches the details, which swaps
    // the page to its loading state and unmounts this section before `context`
    // could show the snackbar.
    final messenger = ScaffoldMessenger.of(context);
    final successMessage = context.locale.trainingAttendanceUpdated;
    final successColor = context.color.success;
    final textColor = context.color.onPrimary;
    final textStyle = context.textStyle.bodyMedium;

    setState(() => _isMarking = true);

    final failure = await ref
        .read(trainingSessionDetailsProvider(widget.session.id).notifier)
        .markAttendance(participantId: participantId, status: status);

    if (!mounted) {
      if (failure == null) {
        messenger
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              backgroundColor: successColor,
              content: Text(
                successMessage,
                style: textStyle.copyWith(color: textColor),
              ),
            ),
          );
      }
      return;
    }

    setState(() => _isMarking = false);

    if (failure == null) {
      AppSnackBar.showSuccess(context, successMessage);
    } else {
      AppSnackBar.showError(context, failure.localizedMessage(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final currentUserId = ref.read(getCurrentUserUseCaseProvider).call()?.id;
    final participant = session.participantFor(currentUserId);
    if (participant == null) return const SizedBox.shrink();

    final status = participant.completionStatus;
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(spacing.s16),
        _TrainingDetailRow(
          icon: Icons.how_to_reg_outlined,
          label: context.locale.trainingMyAttendance,
          value: status.localizedName(context),
        ),
        // WHY not when cancelled: the session will not take place, so there is
        // nothing to attend. The server stays the authority on the permission.
        if (session.status != TrainingStatus.cancelled)
          PermissionGate(
            permissions: const [UserPermission.trainingSessionMarkAttendance],
            child: Padding(
              padding: EdgeInsets.only(top: spacing.s16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed:
                          _isMarking ||
                              status == TrainingCompletionStatus.completed
                          ? null
                          : () => _mark(
                              participantId: participant.id,
                              status: TrainingCompletionStatus.completed,
                            ),
                      style: FilledButton.styleFrom(
                        minimumSize: Size(double.infinity, spacing.s44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                      ),
                      child: Text(context.locale.trainingMarkPresent),
                    ),
                  ),
                  Gap(spacing.s12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _isMarking ||
                              status == TrainingCompletionStatus.absent
                          ? null
                          : () => _mark(
                              participantId: participant.id,
                              status: TrainingCompletionStatus.absent,
                            ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.color.error,
                        side: BorderSide(color: context.color.error),
                        minimumSize: Size(double.infinity, spacing.s44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                      ),
                      child: Text(context.locale.trainingMarkAbsent),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
