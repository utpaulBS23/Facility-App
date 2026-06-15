import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/visit_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/my_visits_provider.dart';

part '../widgets/visit_calendar_strip.dart';
part '../widgets/visit_card.dart';
part '../widgets/visit_empty_state.dart';
part '../widgets/visit_stats_tabs.dart';

enum _VisitTab { today, week, completed }

class MyVisitsPage extends ConsumerStatefulWidget {
  const MyVisitsPage({super.key});

  @override
  ConsumerState<MyVisitsPage> createState() => _MyVisitsPageState();
}

class _MyVisitsPageState extends ConsumerState<MyVisitsPage> {
  late DateTime _selectedDate;
  _VisitTab _selectedTab = _VisitTab.today;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchVisits(_selectedDate));
  }

  void _fetchVisits(DateTime date) {
    ref.read(myVisitsProvider.notifier).fetch(
      date: DateFormat('yyyy-MM-dd').format(date),
    );
  }

  void _onDateChanged(DateTime date) {
    setState(() => _selectedDate = date);
    _fetchVisits(date);
  }

  void _onTabChanged(_VisitTab tab) {
    setState(() => _selectedTab = tab);
  }

  List<VisitSummaryEntity> _filteredVisits(List<VisitSummaryEntity> all) {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return switch (_selectedTab) {
      _VisitTab.today => all.where((v) => v.date == todayStr).toList(),
      _VisitTab.week => all,
      _VisitTab.completed =>
        all.where((v) => v.status == VisitStatus.completed).toList(),
    };
  }

  void _onVisitTap(VisitSummaryEntity visit) {
    context.pushNamed(Routes.visitDetail, extra: visit.id);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final visitState = ref.watch(myVisitsProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.myVisits),
        titleSpacing: spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: .stretch,
        children: [
          _VisitCalendarStrip(
            selectedDate: _selectedDate,
            onDateSelected: _onDateChanged,
          ),
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
