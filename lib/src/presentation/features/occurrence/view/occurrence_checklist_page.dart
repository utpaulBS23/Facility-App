import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/base/result.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/task_occurrence_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/task_occurrence_answer_provider.dart';
import '../riverpod/task_occurrence_submit_provider.dart';
import '../riverpod/task_occurrences_provider.dart';

part '../widgets/occurrence_checklist_item_form.dart';
part '../widgets/occurrence_checklist_progress_header.dart';
part '../widgets/occurrence_checklist_submit_bar.dart';
part '../widgets/occurrence_info_card.dart';

class OccurrenceChecklistPage extends ConsumerStatefulWidget {
  const OccurrenceChecklistPage({super.key, required this.occurrence});

  final TaskOccurrenceEntity occurrence;

  @override
  ConsumerState<OccurrenceChecklistPage> createState() =>
      _OccurrenceChecklistPageState();
}

class _OccurrenceChecklistPageState
    extends ConsumerState<OccurrenceChecklistPage> {
  bool _isSubmitting = false;

  TaskOccurrenceEntity _current(List<TaskOccurrenceEntity> occurrences) {
    for (final o in occurrences) {
      if (o.id == widget.occurrence.id) return o;
    }
    return widget.occurrence;
  }

  void _onCancel() => Navigator.of(context).pop();

  Future<void> _submit(TaskOccurrenceEntity current) async {
    setState(() => _isSubmitting = true);
    final result = await ref
        .read(taskOccurrenceSubmitProvider.notifier)
        .submit(taskOccurrenceId: current.id);
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.locale.occurrenceSubmitSuccess)),
        );
        Navigator.of(context).pop();
      },
      error: (error) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.localized(context)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final occurrencesAsync = ref.watch(taskOccurrencesProvider);
    final current = _current(
      occurrencesAsync.valueOrNull?.occurrences ?? [widget.occurrence],
    );
    final items =
        current.checklistItems ?? const <TaskOccurrenceChecklistItemEntity>[];
    final isRefreshing =
        occurrencesAsync.isLoading && occurrencesAsync.hasValue;
    final answered = items.where((i) => i.isAnswered).length;
    // WHY: answers are only editable while the occurrence is still pending —
    // once it's on_time/late/missed it's already been resolved by a submit
    // (or the window closed), so the form must go read-only.
    final isReadOnly = current.status != TaskOccurrenceStatus.pending;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.occurrenceChecklist),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(spacing.s24),
                          child: BodySmallText(
                            context.locale.noTasksFound,
                            color: context.color.text.secondary,
                          ),
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.all(spacing.s16),
                        children: [
                          _OccurrenceInfoCard(occurrence: current),
                          Gap(spacing.s16),
                          _OccurrenceChecklistProgressHeader(
                            answered: answered,
                            total: items.length,
                          ),
                          Gap(spacing.s12),
                          for (var i = 0; i < items.length; i++) ...[
                            _ChecklistItemForm(
                              key: ValueKey(items[i].id),
                              occurrenceId: current.id,
                              item: items[i],
                              order: i + 1,
                              readOnly: isReadOnly,
                            ),
                            Gap(spacing.s12),
                          ],
                        ],
                      ),
                if (isRefreshing)
                  Positioned.fill(
                    child: ColoredBox(
                      color: context.color.scaffoldBackground.withValues(
                        alpha: 0.6,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (current.status == TaskOccurrenceStatus.pending)
            PermissionGate(
              permissions: const [UserPermission.taskOccurrenceSubmit],
              child: _OccurrenceChecklistSubmitBar(
                isComplete: current.isChecklistComplete,
                isSubmitting: _isSubmitting,
                onSubmit: () => _submit(current),
                onCancel: _onCancel,
              ),
            ),
        ],
      ),
    );
  }
}
