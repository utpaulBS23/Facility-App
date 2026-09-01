import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/task_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/tasks_provider.dart';
import '../widgets/task_proof_bottom_sheet.dart';

part '../widgets/task_card.dart';

enum _TaskTab { open, inProgress, resolved }

// WHY: task_issues.status query values — see Issue List API testing notes.
extension on _TaskTab {
  String get apiStatus => switch (this) {
    _TaskTab.open => 'open',
    _TaskTab.inProgress => 'in_progress',
    _TaskTab.resolved => 'resolved',
  };
}

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key});

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  _TaskTab _selectedTab = _TaskTab.open;
  int? _selectedFacilityId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch());
  }

  void _fetch() {
    ref
        .read(tasksProvider.notifier)
        .fetch(status: _selectedTab.apiStatus, facilityId: _selectedFacilityId);
  }

  void _onTabChanged(_TaskTab tab) {
    setState(() => _selectedTab = tab);
    _fetch();
  }

  Future<void> _pickFacility(List<AccessibleFacilityEntity> facilities) async {
    final result = await showModalBottomSheet<({int? facilityId})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FacilityPickerSheet(
        facilities: facilities,
        selectedFacilityId: _selectedFacilityId,
        includeAllOption: true,
      ),
    );
    if (result == null || result.facilityId == _selectedFacilityId) return;
    setState(() => _selectedFacilityId = result.facilityId);
    _fetch();
  }

  void _onRetry() => _fetch();

  void _onViewTap(TaskEntity task) =>
      context.pushNamed(Routes.taskDetail, extra: task);

  void _onStartTap(TaskEntity task) {
    ref.read(tasksProvider.notifier).startIssue(issueId: task.id);
  }

  void _onCompleteTap(TaskEntity task) {
    if (!task.proofRequiredOnComplete || task.media.isNotEmpty) {
      ref
          .read(tasksProvider.notifier)
          .completeIssue(issueId: task.id)
          .then((_) => _fetch())
          // WHY: error already surfaced via AsyncValue.error on tasksProvider; suppress unhandled Future
          .catchError((_) {});
      return;
    }

    showTaskProofBottomSheet(
      context,
      onSubmit: (photoPath, alt) async {
        await ref
            .read(tasksProvider.notifier)
            .uploadMedia(taskId: task.id, photoPath: photoPath, alt: alt);
        await ref.read(tasksProvider.notifier).completeIssue(issueId: task.id);
        _fetch();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final taskState = ref.watch(tasksProvider);
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final selectedFacilityName = _selectedFacilityId == null
        ? null
        : facilities
              .cast<AccessibleFacilityEntity?>()
              .firstWhere(
                (f) => f?.id == _selectedFacilityId,
                orElse: () => null,
              )
              ?.name;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.issues.trim()),
        titleSpacing: spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (facilities.length > 1)
            TextButton.icon(
              onPressed: () => _pickFacility(facilities),
              icon: const Icon(Icons.apartment_outlined, size: 18),
              label: Text(
                selectedFacilityName ?? context.locale.all,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TaskTabBar(selectedTab: _selectedTab, onTabChanged: _onTabChanged),
          Expanded(
            child: taskState.when(
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
                    Gap(spacing.s16),
                    TextButton(
                      onPressed: _onRetry,
                      child: Text(context.locale.retry),
                    ),
                  ],
                ),
              ),
              data: (tasks) {
                if (tasks.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(spacing.s24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.task_alt_outlined,
                            size: 48,
                            color: context.color.icon,
                          ),
                          Gap(spacing.s16),
                          Text(
                            context.locale.noTasksFound,
                            style: context.textStyle.bodyMedium.copyWith(
                              color: context.color.text.secondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.all(spacing.s16),
                  itemCount: tasks.length,
                  separatorBuilder: (_, _) => Gap(spacing.s12),
                  itemBuilder: (_, i) => _TaskCard(
                    task: tasks[i],
                    onTap: () => _onViewTap(tasks[i]),
                    onStartTap: () => _onStartTap(tasks[i]),
                    onCompleteTap: () => _onCompleteTap(tasks[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskTabBar extends StatelessWidget {
  const _TaskTabBar({required this.selectedTab, required this.onTabChanged});

  final _TaskTab selectedTab;
  final void Function(_TaskTab) onTabChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      color: context.color.onPrimary,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s8,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Row(
          children: [
            _Tab(
              label: context.locale.open,
              isSelected: selectedTab == _TaskTab.open,
              onTap: () => onTabChanged(_TaskTab.open),
            ),
            Container(width: 1, height: 44, color: context.color.borderSubtle),
            _Tab(
              label: context.locale.inProgress,
              isSelected: selectedTab == _TaskTab.inProgress,
              onTap: () => onTabChanged(_TaskTab.inProgress),
            ),
            Container(width: 1, height: 44, color: context.color.borderSubtle),
            _Tab(
              label: context.locale.resolved,
              isSelected: selectedTab == _TaskTab.resolved,
              onTap: () => onTabChanged(_TaskTab.resolved),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? context.color.brandSubtle : Colors.transparent,
            borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          ),
          padding: EdgeInsets.symmetric(vertical: spacing.s12),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: isSelected
                  ? context.color.primary
                  : context.color.text.secondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
