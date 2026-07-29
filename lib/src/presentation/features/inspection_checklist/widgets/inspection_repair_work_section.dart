part of '../view/inspection_checklist_page.dart';

class _InspectionRepairWorkSection extends StatelessWidget {
  const _InspectionRepairWorkSection({
    required this.item,
    required this.issues,
    required this.onNewIssue,
  });

  final ChecklistItemEntity item;
  final List<ChecklistIssueEntity> issues;
  final VoidCallback onNewIssue;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ItemOrderBadge(order: item.order),
              SizedBox(width: spacing.s12),
              Expanded(
                child: LabelLargeText(
                  context.locale.repairWork,
                  color: context.color.text.primary,
                ),
              ),
              PermissionGate(
                permission: UserPermission.issueCreate,
                child: _NewIssueButton(onTap: onNewIssue),
              ),
            ],
          ),
          if (issues.isNotEmpty) ...[
            SizedBox(height: spacing.s12),
            ...issues.map(
              (issue) => Padding(
                padding: EdgeInsets.only(bottom: spacing.s8),
                child: _InspectionIssueCard(issue: issue),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NewIssueButton extends StatelessWidget {
  const _NewIssueButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: EdgeInsets.only(left: spacing.s4, right: spacing.s12),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          borderRadius: BorderRadius.circular(radius.r20),
          border: Border.all(color: context.color.primary, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 20,
              color: context.color.primary,
            ),
            SizedBox(width: spacing.s4),
            LabelLargeText(
              context.locale.newIssue,
              color: context.color.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _InspectionIssueCard extends StatelessWidget {
  const _InspectionIssueCard({required this.issue});

  final ChecklistIssueEntity issue;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(radius.r12),
        border: Border.all(color: context.color.warning),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: context.color.brandAccent,
                  borderRadius: BorderRadius.circular(radius.r6),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.handyman_outlined,
                  size: 16,
                  color: context.color.primary,
                ),
              ),
              SizedBox(width: spacing.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelLargeText(
                      issue.title,
                      color: context.color.text.primary,
                    ),
                    SizedBox(height: spacing.s6),
                    if (issue.category.isNotEmpty) ...[
                      _CategoryChip(label: issue.category),
                      SizedBox(height: spacing.s6),
                    ],
                    if (issue.location.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: context.color.text.secondary,
                          ),
                          SizedBox(width: spacing.s4),
                          Expanded(
                            child: BodySmallText(
                              issue.location,
                              color: context.color.text.secondary,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(width: spacing.s8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: context.color.warningAlt,
                  borderRadius: BorderRadius.circular(radius.r10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 14,
                  color: context.color.warning,
                ),
              ),
            ],
          ),
          if (issue.status.isNotEmpty || issue.priority.isNotEmpty) ...[
            SizedBox(height: spacing.s12),
            Row(
              children: [
                if (issue.status.isNotEmpty) ...[
                  _IssueStatusTag(label: _localize(context, issue.status)),
                  SizedBox(width: spacing.s8),
                ],
                if (issue.priority.isNotEmpty)
                  _IssueStatusTag(label: _capitalize(issue.priority)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _localize(BuildContext context, String raw) {
    if (raw == 'reported') return context.locale.reported;
    return _capitalize(raw);
  }

  String _capitalize(String raw) {
    if (raw.isEmpty) return raw;
    return raw[0].toUpperCase() + raw.substring(1);
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s8,
        vertical: spacing.s4,
      ),
      decoration: BoxDecoration(
        color: context.color.background.surface,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r4),
      ),
      child: BodySmallText(label, color: context.color.text.primary),
    );
  }
}

class _IssueStatusTag extends StatelessWidget {
  const _IssueStatusTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: context.color.warning,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: context.dimensions.spacing.s4),
        BodySmallText(label, color: context.color.text.secondary),
      ],
    );
  }
}
