import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/my_attendance_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/month_filter_button.dart';
import '../riverpod/my_attendance_provider.dart';

part '../widgets/my_attendance_item.dart';
part '../widgets/my_attendance_stats_card.dart';

class MyAttendancePage extends ConsumerStatefulWidget {
  const MyAttendancePage({super.key});

  @override
  ConsumerState<MyAttendancePage> createState() => _MyAttendancePageState();
}

class _MyAttendancePageState extends ConsumerState<MyAttendancePage> {
  late DateTime _monthStart;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _monthStart = DateTime(now.year, now.month);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch());
  }

  void _fetch() {
    final now = DateTime.now();
    final isCurrentMonth =
        _monthStart.year == now.year && _monthStart.month == now.month;
    final monthEnd = DateTime(_monthStart.year, _monthStart.month + 1, 0);
    final toDay = isCurrentMonth ? now : monthEnd;

    ref
        .read(myAttendanceProvider.notifier)
        .fetch(
          fromDay: DateFormat('yyyy-MM-dd').format(_monthStart),
          toDay: DateFormat('yyyy-MM-dd').format(toDay),
        );
  }

  void _onMonthSelected(DateTime date) {
    setState(() => _monthStart = DateTime(date.year, date.month));
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myAttendanceProvider);
    final spacing = context.dimensions.spacing;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.myAttendance,
        actions: [
          MonthFilterButton(
            month: _monthStart,
            lastDate: DateTime.now(),
            onSelected: _onMonthSelected,
          ),
        ],
      ),
      body: state.when(
        data: (overview) => RefreshIndicator(
          onRefresh: () async => _fetch(),
          child: overview.items.isEmpty
              ? const _MyAttendanceEmptyState()
              : ListView.separated(
                  padding: EdgeInsets.all(spacing.s16),
                  itemCount: overview.items.length + 1,
                  separatorBuilder: (_, _) => Gap(spacing.s10),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _MyAttendanceStatsCard(stats: overview.stats);
                    }
                    return _MyAttendanceItem(item: overview.items[index - 1]);
                  },
                ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.localizedMessage(context))),
      ),
    );
  }
}

class _MyAttendanceEmptyState extends StatelessWidget {
  const _MyAttendanceEmptyState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(top: context.dimensions.spacing.s96),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.event_available_outlined,
                  size: 48,
                  color: context.color.icon,
                ),
                Gap(context.dimensions.spacing.s16),
                Text(
                  context.locale.noAttendanceFound,
                  style: context.textStyle.bodyMedium.copyWith(
                    color: context.color.text.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
