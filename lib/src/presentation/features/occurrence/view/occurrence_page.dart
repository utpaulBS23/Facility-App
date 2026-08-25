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
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/task_occurrence_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/horizontal_date_picker.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/task_occurrence_reassign_provider.dart';
import '../riverpod/task_occurrences_provider.dart';

part '../widgets/occurrence_stats_header.dart';
part '../widgets/occurrence_slot_card.dart';
part '../widgets/occurrence_status_chip.dart';
part '../widgets/occurrence_reassign_sheet.dart';

class OccurrencePage extends ConsumerStatefulWidget {
  const OccurrencePage({super.key});

  @override
  ConsumerState<OccurrencePage> createState() => _OccurrencePageState();
}

class _OccurrencePageState extends ConsumerState<OccurrencePage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch(_selectedDate));
  }

  int? get _facilityId {
    final facilities = ref.read(userSessionProvider)?.accessibleFacilities;
    if (facilities == null || facilities.isEmpty) return null;
    for (final facility in facilities) {
      if (facility.isPrimary) return facility.id;
    }
    return facilities.first.id;
  }

  void _fetch(DateTime date) {
    final facilityId = _facilityId;
    if (facilityId == null) return;
    ref
        .read(taskOccurrencesProvider.notifier)
        .fetch(facilityId: facilityId, date: DateFormat('yyyy-MM-dd').format(date));
  }

  void _onDateChanged(DateTime date) {
    setState(() => _selectedDate = date);
    _fetch(date);
  }

  void _openReassignSheet(BuildContext context, TaskOccurrenceEntity occurrence) {
    final facilityId = _facilityId;
    if (facilityId == null) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OccurrenceReassignSheet(
        occurrence: occurrence,
        facilityId: facilityId,
      ),
    );
  }

  void _openChecklist(BuildContext context, TaskOccurrenceEntity occurrence) {
    context.pushNamed(Routes.occurrenceChecklist, extra: occurrence);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final facilityId = _facilityId;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.occurrences),
        titleSpacing: spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: facilityId == null
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
              onDateChanged: _onDateChanged,
              onRetry: () => _fetch(_selectedDate),
              onReassign: (occurrence) => _openReassignSheet(context, occurrence),
              onChecklist: (occurrence) => _openChecklist(context, occurrence),
            ),
    );
  }
}

class _OccurrenceBoard extends ConsumerWidget {
  const _OccurrenceBoard({
    required this.selectedDate,
    required this.onDateChanged,
    required this.onRetry,
    required this.onReassign,
    required this.onChecklist,
  });

  final DateTime selectedDate;
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
        HorizontalDatePicker.fortnight(onDateSelected: onDateChanged),
        state.when(
          loading: () => const SizedBox.shrink(),
          error: (e, s) => const SizedBox.shrink(),
          data: (entity) => _OccurrenceStatsHeader(stats: entity.stats),
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
              if (entity.occurrences.isEmpty) {
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
                itemCount: entity.occurrences.length,
                separatorBuilder: (context, i) => Gap(spacing.s12),
                itemBuilder: (_, i) => _OccurrenceSlotCard(
                  occurrence: entity.occurrences[i],
                  onReassign: () => onReassign(entity.occurrences[i]),
                  onChecklist: () => onChecklist(entity.occurrences[i]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
