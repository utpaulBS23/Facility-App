import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/staff_tile.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../issues/riverpod/create_issue_provider.dart';
import '../riverpod/task_detail_provider.dart';

Future<void> showTaskAssignStaffSheet(
  BuildContext context, {
  required int taskId,
  required int facilityId,
  int? assignedTo,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => TaskAssignStaffSheet(
      taskId: taskId,
      facilityId: facilityId,
      assignedTo: assignedTo,
    ),
  );
}

class TaskAssignStaffSheet extends ConsumerStatefulWidget {
  const TaskAssignStaffSheet({
    super.key,
    required this.taskId,
    required this.facilityId,
    this.assignedTo,
  });

  final int taskId;
  final int facilityId;
  final int? assignedTo;

  @override
  ConsumerState<TaskAssignStaffSheet> createState() =>
      _TaskAssignStaffSheetState();
}

class _TaskAssignStaffSheetState
    extends ConsumerState<TaskAssignStaffSheet> {
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _search = value.trim().toLowerCase());
  }

  Future<void> _onStaffSelected(PartnerStaffEntity staff) async {
    Navigator.of(context).pop();

    try {
      // Call API to update issue assignment
      await ref.read(taskDetailProvider.notifier).updateIssueAssignment(
        taskId: widget.taskId,
        assignedTo: staff.id,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Assigned to ${staff.name}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error assigning staff: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.locale.assignStaff,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(12),
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search staff...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          Expanded(
            child: _StaffList(
              facilityId: widget.facilityId,
              search: _search,
              assignedTo: widget.assignedTo,
              onStaffSelected: _onStaffSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _StaffList extends ConsumerWidget {
  const _StaffList({
    required this.facilityId,
    required this.search,
    required this.onStaffSelected,
    this.assignedTo,
  });

  final int facilityId;
  final String search;
  final int? assignedTo;
  final ValueChanged<PartnerStaffEntity> onStaffSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(issueAttendantsProvider(facilityId));

    return staffAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(
        child: Text('Error loading staff: $err'),
      ),
      data: (staffList) {
        if (staffList.isEmpty) {
          return const Center(
            child: Text('No staff available'),
          );
        }

        final filteredStaff = staffList
            .where((staff) =>
                staff.name.toLowerCase().contains(search) ||
                staff.email.toLowerCase().contains(search))
            .toList();

        return ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: filteredStaff.length,
          separatorBuilder: (_, _) => const Gap(12),
          itemBuilder: (context, index) {
            final staff = filteredStaff[index];
            return StaffTile(
              staff: staff,
              isSelected: assignedTo == staff.id,
              onAssign: () => onStaffSelected(staff),
            );
          },
        );
      },
    );
  }
}
