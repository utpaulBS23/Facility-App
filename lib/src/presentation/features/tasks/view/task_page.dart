import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/task_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/tasks_provider.dart';
import '../widgets/task_proof_bottom_sheet.dart';

part '../widgets/task_card.dart';

enum _TaskTab { today, pending, completed }

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key});

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  _TaskTab _selectedTab = _TaskTab.today;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(tasksProvider.notifier).fetch(bucket: 'today'),
    );
  }

  void _onTabChanged(_TaskTab tab) {
    setState(() => _selectedTab = tab);
    ref.read(tasksProvider.notifier).fetch(bucket: tab.name);
  }

  void _onViewTap(TaskEntity task) =>
      context.pushNamed(Routes.taskDetail, extra: task);

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final taskState = ref.watch(tasksProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.task.trim()),
        titleSpacing: spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: .stretch,
        children: [
          _TaskTabBar(
            selectedTab: _selectedTab,
            onTabChanged: _onTabChanged,
          ),
          Expanded(
            child: taskState.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
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
                    Gap(spacing.s16),
                    TextButton(
                      onPressed: () =>
                          ref
                              .read(tasksProvider.notifier)
                              .fetch(bucket: _selectedTab.name),
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
                        mainAxisSize: .min,
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
                    onStartTap: () => showTaskProofBottomSheet(context),
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
  const _TaskTabBar({
    required this.selectedTab,
    required this.onTabChanged,
  });

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
          borderRadius: .circular(context.dimensions.radius.r12),
        ),
        child: Row(
          children: [
            _Tab(
              label: context.locale.today,
              isSelected: selectedTab == _TaskTab.today,
              onTap: () => onTabChanged(_TaskTab.today),
            ),
            Container(width: 1, height: 44, color: context.color.borderSubtle),
            _Tab(
              label: context.locale.pending,
              isSelected: selectedTab == _TaskTab.pending,
              onTap: () => onTabChanged(_TaskTab.pending),
            ),
            Container(width: 1, height: 44, color: context.color.borderSubtle),
            _Tab(
              label: context.locale.completed,
              isSelected: selectedTab == _TaskTab.completed,
              isCompleted: true,
              onTap: () => onTabChanged(_TaskTab.completed),
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
    this.isCompleted = false,
  });

  final String label;
  final bool isSelected;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final isActive = isSelected && isCompleted;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isActive
                ? context.color.successAlt
                : isSelected
                ? context.color.brandSubtle
                : Colors.transparent,
            borderRadius: .circular(context.dimensions.radius.r12),
          ),
          padding: EdgeInsets.symmetric(vertical: spacing.s12),
          alignment: .center,
          child: Text(
            label,
            style: context.textStyle.bodySmall.copyWith(
              color: isActive
                  ? context.color.success
                  : isSelected
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
