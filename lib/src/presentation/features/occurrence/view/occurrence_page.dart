import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/task_occurrence_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/horizontal_date_picker.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/staff_tile.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/task_occurrence_reassign_provider.dart';
import '../riverpod/task_occurrences_provider.dart';

part '../widgets/occurrence_stats_header.dart';
part '../widgets/occurrence_slot_card.dart';
part '../widgets/occurrence_status_chip.dart';
part '../widgets/occurrence_status_filter_sheet.dart';
part '../widgets/occurrence_reassign_sheet.dart';

enum _OccurrenceStatusFilter { all, pending, onTime, late, missed }

List<TaskOccurrenceEntity> _filterOccurrences(
  List<TaskOccurrenceEntity> occurrences,
  _OccurrenceStatusFilter filter,
) {
  return switch (filter) {
    _OccurrenceStatusFilter.all => occurrences,
    _OccurrenceStatusFilter.pending =>
      occurrences
          .where((o) => o.status == TaskOccurrenceStatus.pending)
          .toList(),
    _OccurrenceStatusFilter.onTime =>
      occurrences
          .where((o) => o.status == TaskOccurrenceStatus.onTime)
          .toList(),
    _OccurrenceStatusFilter.late =>
      occurrences.where((o) => o.status == TaskOccurrenceStatus.late).toList(),
    _OccurrenceStatusFilter.missed =>
      occurrences
          .where((o) => o.status == TaskOccurrenceStatus.missed)
          .toList(),
  };
}

String _occurrenceStatusFilterLabel(
  BuildContext context,
  _OccurrenceStatusFilter filter,
) => switch (filter) {
  _OccurrenceStatusFilter.all => context.locale.all,
  _OccurrenceStatusFilter.pending => context.locale.occurrenceStatsPending,
  _OccurrenceStatusFilter.onTime => context.locale.occurrenceStatsOnTime,
  _OccurrenceStatusFilter.late => context.locale.occurrenceStatsLate,
  _OccurrenceStatusFilter.missed => context.locale.occurrenceStatsMissed,
};

class OccurrencePage extends ConsumerStatefulWidget {
  const OccurrencePage({super.key});

  @override
  ConsumerState<OccurrencePage> createState() => _OccurrencePageState();
}

class _OccurrencePageState extends ConsumerState<OccurrencePage> {
  late DateTime _selectedDate;
  int? _selectedFacilityId;
  _OccurrenceStatusFilter _selectedFilter = _OccurrenceStatusFilter.all;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedFacilityId = _defaultFacilityId;
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch(_selectedDate));
  }

  int? get _defaultFacilityId {
    final facilities = ref.read(userSessionProvider)?.accessibleFacilities;
    if (facilities == null || facilities.isEmpty) return null;
    for (final facility in facilities) {
      if (facility.isPrimary) return facility.id;
    }
    return facilities.first.id;
  }

  void _fetch(DateTime date) {
    final facilityId = _selectedFacilityId;
    if (facilityId == null) return;
    ref
        .read(taskOccurrencesProvider.notifier)
        .fetch(
          facilityId: facilityId,
          date: DateFormat('yyyy-MM-dd').format(date),
        );
  }

  void _onDateChanged(DateTime date) {
    setState(() => _selectedDate = date);
    _fetch(date);
  }

  void _onFacilityChanged(int facilityId) {
    if (facilityId == _selectedFacilityId) return;
    setState(() => _selectedFacilityId = facilityId);
    _fetch(_selectedDate);
  }

  void _openReassignSheet(
    BuildContext context,
    TaskOccurrenceEntity occurrence,
  ) {
    if (_selectedFacilityId == null) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OccurrenceReassignSheet(occurrence: occurrence),
    );
  }

  void _openChecklist(BuildContext context, TaskOccurrenceEntity occurrence) {
    context.pushNamed(Routes.occurrenceChecklist, extra: occurrence);
  }

  Future<void> _pickFacility(
    BuildContext context,
    List<AccessibleFacilityEntity> facilities,
  ) async {
    final result = await showModalBottomSheet<({int? facilityId})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FacilityPickerSheet(
        facilities: facilities,
        selectedFacilityId: _selectedFacilityId,
      ),
    );
    if (result?.facilityId != null) _onFacilityChanged(result!.facilityId!);
  }

  Future<void> _pickStatusFilter(BuildContext context) async {
    final filter = await showModalBottomSheet<_OccurrenceStatusFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _OccurrenceStatusFilterSheet(selectedFilter: _selectedFilter),
    );
    if (filter != null) setState(() => _selectedFilter = filter);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final selectedFacilityName = facilities
        .cast<AccessibleFacilityEntity?>()
        .firstWhere((f) => f?.id == _selectedFacilityId, orElse: () => null)
        ?.name;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.task),
        titleSpacing: spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (facilities.length > 1)
            TextButton.icon(
              onPressed: () => _pickFacility(context, facilities),
              icon: const Icon(Icons.apartment_outlined, size: 18),
              label: Text(
                selectedFacilityName ?? context.locale.facilityName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () => _pickStatusFilter(context),
                icon: const Icon(Icons.filter_list_rounded),
              ),
              if (_selectedFilter != _OccurrenceStatusFilter.all)
                Positioned(
                  top: spacing.s8,
                  right: spacing.s8,
                  child: Container(
                    width: spacing.s8,
                    height: spacing.s8,
                    decoration: BoxDecoration(
                      color: context.color.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          Gap(spacing.s8),
        ],
      ),
      body: facilities.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(spacing.s24),
                child: Text(
                  Failure.noAccessibleFacility.localized(context),
                  style: context.textStyle.bodyMedium.copyWith(
                    color: context.color.text.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : _OccurrenceBoard(
              selectedDate: _selectedDate,
              selectedFilter: _selectedFilter,
              onDateChanged: _onDateChanged,
              onRetry: () => _fetch(_selectedDate),
              onReassign: (occurrence) =>
                  _openReassignSheet(context, occurrence),
              onChecklist: (occurrence) => _openChecklist(context, occurrence),
            ),
    );
  }
}

class _OccurrenceBoard extends ConsumerWidget {
  const _OccurrenceBoard({
    required this.selectedDate,
    required this.selectedFilter,
    required this.onDateChanged,
    required this.onRetry,
    required this.onReassign,
    required this.onChecklist,
  });

  final DateTime selectedDate;
  final _OccurrenceStatusFilter selectedFilter;
  final void Function(DateTime) onDateChanged;
  final VoidCallback onRetry;
  final void Function(TaskOccurrenceEntity) onReassign;
  final void Function(TaskOccurrenceEntity) onChecklist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final state = ref.watch(taskOccurrencesProvider);

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        HorizontalDatePicker.week(onDateSelected: onDateChanged),
        state.when(
          loading: () => const SizedBox.shrink(),
          error: (e, s) => const SizedBox.shrink(),
          data: (entity) => _OccurrenceStatsHeader(stats: entity.stats),
        ),
        Expanded(
          child: state.when(
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (err, _) => Center(
              child: Column(
                mainAxisSize: .min,
                children: [
                  Text(
                    err.localizedMessage(context),
                    style: context.textStyle.bodyMedium.copyWith(
                      color: context.color.text.secondary,
                    ),
                    textAlign: .center,
                  ),
                  Gap(spacing.s16),
                  TextButton(
                    onPressed: onRetry,
                    child: Text(context.locale.retry),
                  ),
                ],
              ),
            ),
            data: (entity) {
              final occurrences = _filterOccurrences(
                entity.occurrences,
                selectedFilter,
              );
              if (occurrences.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(spacing.s24),
                    child: Text(
                      context.locale.occurrenceEmptyBoard,
                      style: context.textStyle.bodyMedium.copyWith(
                        color: context.color.text.secondary,
                      ),
                      textAlign: .center,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.all(spacing.s16),
                itemCount: occurrences.length,
                separatorBuilder: (context, i) => Gap(spacing.s12),
                itemBuilder: (_, i) => _OccurrenceSlotCard(
                  occurrence: occurrences[i],
                  onReassign: () => onReassign(occurrences[i]),
                  onChecklist: () => onChecklist(occurrences[i]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
