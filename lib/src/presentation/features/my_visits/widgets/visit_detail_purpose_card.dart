part of '../view/visit_detail_page.dart';

class _VisitDetailPurposeCard extends StatelessWidget {
  const _VisitDetailPurposeCard({required this.detail});

  final VisitDetailEntity detail;

  String _typeLabel(BuildContext context) => switch (detail.type) {
        VisitType.routineInspection => context.locale.routineInspection,
        VisitType.followUp => context.locale.followUp,
      };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: .circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              LabelMediumText(
                context.locale.purposeOfVisit,
                color: context.color.text.secondary,
              ),
              _StatusChip(
                color: context.color.icon,
                label: _typeLabel(context),
              ),
            ],
          ),
          Gap(spacing.s16),
          if (detail.assignedBy != null) _AssignedByRow(entity: detail.assignedBy!),
        ],
      ),
    );
  }
}

class _AssignedByRow extends StatelessWidget {
  const _AssignedByRow({required this.entity});

  final VisitAssignedByEntity entity;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: context.color.brandAccent,
            shape: .circle,
          ),
          child: Icon(
            Icons.person_outline,
            size: 28,
            color: context.color.text.primary,
          ),
        ),
        Gap(spacing.s16),
        Column(
          crossAxisAlignment: .start,
          children: [
            Headline2xlTinyText(entity.name),
            Gap(spacing.s4),
            LabelMediumText(
              entity.role,
              color: context.color.text.secondary,
            ),
          ],
        ),
      ],
    );
  }
}
