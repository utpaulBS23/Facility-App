part of '../view/inspection_checklist_page.dart';

class _InspectionRepairWorkSection extends StatelessWidget {
  const _InspectionRepairWorkSection({
    required this.issues,
    required this.onNewIssue,
    required this.canAddIssue,
    this.onEditIssue,
  });

  final List<ChecklistIssueEntity> issues;
  final VoidCallback onNewIssue;
  final bool canAddIssue;
  final Function(ChecklistIssueEntity)? onEditIssue;

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
              Expanded(
                child: LabelLargeText(
                  context.locale.repairWork,
                  color: context.color.text.primary,
                ),
              ),
              if (canAddIssue)
                PermissionGate(
                  permissions: [UserPermission.issueCreate],
                  child: _NewIssueButton(onTap: onNewIssue),
                ),
            ],
          ),
          if (issues.isNotEmpty) ...[
            SizedBox(height: spacing.s12),
            ...issues.map(
              (issue) => Padding(
                padding: EdgeInsets.only(bottom: spacing.s8),
                child: _InspectionIssueCard(
                  issue: issue,
                  onEdit: canAddIssue ? () => onEditIssue?.call(issue) : null,
                ),
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

class _InspectionIssueCard extends ConsumerWidget {
  const _InspectionIssueCard({
    required this.issue,
    this.onEdit,
  });

  final ChecklistIssueEntity issue;
  final VoidCallback? onEdit;

  String _getCategoryLabel(BuildContext context, AsyncValue<List<ProblemCategoryEntity>> categoriesAsync) {
    return categoriesAsync.maybeWhen(
      data: (categories) {
        if (issue.category.isEmpty) return '—';
        try {
          final found = categories.firstWhere((cat) => cat.value == issue.category);
          return found.name;
        } catch (_) {
          return issue.category;
        }
      },
      orElse: () => issue.category.isNotEmpty ? issue.category : '—',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    // Fetch problem categories from provider (default partnerId: 6)
    final categoriesAsync = ref.watch(problemCategoriesProvider(6));
    final categoryLabel = _getCategoryLabel(context, categoriesAsync);

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      issue.title,
                      style: context.textStyle.labelLarge.copyWith(
                        color: context.color.text.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: spacing.s8),
                    if (issue.facilityName?.isNotEmpty ?? false) ...[
                      Row(
                        children: [
                          Icon(Icons.apartment_outlined, size: 14, color: context.color.text.secondary),
                          SizedBox(width: spacing.s4),
                          Expanded(child: BodySmallText(issue.facilityName!, color: context.color.text.secondary, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      SizedBox(height: spacing.s6),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(Icons.map_outlined, size: 14, color: context.color.text.secondary),
                          SizedBox(width: spacing.s4),
                          Expanded(child: BodySmallText(categoryLabel, color: context.color.text.secondary, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                    SizedBox(height: spacing.s6),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 14, color: context.color.text.secondary),
                          SizedBox(width: spacing.s4),
                          Expanded(child: BodySmallText(
                            issue.dueDateString?.isNotEmpty ?? false
                              ? DateFormatter.formatDueTime(issue.dueDateString!)
                              : '—',
                            color: context.color.text.secondary,
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing.s8),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: context.color.brandSubtle,
                      borderRadius: BorderRadius.circular(radius.r10),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.edit_outlined, size: 14, color: context.color.primary),
                  ),
                )
              else
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: context.color.warningAlt,
                    borderRadius: BorderRadius.circular(radius.r10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.warning_amber_rounded, size: 14, color: context.color.warning),
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
