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
import '../../../core/widgets/app_dropdown_button_form_field.dart';
import '../../../core/widgets/horizontal_date_picker.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/staff_tile.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/task_occurrence_reassign_provider.dart';
import '../riverpod/task_occurrences_provider.dart';

part '../widgets/occurrence_facility_dropdown.dart';
part '../widgets/occurrence_stats_header.dart';
part '../widgets/occurrence_slot_card.dart';
part '../widgets/occurrence_status_chip.dart';
part '../widgets/occurrence_reassign_sheet.dart';

enum _OccurrenceTab { all, pending, onTime, late, missed }

List<TaskOccurrenceEntity> _filterOccurrences(
  List<TaskOccurrenceEntity> occurrences,
  _OccurrenceTab tab,
) {
  return switch (tab) {
    _OccurrenceTab.all => occurrences,
    _OccurrenceTab.pending =>
      occurrences.where((o) => o.status == TaskOccurrenceStatus.pending).toList(),
    _OccurrenceTab.onTime =>
      occurrences.where((o) => o.status == TaskOccurrenceStatus.onTime).toList(),
    _OccurrenceTab.late =>
      occurrences.where((o) => o.status == TaskOccurrenceStatus.late).toList(),
    _OccurrenceTab.missed =>
      occurrences.where((o) => o.status == TaskOccurrenceStatus.missed).toList(),
  };
}

class OccurrencePage extends ConsumerStatefulWidget {
  const OccurrencePage({super.key});

  @override
  ConsumerState<OccurrencePage> createState() => _OccurrencePageState();
}

class _OccurrencePageState extends ConsumerState<OccurrencePage> {
  late DateTime _selectedDate;
  int? _selectedFacilityId;
  _OccurrenceTab _selectedTab = _OccurrenceTab.all;

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
        .fetch(facilityId: facilityId, date: DateFormat('yyyy-MM-dd').format(date));
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

  void _onTabChanged(_OccurrenceTab tab) {
    setState(() => _selectedTab = tab);
  }

  void _openReassignSheet(BuildContext context, TaskOccurrenceEntity occurrence) {
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

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.board),
        titleSpacing: spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
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
              facilities: facilities,
              selectedFacilityId: _selectedFacilityId,
              selectedDate: _selectedDate,
              selectedTab: _selectedTab,
              onDateChanged: _onDateChanged,
              onFacilityChanged: _onFacilityChanged,
              onTabChanged: _onTabChanged,
              onRetry: () => _fetch(_selectedDate),
              onReassign: (occurrence) => _openReassignSheet(context, occurrence),
              onChecklist: (occurrence) => _openChecklist(context, occurrence),
            ),
    );
  }
}

class _OccurrenceBoard extends ConsumerWidget {
  const _OccurrenceBoard({
    required this.facilities,
    required this.selectedFacilityId,
    required this.selectedDate,
    required this.selectedTab,
    required this.onDateChanged,
    required this.onFacilityChanged,
    required this.onTabChanged,
    required this.onRetry,
    required this.onReassign,
    required this.onChecklist,
  });

  final List<AccessibleFacilityEntity> facilities;
  final int? selectedFacilityId;
  final DateTime selectedDate;
  final _OccurrenceTab selectedTab;
  final void Function(DateTime) onDateChanged;
  final void Function(int) onFacilityChanged;
  final void Function(_OccurrenceTab) onTabChanged;
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
        _OccurrenceFacilityDropdown(
          facilities: facilities,
          selectedFacilityId: selectedFacilityId,
          onChanged: onFacilityChanged,
        ),
        HorizontalDatePicker.fortnight(onDateSelected: onDateChanged),
        state.when(
          loading: () => const SizedBox.shrink(),
          error: (e, s) => const SizedBox.shrink(),
          data: (entity) => _OccurrenceStatsHeader(
            stats: entity.stats,
            selectedTab: selectedTab,
            onTabChanged: onTabChanged,
          ),
        ),
        Expanded(
          child: state.when(
            loading: () => const Center(child: CircularProgressIndicator.adaptive()),
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
                  TextButton(onPressed: onRetry, child: Text(context.locale.retry)),
                ],
              ),
            ),
            data: (entity) {
              final occurrences = _filterOccurrences(entity.occurrences, selectedTab);
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
