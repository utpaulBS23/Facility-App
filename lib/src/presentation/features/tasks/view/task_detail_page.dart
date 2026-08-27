import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/task_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/task_detail_provider.dart';
import '../riverpod/tasks_provider.dart';
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
      (_) =>
          ref.read(taskDetailProvider.notifier).fetch(taskId: widget.task.id),
    );
  }

  void _onStartTap(TaskEntity task) {
    ref.read(taskDetailProvider.notifier).startIssue(issueId: task.id);
  }

  void _onRetry() {
    ref.read(taskDetailProvider.notifier).fetch(taskId: widget.task.id);
  }

  Future<void> _onCompleteTap(TaskEntity task) async {
    if (!task.proofRequiredOnComplete || task.media.isNotEmpty) {
      try {
        final completedTask = await ref
            .read(taskDetailProvider.notifier)
            .completeIssue(issueId: task.id);
        if (completedTask == null) return;
        ref.read(tasksProvider.notifier).replaceTask(completedTask);
        await ref.read(taskDetailProvider.notifier).fetch(taskId: task.id);
      } catch (_) {
        // Error already surfaced via AsyncValue.error on taskDetailProvider
      }
      return;
    }

    showTaskProofBottomSheet(
      context,
      onSubmit: (photoPath, alt) async {
        final media = await ref
            .read(taskDetailProvider.notifier)
            .uploadMedia(taskId: task.id, photoPath: photoPath, alt: alt);
        if (media == null) return;
        // WHY: replaceTask syncs list using completedTask which carries media from detail state;
        // appendMedia is skipped to avoid partial-failure desync if complete subsequently fails.
        final completedTask = await ref
            .read(taskDetailProvider.notifier)
            .completeIssue(issueId: task.id);
        if (completedTask == null) return;
        ref.read(tasksProvider.notifier).replaceTask(completedTask);
        await ref.read(taskDetailProvider.notifier).fetch(taskId: task.id);
      },
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
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                err.localizedMessage(context),
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(context.dimensions.spacing.s16),
              TextButton(
                onPressed: _onRetry,
                child: Text(context.locale.retry),
              ),
            ],
          ),
        ),
        data: (task) => _TaskDetailBody(
          task: task,
          onStartTap: _onStartTap,
          onCompleteTap: _onCompleteTap,
        ),
      ),
    );
  }
}

class _TaskDetailBody extends StatelessWidget {
  const _TaskDetailBody({
    required this.task,
    required this.onStartTap,
    required this.onCompleteTap,
  });

  final TaskEntity task;
  final ValueChanged<TaskEntity> onStartTap;
  final Future<void> Function(TaskEntity task) onCompleteTap;

  bool get _canStart => task.status == TaskStatus.open;
  bool get _canComplete => task.status == TaskStatus.inProgress;

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
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _priorityColor(context),
                    shape: BoxShape.circle,
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
            _InfoRow(icon: Icons.location_on_outlined, label: task.location),
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
                  scrollDirection: Axis.horizontal,
                  itemCount: task.media.length,
                  separatorBuilder: (_, _) =>
                      Gap(context.dimensions.spacing.s8),
                  itemBuilder: (_, i) {
                    final m = task.media[i];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(
                        context.dimensions.radius.r6,
                      ),
                      child: Image.network(
                        m.url,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
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
            if (_canStart) ...[
              Gap(spacing.s24),
              FilledButton(
                onPressed: () => onStartTap(task),
                child: Text(context.locale.startTask),
              ),
            ],
            if (_canComplete)
              PermissionGate(
                permissions: [UserPermission.taskComplete],
                child: Padding(
                  padding: EdgeInsets.only(top: spacing.s24),
                  child: FilledButton(
                    onPressed: () => onCompleteTap(task),
                    style: FilledButton.styleFrom(
                      backgroundColor: context.color.success,
                    ),
                    child: Text(context.locale.completeTask),
                  ),
                ),
              ),
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
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
