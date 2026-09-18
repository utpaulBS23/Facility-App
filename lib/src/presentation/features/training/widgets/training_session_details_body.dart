part of '../view/training_session_details_page.dart';

class _TrainingSessionDetailsBody extends StatelessWidget {
  const _TrainingSessionDetailsBody({
    required this.session,
    required this.onBack,
  });

  final TrainingSessionEntity session;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.trainingDetailsTitle,
        onBack: onBack,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusDotTag(
              dotColor: session.status.statusColor(context),
              label: session.status.localizedName(context),
            ),
            Gap(spacing.s8),
            Text(
              session.title,
              style: context.textStyle.titleLarge.copyWith(
                color: context.color.text.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(spacing.s20),
            _TrainingDetailRow(
              icon: Icons.person_outline_rounded,
              label: context.locale.facilitator,
              value: session.facilitatorName,
            ),
            Gap(spacing.s16),
            _TrainingDetailRow(
              icon: Icons.calendar_today_outlined,
              label: context.locale.dateAndTime,
              value:
                  '${DateFormatter.shortDate(session.scheduledAt)}  •  '
                  '${DateFormatter.timeOnly(session.scheduledAt)} - '
                  '${DateFormatter.timeOnly(session.endTime)}',
            ),
            if (session.facilityName.isNotEmpty) ...[
              Gap(spacing.s16),
              _TrainingDetailRow(
                icon: Icons.location_on_outlined,
                label: context.locale.facility,
                value: session.facilityName,
              ),
            ],
            if (session.description.isNotEmpty) ...[
              Gap(spacing.s20),
              _TrainingSessionInfoCard(description: session.description),
            ],
            if (session.status == TrainingStatus.scheduled) ...[
              Gap(spacing.s20),
              const _TrainingNotStartedNoticeCard(),
            ],
          ],
        ),
      ),
    );
  }
}
