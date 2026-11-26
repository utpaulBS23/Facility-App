import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions/app_localization.dart';
import '../../../domain/entities/common/approval_step_entity.dart';
import '../theme/theme.dart';
import '../utils/date_formatter.dart';

/// A row shown before or after the approval steps — e.g. "Requested by …" or
/// a delivery stage that is not part of the approval chain.
class ApprovalTimelineExtraItem {
  const ApprovalTimelineExtraItem({
    required this.title,
    required this.subtitle,
    this.color,
  });

  final String title;
  final String subtitle;

  /// Dot color; defaults to the success color.
  final Color? color;
}

/// Renders a request's approval chain as a status timeline card. Feed it the
/// steps and it draws one row per step, whatever approver groups the backend
/// configured.
class ApprovalStepsTimeline extends StatelessWidget {
  const ApprovalStepsTimeline({
    super.key,
    required this.steps,
    this.leading = const [],
    this.trailing = const [],
  });

  final List<ApprovalStepEntity> steps;
  final List<ApprovalTimelineExtraItem> leading;
  final List<ApprovalTimelineExtraItem> trailing;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    final rows = <_TimelineRowData>[
      for (final item in leading)
        _TimelineRowData(
          title: item.title,
          subtitle: item.subtitle,
          dotColor: item.color ?? color.success,
        ),
      for (final step in steps) _stepRow(context, step),
      for (final item in trailing)
        _TimelineRowData(
          title: item.title,
          subtitle: item.subtitle,
          dotColor: item.color ?? color.success,
        ),
    ];

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: color.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.statusTimeline,
            style: context.textStyle.headline2xlTiny.copyWith(
              fontWeight: FontWeight.bold,
              color: color.text.primary,
            ),
          ),
          Gap(spacing.s16),
          for (var i = 0; i < rows.length; i++)
            _TimelineRow(data: rows[i], isLast: i == rows.length - 1),
        ],
      ),
    );
  }

  _TimelineRowData _stepRow(BuildContext context, ApprovalStepEntity step) {
    final color = context.color;
    final roleName = _roleName(context, step.approverRole);
    final (title, dotColor) = switch (step.status) {
      ApprovalStepStatus.approved => (
        '$roleName ${context.locale.approved}',
        color.success,
      ),
      ApprovalStepStatus.rejected => (
        '$roleName ${context.locale.rejected}',
        color.error,
      ),
      ApprovalStepStatus.cancelled => (
        '$roleName ${context.locale.cancelled}',
        color.text.secondary,
      ),
      ApprovalStepStatus.pending => (
        '$roleName ${context.locale.pending}',
        color.warning,
      ),
    };

    final decidedAt = _formatTimestamp(step.decidedAt);

    return _TimelineRowData(
      title: title,
      subtitle: decidedAt.isNotEmpty ? decidedAt : context.locale.pending,
      dotColor: dotColor,
    );
  }

  static String _formatTimestamp(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    final parsed = DateTime.tryParse(isoString);
    if (parsed == null) return isoString;
    return DateFormatter.timestamp(parsed.toLocal());
  }

  static String _roleName(BuildContext context, String approverRole) {
    return switch (approverRole) {
      'supervisor' => context.locale.supervisor,
      'ops_manager' || 'operation_manager' || 'manager' =>
        context.locale.manager,
      'partner_owner' || 'owner' => context.locale.owner,
      _ => approverRole
          .split('_')
          .where((word) => word.isNotEmpty)
          .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
          .join(' '),
    };
  }
}

class _TimelineRowData {
  const _TimelineRowData({
    required this.title,
    required this.subtitle,
    required this.dotColor,
  });

  final String title;
  final String subtitle;
  final Color dotColor;
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.data, required this.isLast});

  final _TimelineRowData data;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: spacing.s12,
              height: spacing.s12,
              decoration: BoxDecoration(
                color: data.dotColor,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: spacing.s2,
                height: spacing.s36,
                color: color.borderSubtle,
              ),
          ],
        ),
        Gap(spacing.s12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : spacing.s12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: textStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.text.primary,
                  ),
                ),
                Gap(spacing.s2),
                Text(
                  data.subtitle,
                  style: textStyle.bodySmall.copyWith(
                    color: color.text.secondary,
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
