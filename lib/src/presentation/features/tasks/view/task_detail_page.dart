import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/task_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/task_detail_provider.dart';
import '../widgets/task_proof_bottom_sheet.dart';

class TaskDetailPage extends ConsumerStatefulWidget {
  const TaskDetailPage({super.key, required this.task});

  final TaskEntity task;

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(taskDetailProvider.notifier).fetch(taskId: widget.task.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(taskDetailProvider);

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
      body: detailState.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: .min,
            children: [
              Text(
                err.toString(),
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(context.dimensions.spacing.s16),
              TextButton(
                onPressed: () => ref
                    .read(taskDetailProvider.notifier)
                    .fetch(taskId: widget.task.id),
                child: Text(context.locale.retry),
              ),
            ],
          ),
        ),
        data: (task) => _TaskDetailBody(task: task),
      ),
    );
  }
}

class _TaskDetailBody extends StatelessWidget {
  const _TaskDetailBody({required this.task});

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
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
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
            if (task.media.isNotEmpty) ...[
              Gap(spacing.s16),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: .horizontal,
                  itemCount: task.media.length,
                  separatorBuilder: (_, _) =>
                      Gap(context.dimensions.spacing.s8),
                  itemBuilder: (_, i) {
                    final m = task.media[i];
                    return ClipRRect(
                      borderRadius:
                          .circular(context.dimensions.radius.r6),
                      child: Image.network(
                        m.url,
                        width: 120,
                        height: 120,
                        fit: .cover,
                        errorBuilder: (_, _, _) => Container(
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
            if (task.status != TaskStatus.completed) ...[
              Gap(spacing.s24),
              FilledButton(
                onPressed: () => showTaskProofBottomSheet(context),
                child: Text(context.locale.startTask),
              ),
            ],
          ],
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
            overflow: .ellipsis,
          ),
        ),
      ],
    );
  }
}
