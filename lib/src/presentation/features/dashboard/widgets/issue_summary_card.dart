import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import 'dashboard_section_header.dart';
import 'dashboard_stat_tile.dart';
import 'dashboard_tone.dart';
import 'issue_row.dart';

/// One counter of the issue summary.
class IssueCount {
  const IssueCount({
    required this.valueText,
    required this.label,
    required this.tone,
  });

  final String valueText;
  final String label;
  final DashboardTone tone;
}

/// A white card with a title, a "See all" link and its content.
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.child,
    this.onSeeAll,
  });

  final String title;
  final Widget child;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: c.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r16),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardSectionHeader(
            title: title,
            actionLabel: onSeeAll == null ? null : context.locale.seeAll,
            onAction: onSeeAll,
          ),
          SizedBox(height: spacing.s8),
          child,
        ],
      ),
    );
  }
}

/// Issue counters in a grid of [columns] tiles.
class IssueSummaryCard extends StatelessWidget {
  const IssueSummaryCard({
    super.key,
    required this.title,
    required this.counts,
    this.columns = 2,
    this.onSeeAll,
  });

  final String title;
  final List<IssueCount> counts;
  final int columns;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final rows = <List<IssueCount>>[
      for (var i = 0; i < counts.length; i += columns)
        counts.sublist(i, (i + columns).clamp(0, counts.length)),
    ];

    return DashboardCard(
      title: title,
      onSeeAll: onSeeAll,
      child: Column(
        children: [
          for (var r = 0; r < rows.length; r++) ...[
            if (r > 0) SizedBox(height: spacing.s10),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < columns; i++) ...[
                    if (i > 0) SizedBox(width: spacing.s10),
                    Expanded(
                      child: i < rows[r].length
                          ? DashboardStatTile(
                              value: rows[r][i].valueText,
                              label: rows[r][i].label,
                              tone: rows[r][i].tone,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The latest issues as rows.
class RecentIssuesCard extends StatelessWidget {
  const RecentIssuesCard({
    super.key,
    required this.title,
    required this.issues,
    this.onSeeAll,
  });

  final String title;
  final List<IssueRow> issues;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return DashboardCard(
      title: title,
      onSeeAll: onSeeAll,
      child: Column(
        children: [
          for (var i = 0; i < issues.length; i++) ...[
            if (i > 0) SizedBox(height: spacing.s8),
            issues[i],
          ],
        ],
      ),
    );
  }
}
