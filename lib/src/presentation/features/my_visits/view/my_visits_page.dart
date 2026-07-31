import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/visit_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
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

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchVisits(_selectedDate),
    );
  }

  void _fetchVisits(DateTime date) {
    ref
        .read(myVisitsProvider.notifier)
        .fetch(date: DateFormat('yyyy-MM-dd').format(date));
  }

  void _onDateChanged(DateTime date) {
    setState(() => _selectedDate = date);
    _fetchVisits(date);
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HorizontalDatePicker.fortnight(onDateSelected: _onDateChanged),
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
