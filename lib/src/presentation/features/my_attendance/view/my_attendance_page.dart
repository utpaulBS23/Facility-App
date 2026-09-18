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

  Future<void> _pickMonth() async {
    final now = DateTime.now();
    await showDialog<void>(
      context: context,
      builder: (ctx) => _MonthPickerDialog(
        initialDate: _monthStart,
        lastDate: now,
        onSelected: (date) {
          setState(() => _monthStart = DateTime(date.year, date.month));
          _fetch();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myAttendanceProvider);
    final spacing = context.dimensions.spacing;
    final monthLabel = DateFormat('MMM yyyy').format(_monthStart);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.myAttendance,
        actions: [
          TextButton.icon(
            onPressed: _pickMonth,
            icon: const Icon(Icons.calendar_month_outlined, size: 18),
            label: Text(monthLabel),
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

class _MonthPickerDialog extends StatefulWidget {
  const _MonthPickerDialog({
    required this.initialDate,
    required this.lastDate,
    required this.onSelected,
  });

  final DateTime initialDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelected;

  @override
  State<_MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  late DateTime _current;

  @override
  void initState() {
    super.initState();
    _current = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  String _monthLabel(BuildContext context, int month) => DateFormat(
    'MMM',
    Localizations.localeOf(context).languageCode,
  ).format(DateTime(2000, month));

  bool _isDisabled(int year, int month) {
    final date = DateTime(year, month);
    return date.isAfter(DateTime(widget.lastDate.year, widget.lastDate.month));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () =>
                setState(() => _current = DateTime(_current.year - 1)),
          ),
          Text(_current.year.toString(), style: context.textStyle.titleMedium),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _current.year >= widget.lastDate.year
                ? null
                : () => setState(() => _current = DateTime(_current.year + 1)),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: context.dimensions.spacing.s8,
            crossAxisSpacing: context.dimensions.spacing.s8,
            childAspectRatio: 2,
          ),
          itemCount: 12,
          itemBuilder: (context, i) {
            final month = i + 1;
            final disabled = _isDisabled(_current.year, month);
            final isSelected =
                _current.year == widget.initialDate.year &&
                month == widget.initialDate.month;
            return TextButton(
              onPressed: disabled
                  ? null
                  : () {
                      widget.onSelected(DateTime(_current.year, month));
                      Navigator.of(context).pop();
                    },
              style: TextButton.styleFrom(
                backgroundColor: isSelected ? context.color.primary : null,
                foregroundColor: isSelected ? context.color.onPrimary : null,
              ),
              child: Text(_monthLabel(context, month)),
            );
          },
        ),
      ),
    );
  }
}
