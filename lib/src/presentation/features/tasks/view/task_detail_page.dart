import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/task_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/assign_staff_button.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/router/routes.dart';
import '../riverpod/problem_category_provider.dart';
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

  Future<void> _onStartTap(TaskEntity task) async {
    await ref.read(taskDetailProvider.notifier).startIssue(issueId: task.id);
    ref.read(tasksProvider.notifier).refresh();
    if (mounted) {
      await ref.read(taskDetailProvider.notifier).fetch(taskId: task.id);
    }
  }

  void _onRetry() {
    ref.read(taskDetailProvider.notifier).fetch(taskId: widget.task.id);
  }

  Future<void> _onCompleteTap(TaskEntity task) async {
    // WHY gated by hasCompletionProof here too: the button is disabled in
    // this case, but _onCompleteTap can still be reached from task_page.dart
    // state before this screen re-renders, so re-check before calling.
    if (task.proofRequiredOnComplete && !task.hasCompletionProof) return;

    try {
      final completedTask = await ref
          .read(taskDetailProvider.notifier)
          .completeIssue(issueId: task.id);
      if (completedTask == null) return;
      ref.read(tasksProvider.notifier).replaceTask(completedTask);
      ref.read(tasksProvider.notifier).refresh();
      await ref.read(taskDetailProvider.notifier).fetch(taskId: task.id);
    } catch (_) {
      // Error already surfaced via AsyncValue.error on taskDetailProvider
    }
  }

  Future<void> _onAddPhotoTap(TaskEntity task) async {
    showTaskAddPhotoBottomSheet(
      context,
      onSubmit: (photoPath, alt) async {
        final media = await ref
            .read(taskDetailProvider.notifier)
            .uploadMedia(taskId: task.id, photoPath: photoPath, alt: alt);
        if (media == null) return;
        // WHY refetch instead of trusting the locally appended media: the
        // upload response doesn't carry everything the detail GET does (e.g.
        // server-assigned purpose), so the photo only shows up reliably in
        // the issue photo section once we re-pull the issue from the server.
        await ref.read(taskDetailProvider.notifier).fetch(taskId: task.id);
        final updatedTask = ref.read(taskDetailProvider).valueOrNull;
        if (updatedTask != null) {
          ref.read(tasksProvider.notifier).replaceTask(updatedTask);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(taskDetailProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.issueDetails),
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
          onAddPhotoTap: _onAddPhotoTap,
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
    required this.onAddPhotoTap,
  });

  final TaskEntity task;
  final ValueChanged<TaskEntity> onStartTap;
  final Future<void> Function(TaskEntity task) onCompleteTap;
  final ValueChanged<TaskEntity> onAddPhotoTap;

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
          if (task.proofRequiredOnComplete && task.status == TaskStatus.inProgress) ...[
            _buildProofRequiredAlert(context),
            Gap(spacing.s12),
          ],
          _buildCard1Header(context),
          Gap(spacing.s12),
          _buildCard2Description(context),
          Gap(spacing.s12),
          _buildCard3Media(context),
          if (task.status == TaskStatus.inProgress) ...[
            Gap(spacing.s12),
            _buildAddPhotoButton(context),
          ],
          Gap(spacing.s16),
          _buildActionButton(context),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    final radius = context.dimensions.radius;
    return BoxDecoration(
      color: context.color.onPrimary,
      border: Border.all(color: context.color.borderSubtle),
      borderRadius: BorderRadius.circular(radius.r12),
      boxShadow: [
        BoxShadow(color: context.color.shadow, blurRadius: 8, offset: const Offset(0, 2)),
      ],
    );
  }

  Widget _buildCard1Header(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(context),
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: _priorityColor(context), shape: BoxShape.circle)), Gap(spacing.s6), Text(_priorityLabel(context), style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary))]),
          Gap(spacing.s8),
          Text(task.localizedTitle(context.languageCode), style: context.textStyle.labelLarge.copyWith(color: context.color.text.primary, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 2),
          Gap(spacing.s6),
          Row(children: [Icon(Icons.apartment_outlined, size: 14, color: context.color.text.secondary), Gap(spacing.s4), Expanded(child: Text(task.location, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary), overflow: TextOverflow.ellipsis))]),
          if (task.problemCategory.isNotEmpty) ...[
            Gap(spacing.s6),
            Consumer(
              builder: (context, ref, _) {
                final labelAsync = ref.watch(problemCategoryLabelProvider(categoryValue: task.problemCategory));
                return labelAsync.when(
                  data: (label) => Row(children: [Icon(Icons.category_outlined, size: 14, color: context.color.text.secondary), Gap(spacing.s4), Expanded(child: Text(label, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary), overflow: TextOverflow.ellipsis))]),
                  loading: () => Row(children: [Icon(Icons.category_outlined, size: 14, color: context.color.text.secondary), Gap(spacing.s4), Expanded(child: Text(task.problemCategory, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary)))]),
                  error: (_, __) => Row(children: [Icon(Icons.category_outlined, size: 14, color: context.color.text.secondary), Gap(spacing.s4), Expanded(child: Text(task.problemCategory, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary)))]),
                );
              },
            ),
          ],
          if (task.assignedToName.isNotEmpty) ...[
            Gap(spacing.s6),
            Row(children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: context.color.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 10,
                    color: context.color.primary,
                  ),
                ),
              ),
              Gap(spacing.s4),
              Expanded(child: Text(task.assignedToName, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary), overflow: TextOverflow.ellipsis))
            ]),
            Gap(spacing.s6),
          ] else
            Gap(spacing.s6),
          Row(children: [Icon(Icons.location_on_outlined, size: 14, color: context.color.text.secondary), Gap(spacing.s4), Expanded(child: Text(task.facilityAddress, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary), overflow: TextOverflow.ellipsis))]),
          Gap(spacing.s12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(spacing.s12),
            decoration: BoxDecoration(color: context.color.subtle, borderRadius: BorderRadius.circular(radius.r10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [Icon(Icons.access_time_outlined, size: 14, color: context.color.text.secondary), Gap(spacing.s4), Text(context.locale.due, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary))]),
                Gap(spacing.s2),
                Text(DateFormatter.formatDateOnly(task.dueTime), style: context.textStyle.bodyMedium.copyWith(color: context.color.text.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Gap(spacing.s12),
          if (task.status == TaskStatus.open)
            PermissionGate(
              permissions: [UserPermission.issueUpdate],
              child: AssignStaffButton(
                onTap: () => context.pushNamed(Routes.assignTaskStaff, extra: task),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCard2Description(BuildContext context) {
    final spacing = context.dimensions.spacing;

    if (task.localizedDescription(context.languageCode).isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(context),
      padding: EdgeInsets.all(spacing.s16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(context.locale.taskDetails, style: context.textStyle.labelLarge.copyWith(color: context.color.text.primary, fontWeight: FontWeight.bold)), Gap(spacing.s8), Text(task.localizedDescription(context.languageCode), style: context.textStyle.bodyMedium.copyWith(color: context.color.text.secondary))]),
    );
  }

  Widget _buildProofRequiredAlert(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.color.warningAlt,
        border: Border.all(color: context.color.warning),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      padding: EdgeInsets.all(spacing.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outlined, size: 20, color: context.color.warning),
          Gap(spacing.s8),
          Expanded(
            child: Text(
              context.locale.proofRequiredMessage,
              style: context.textStyle.bodySmall.copyWith(color: context.color.warning),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard3Media(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    if (task.createdDate == null && task.resolvedDate == null && task.media.isEmpty) {
      return const SizedBox.shrink();
    }

    final creationPhotos = task.media.where((m) => m.purpose == 'creation').toList();
    final completionPhotos = task.media.where((m) => m.purpose == 'completion').toList();

    return Container(
      width: double.infinity,
      decoration: _cardDecoration(context),
      padding: EdgeInsets.all(spacing.s16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (task.createdDate != null || task.resolvedDate != null) ...[
          Row(
            children: [
              if (task.createdDate != null)
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14, color: context.color.text.secondary),
                      Gap(spacing.s8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.locale.created, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary)),
                            Gap(spacing.s2),
                            Text(DateFormatter.formatDueTime(task.createdDate.toString()), style: context.textStyle.bodyMedium.copyWith(color: context.color.text.primary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (task.createdDate != null && task.resolvedDate != null) Gap(spacing.s16),
              if (task.resolvedDate != null)
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14, color: context.color.text.secondary),
                      Gap(spacing.s8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.locale.resolved, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary)),
                            Gap(spacing.s2),
                            Text(DateFormatter.formatDueTime(task.resolvedDate.toString()), style: context.textStyle.bodyMedium.copyWith(color: context.color.text.primary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Gap(spacing.s8),
        ],
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(context.locale.tasksIssuePhoto, style: context.textStyle.bodyMedium.copyWith(color: context.color.text.primary, fontWeight: FontWeight.w600)),
              Gap(spacing.s8),
              if (creationPhotos.isEmpty)
                Container(
                  height: 100,
                  decoration: BoxDecoration(border: Border.all(color: context.color.border), borderRadius: BorderRadius.circular(radius.r6)),
                  child: Center(child: Text(context.locale.tasksNoPhoto, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary))),
                )
              else
                SizedBox(height: 100, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: creationPhotos.take(50).length, separatorBuilder: (_, _) => Gap(spacing.s6), itemBuilder: (_, i) {
                  final m = creationPhotos[i];
                  return ClipRRect(borderRadius: BorderRadius.circular(radius.r6), child: Image.network(m.url, width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 100, height: 100, color: context.color.borderSubtle, child: Icon(Icons.broken_image_outlined, color: context.color.icon))));
                })),
            ]),
          ),
          if (task.resolvedDate != null || completionPhotos.isNotEmpty) ...[
            Gap(spacing.s16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.locale.tasksResolvedPhoto, style: context.textStyle.bodyMedium.copyWith(color: context.color.text.primary, fontWeight: FontWeight.w600)),
                Gap(spacing.s8),
                if (completionPhotos.isEmpty)
                  Container(
                    height: 100,
                    decoration: BoxDecoration(border: Border.all(color: context.color.border), borderRadius: BorderRadius.circular(radius.r6)),
                    child: Center(child: Text(context.locale.tasksNoPhoto, style: context.textStyle.bodySmall.copyWith(color: context.color.text.secondary))),
                  )
                else
                  SizedBox(height: 100, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: completionPhotos.take(50).length, separatorBuilder: (_, _) => Gap(spacing.s6), itemBuilder: (_, i) {
                    final m = completionPhotos[i];
                    return ClipRRect(borderRadius: BorderRadius.circular(radius.r6), child: Image.network(m.url, width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 100, height: 100, color: context.color.borderSubtle, child: Icon(Icons.broken_image_outlined, color: context.color.icon))));
                  })),
              ]),
            ),
          ],
        ]),
        Gap(spacing.s12),
      ]),
    );
  }

  Widget _buildAddPhotoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => onAddPhotoTap(task),
        style: OutlinedButton.styleFrom(
          foregroundColor: context.color.primary,
          side: BorderSide(color: context.color.primary),
        ),
        icon: const Icon(Icons.camera_alt_outlined, size: 18),
        label: Text(context.locale.attachPhoto),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final showPrimaryAction = _canStart || _canComplete;
    final spacing = context.dimensions.spacing;
    final blockedByMissingProof =
        _canComplete && task.proofRequiredOnComplete && !task.hasCompletionProof;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showPrimaryAction) ...[
          if (_canStart)
            PermissionGate(
              permissions: [UserPermission.issueResolve],
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => onStartTap(task),
                  style: FilledButton.styleFrom(backgroundColor: context.color.success, foregroundColor: context.color.onPrimary),
                  child: Text(context.locale.startTask),
                ),
              ),
            )
          else
            PermissionGate(
              permissions: [UserPermission.issueResolve],
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: blockedByMissingProof ? null : () => onCompleteTap(task),
                  style: FilledButton.styleFrom(backgroundColor: context.color.text.primary, foregroundColor: context.color.onPrimary),
                  child: Text(context.locale.completeTask),
                ),
              ),
            ),
          if (blockedByMissingProof) ...[
            Gap(spacing.s6),
            Text(
              context.locale.photoRequiredToComplete,
              style: context.textStyle.bodySmall.copyWith(color: context.color.warning),
              textAlign: TextAlign.center,
            ),
          ],
          Gap(spacing.s12),
        ],
      ],
    );
  }
}
