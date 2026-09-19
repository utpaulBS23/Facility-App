import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../core/logger/log.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/task_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/staff_tile.dart';
import '../riverpod/assign_task_staff_provider.dart';
import '../riverpod/task_detail_provider.dart';

class AssignTaskStaffPage extends ConsumerStatefulWidget {
  const AssignTaskStaffPage({super.key, required this.task});

  final TaskEntity task;

  @override
  ConsumerState<AssignTaskStaffPage> createState() =>
      _AssignTaskStaffPageState();
}

class _AssignTaskStaffPageState extends ConsumerState<AssignTaskStaffPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchStaff());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  int? get _facilityId => widget.task.facilityId;

  void _fetchStaff() {
    final facilityId = _facilityId;
    Log.info('_fetchStaff called: facilityId=$facilityId');
    if (facilityId == null) {
      Log.error('_fetchStaff: facilityId is null');
      return;
    }
    Log.info('Fetching staff for facilityId=$facilityId');
    ref
        .read(taskPartnerStaffProvider.notifier)
        .fetch(
          facilityId: facilityId,
          search: _searchController.text.trim().isEmpty
              ? null
              : _searchController.text.trim(),
        );
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _fetchStaff);
  }

  Future<void> _onStaffTap(PartnerStaffEntity person) async {
    Log.info('_onStaffTap: assigning task ${widget.task.id} to staff ${person.id} (${person.name})');
    ref
        .read(assignTaskStaffProvider.notifier)
        .assign(
          issueId: widget.task.id,
          assignedTo: person.id,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(assignTaskStaffProvider, (_, next) {
      if (next is AsyncData && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.locale.staffAssignedSuccessfully)),
        );
        ref.read(taskDetailProvider.notifier).fetch(taskId: widget.task.id);
        context.pop();
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((next.error as dynamic).localizedMessage(context))),
        );
      }
    });

    final spacing = context.dimensions.spacing;
    final staffState = ref.watch(taskPartnerStaffProvider);
    final isAssigning = ref.watch(assignTaskStaffProvider).isLoading;
    final assignedId = widget.task.assignedToId;

    Log.info('AssignTaskStaffPage build: assignedId=$assignedId, task=${widget.task.id}');

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.assignStaff),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                spacing.s16,
                spacing.s16,
                0,
              ),
              child: AppTextField.search(
                controller: _searchController,
                hint: context.locale.search,
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: staffState.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                error: (err, _) => Center(
                  child: Text(
                    err.localizedMessage(context),
                    style: context.textStyle.bodyMedium.copyWith(
                      color: context.color.text.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                data: (staff) {
                  if (staff.isEmpty) {
                    return Center(
                      child: Text(
                        context.locale.noAttendantsFound,
                        style: context.textStyle.bodyMedium.copyWith(
                          color: context.color.text.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  Log.info('Staff list loaded: ${staff.length} staff members, assignedId=$assignedId');
                  return ListView.separated(
                    padding: EdgeInsets.all(spacing.s16),
                    itemCount: staff.length,
                    separatorBuilder: (context, index) => Gap(spacing.s12),
                    itemBuilder: (context, index) {
                      final person = staff[index];
                      final isSelected = assignedId == person.id;
                      Log.info('Staff item ${index}: id=${person.id}, name=${person.name}, isSelected=$isSelected');
                      return StaffTile(
                        staff: person,
                        isSelected: isSelected,
                        onAssign: isAssigning
                            ? null
                            : () => _onStaffTap(person),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}