import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/task_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class TaskDetailPage extends ConsumerWidget {
  const TaskDetailPage({super.key, required this.task});

  final TaskEntity task;

  Color _priorityColor(BuildContext context) => switch (task.priority) {
    TaskPriority.high => context.color.primary,
    TaskPriority.medium => context.color.warning,
    TaskPriority.low => context.color.inactive,
  };

  String _priorityLabel(BuildContext context) => switch (task.priority) {
    TaskPriority.high => context.locale.high,
    TaskPriority.medium => context.locale.medium,
    TaskPriority.low => context.locale.low,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: TitleMediumText(context.locale.taskDetails),
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: context.color.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(spacing.s16),
          decoration: BoxDecoration(
            color: context.color.onPrimary,
            border: Border.all(color: context.color.borderSubtle),
            borderRadius: .circular(context.dimensions.radius.r12),
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _priorityColor(context),
                      shape: .circle,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    _priorityLabel(context),
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ],
              ),
              Gap(spacing.s8),
              Text(
                task.title,
                style: context.textStyle.labelLarge.copyWith(
                  color: context.color.text.primary,
                ),
              ),
              Gap(spacing.s8),
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: task.location,
              ),
              Gap(spacing.s4),
              _InfoRow(
                icon: Icons.access_time_outlined,
                label: '${context.locale.due}: ${task.dueTime}',
              ),
              Gap(spacing.s16),
              Text(
                task.description,
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              Gap(spacing.s24),
              FilledButton(
                onPressed: () {},
                child: Text(context.locale.startTask),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.color.icon),
        const Gap(4),
        Expanded(
          child: Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
