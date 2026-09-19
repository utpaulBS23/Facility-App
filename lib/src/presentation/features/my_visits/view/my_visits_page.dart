import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/master_data_entity.dart';
import '../../../../domain/entities/visit_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/facility_filter_button.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/horizontal_date_picker.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/my_visits_provider.dart';

part '../widgets/visit_card.dart';
part '../widgets/visit_empty_state.dart';
part '../widgets/visit_stats_tabs.dart';

enum _VisitTab { all, pending, inProgress, completed }

class MyVisitsPage extends ConsumerStatefulWidget {
  const MyVisitsPage({super.key});

  @override
  ConsumerState<MyVisitsPage> createState() => _MyVisitsPageState();
}

class _MyVisitsPageState extends ConsumerState<MyVisitsPage> {
  late DateTime _selectedDate;
  _VisitTab _selectedTab = _VisitTab.all;
  late ScrollController _scrollController;
  int? _selectedFacilityId;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchVisits(_selectedDate),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      ref
          .read(myVisitsProvider.notifier)
          .loadMore(date: DateFormat('yyyy-MM-dd').format(_selectedDate));
    }
  }

  void _fetchVisits(DateTime date) {
    ref
        .read(myVisitsProvider.notifier)
        .fetch(
          date: DateFormat('yyyy-MM-dd').format(date),
          facilityId: _selectedFacilityId,
        );
  }

  void _onDateChanged(DateTime date) {
    setState(() => _selectedDate = date);
    if (_scrollController.positions.isNotEmpty) {
      _scrollController.jumpTo(0);
    }
    _fetchVisits(date);
  }

  Future<void> _onPickFacility(List<AccessibleFacilityEntity> facilities) async {
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
    _fetchVisits(_selectedDate);
  }

  void _onTabChanged(_VisitTab tab) {
    setState(() => _selectedTab = tab);
  }

  List<VisitSummaryEntity> _filteredVisits(List<VisitSummaryEntity> all) {
    return switch (_selectedTab) {
      _VisitTab.all => all,
      _VisitTab.pending =>
        all.where((v) => v.status == VisitStatus.pending).toList(),
      _VisitTab.inProgress =>
        all.where((v) => v.status == VisitStatus.inProgress).toList(),
      _VisitTab.completed =>
        all
            .where(
              (v) =>
                  v.status == VisitStatus.completed ||
                  v.status == VisitStatus.resolved,
            )
            .toList(),
    };
  }

  void _onVisitTap(VisitSummaryEntity visit) {
    context.pushNamed(Routes.visitDetail, extra: visit);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final visitState = ref.watch(myVisitsProvider);
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.myVisits),
        titleSpacing: spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (facilities.length > 1)
            FacilityFilterButton(
              hasSelection: _selectedFacilityId != null,
              onTap: () => _onPickFacility(facilities),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HorizontalDatePicker.week(onDateSelected: _onDateChanged),
          visitState.when(
            loading: () => const SizedBox.shrink(),
            error: (e, s) => const SizedBox.shrink(),
            data: (entity) => _VisitStatsTabs(
              stats: entity.stats,
              selectedTab: _selectedTab,
              onTabChanged: _onTabChanged,
            ),
          ),
          Expanded(
            child: visitState.when(
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
                      onPressed: () => _fetchVisits(_selectedDate),
                      child: Text(context.locale.retry),
                    ),
                  ],
                ),
              ),
              data: (entity) {
                final filtered = _filteredVisits(entity.visits);
                if (filtered.isEmpty) {
                  return _VisitEmptyState(tab: _selectedTab);
                }
                return ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.all(spacing.s16),
                  itemCount: filtered.length,
                  separatorBuilder: (context, i) => Gap(spacing.s12),
                  itemBuilder: (_, i) => _VisitCard(
                    visit: filtered[i],
                    onTap: () => _onVisitTap(filtered[i]),
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
