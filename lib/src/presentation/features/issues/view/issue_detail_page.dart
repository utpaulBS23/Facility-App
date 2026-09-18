import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../../domain/entities/issue_detail_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/text/typography.dart';

class IssueDetailPage extends StatelessWidget {
  const IssueDetailPage({super.key, required this.issue});

  final IssueDetailEntity issue;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.issueManagement),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Card1Header(issue: issue),
            Gap(spacing.s8),
            _Card2Description(issue: issue),
            Gap(spacing.s8),
            _Card3Details(issue: issue),
          ],
        ),
      ),
    );
  }
}

class _Card1Header extends StatelessWidget {
  const _Card1Header({required this.issue});

  final IssueDetailEntity issue;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
        boxShadow: [
          BoxShadow(
            color: context.color.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(spacing.s12),
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
          Gap(spacing.s8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _priorityColor(context),
                  shape: BoxShape.circle,
                ),
              ),
              Gap(spacing.s6),
              Text(
                issue.priority.toUpperCase(),
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
            ],
          ),
          Gap(spacing.s4),
          Row(
            children: [
              Icon(
                Icons.apartment_outlined,
                size: 14,
                color: context.color.text.secondary,
              ),
              Gap(spacing.s4),
              Expanded(
                child: Text(
                  issue.facilityName ?? '—',
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (issue.dueDate != null) ...[
            Gap(spacing.s4),
            Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  size: 14,
                  color: context.color.text.secondary,
                ),
                Gap(spacing.s4),
                Text(
                  '${context.locale.due}: ${DateFormatter.formatDueTime(issue.dueDate.toString())}',
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _priorityColor(BuildContext context) {
    return switch (issue.priority.toLowerCase()) {
      'high' => context.color.error,
      'medium' => context.color.warning,
      _ => context.color.success,
    };
  }
}

class _Card2Description extends StatelessWidget {
  const _Card2Description({required this.issue});

  final IssueDetailEntity issue;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    if (issue.description?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
        boxShadow: [
          BoxShadow(
            color: context.color.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(spacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.description,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          Gap(spacing.s6),
          Text(
            issue.description ?? '',
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.text.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Card3Details extends StatelessWidget {
  const _Card3Details({required this.issue});

  final IssueDetailEntity issue;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
        boxShadow: [
          BoxShadow(
            color: context.color.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(spacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (issue.createdDate != null) ...[
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: context.color.text.secondary,
                ),
                Gap(spacing.s8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.locale.created,
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                      Gap(spacing.s2),
                      Text(
                        DateFormatter.formatDueTime(issue.createdDate.toString()),
                        style: context.textStyle.bodyMedium.copyWith(
                          color: context.color.text.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(spacing.s8),
          ],
          if (issue.resolvedDate != null) ...[
            Row(
              children: [
                Icon(
                  Icons.check_circle_outlined,
                  size: 14,
                  color: context.color.text.secondary,
                ),
                Gap(spacing.s8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.locale.resolved,
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                      Gap(spacing.s2),
                      Text(
                        DateFormatter.formatDueTime(issue.resolvedDate.toString()),
                        style: context.textStyle.bodyMedium.copyWith(
                          color: context.color.text.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(spacing.s8),
          ],
          if (issue.assignedToName?.isNotEmpty ?? false) ...[
            Row(
              children: [
                Icon(
                  Icons.person_outlined,
                  size: 14,
                  color: context.color.text.secondary,
                ),
                Gap(spacing.s8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.locale.assignedTo,
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                      Gap(spacing.s2),
                      Text(
                        issue.assignedToName ?? '—',
                        style: context.textStyle.bodyMedium.copyWith(
                          color: context.color.text.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(spacing.s8),
          ],
          if (issue.media.isNotEmpty) ...[
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: issue.media.length,
                separatorBuilder: (_, _) => Gap(spacing.s8),
                itemBuilder: (_, i) {
                  final media = issue.media[i];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(radius.r6),
                    child: Image.network(
                      media.url,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, _) => Container(
                        width: 120,
                        height: 120,
                        color: context.color.borderSubtle,
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: context.color.icon,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
