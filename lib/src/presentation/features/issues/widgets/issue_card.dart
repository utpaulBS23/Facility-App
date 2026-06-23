part of '../view/issues_page.dart';

class _IssueCard extends StatelessWidget {
  const _IssueCard({required this.issue});

  final ChecklistIssueEntity issue;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: .circular(radius.r12),
        border: Border.all(color: context.color.warning),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: context.color.brandAccent,
                  borderRadius: .circular(8),
                ),
                alignment: .center,
                child: Icon(
                  Icons.handyman_outlined,
                  size: 16,
                  color: context.color.primary,
                ),
              ),
              SizedBox(width: spacing.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    LabelLargeText(issue.title, color: context.color.text.primary),
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
                  borderRadius: .circular(10),
                ),
                alignment: .center,
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
      padding: EdgeInsets.symmetric(horizontal: spacing.s8, vertical: 3),
      decoration: BoxDecoration(
        color: context.color.background.surface,
        borderRadius: .circular(context.dimensions.radius.r4),
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
      mainAxisSize: .min,
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
