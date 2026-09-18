import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/task_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/detail_app_bar.dart';
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
        try {
          final media = await ref
              .read(taskDetailProvider.notifier)
              .uploadMedia(taskId: task.id, photoPath: photoPath, alt: alt);
          if (media == null) {
            if (!context.mounted) return;
            Navigator.of(context).pop();
            return;
          }
          // WHY: replaceTask syncs list using completedTask which carries media from detail state;
          // appendMedia is skipped to avoid partial-failure desync if complete subsequently fails.
          final completedTask = await ref
              .read(taskDetailProvider.notifier)
              .completeIssue(issueId: task.id);
          if (completedTask == null) {
            if (!context.mounted) return;
            Navigator.of(context).pop();
            return;
          }
          ref.read(tasksProvider.notifier).replaceTask(completedTask);
          await ref.read(taskDetailProvider.notifier).fetch(taskId: task.id);
          if (!context.mounted) return;
          Navigator.of(context).pop();
        } catch (_) {
          if (!context.mounted) return;
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(taskDetailProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.taskDetails),
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
      padding: EdgeInsets.all(spacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCard1Header(context),
          Gap(spacing.s8),
          _buildCard2Description(context),
          Gap(spacing.s8),
          _buildCard3Media(context),
        ],
      ),
    );
  }

  Widget _buildCard1Header(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
        boxShadow: [
          BoxShadow(color: context.color.shadow, blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      padding: EdgeInsets.all(spacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title, style: context.textStyle.labelLarge.copyWith(color: context.color.text.primary, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 2),
          Gap(spacing.s8),
          Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: _priorityColor(context), shape: BoxShape.circle)), Gap(spacing.s6), Text(_priorityLabel(context).toUpperCase(), style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary))]),
          Gap(spacing.s4),
          Row(children: [Icon(Icons.apartment_outlined, size: 14, color: context.color.text.secondary), Gap(spacing.s4), Expanded(child: Text(task.location, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary), overflow: TextOverflow.ellipsis))]),
          Gap(spacing.s4),
          Row(children: [Icon(Icons.access_time_outlined, size: 14, color: context.color.text.secondary), Gap(spacing.s4), Text('${context.locale.due}: ${DateFormatter.formatDueTime(task.dueTime)}', style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary))]),
        ],
      ),
    );
  }

  Widget _buildCard2Description(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    if (task.description.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.color.onPrimary, border: Border.all(color: context.color.borderSubtle), borderRadius: BorderRadius.circular(radius.r12), boxShadow: [BoxShadow(color: context.color.shadow, blurRadius: 8, offset: const Offset(0, 2))]),
      padding: EdgeInsets.all(spacing.s12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(context.locale.description, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary)), Gap(spacing.s6), Text(task.description, style: context.textStyle.bodyMedium.copyWith(color: context.color.text.primary))]),
    );
  }

  Widget _buildCard3Media(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.color.onPrimary, border: Border.all(color: context.color.borderSubtle), borderRadius: BorderRadius.circular(radius.r12), boxShadow: [BoxShadow(color: context.color.shadow, blurRadius: 8, offset: const Offset(0, 2))]),
      padding: EdgeInsets.all(spacing.s12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (task.createdDate != null) ...[
          Row(children: [Icon(Icons.calendar_today_outlined, size: 14, color: context.color.text.secondary), Gap(spacing.s8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(context.locale.created, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary)), Gap(spacing.s2), Text(DateFormatter.formatDueTime(task.createdDate.toString()), style: context.textStyle.bodyMedium.copyWith(color: context.color.text.primary))]))]),
          Gap(spacing.s8),
        ],
        if (task.resolvedDate != null) ...[
          Row(children: [Icon(Icons.check_circle_outlined, size: 14, color: context.color.text.secondary), Gap(spacing.s8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(context.locale.resolved, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary)), Gap(spacing.s2), Text(DateFormatter.formatDueTime(task.resolvedDate.toString()), style: context.textStyle.bodyMedium.copyWith(color: context.color.text.primary))]))]),
          Gap(spacing.s8),
        ],
        if (task.media.isNotEmpty) ...[
          SizedBox(height: 100, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: task.media.length, separatorBuilder: (_, _) => Gap(spacing.s6), itemBuilder: (_, i) {
            final m = task.media[i];
            return ClipRRect(borderRadius: BorderRadius.circular(radius.r6), child: Image.network(m.url, width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 100, height: 100, color: context.color.borderSubtle, child: Icon(Icons.broken_image_outlined, color: context.color.icon))));
          })),
          Gap(spacing.s12),
        ],
        if (_canStart) ...[
          PermissionGate(permissions: [UserPermission.issueResolve], child: SizedBox(width: double.infinity, child: FilledButton(onPressed: () => onStartTap(task), child: Text(context.locale.startTask)))),
          Gap(spacing.s8),
        ],
        if (_canComplete) PermissionGate(permissions: [UserPermission.issueResolve], child: SizedBox(width: double.infinity, child: FilledButton(onPressed: () => onCompleteTap(task), style: FilledButton.styleFrom(backgroundColor: context.color.primary), child: Text(context.locale.completeTask)))),
      ]),
    );
  }
}
