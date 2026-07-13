import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/attendance_entity.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../../../core/utils/date_formatter.dart';
import '../riverpod/attendance_provider.dart';

part '../widgets/attendance_approve_reject_bar.dart';
part '../widgets/attendance_body.dart';
part '../widgets/attendance_detail_check_card.dart';
part '../widgets/attendance_detail_info_card.dart';
part '../widgets/attendance_detail_main_card.dart';
part '../widgets/attendance_detail_selfie_card.dart';
part '../widgets/attendance_detail_supervisor_card.dart';
part '../widgets/attendance_detail_tiles.dart';
part '../widgets/attendance_details_body.dart';
part '../widgets/attendance_list_item.dart';
part '../widgets/attendance_stats_card.dart';
part '../widgets/attendance_status_tag.dart';
part 'attendance_details_page.dart';

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  late String _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  void _onItemTap(AttendanceItemEntity item) {
    context.pushNamed(Routes.attendanceDetails, extra: item);
  }

  void _onApplyLeave() {
    context.pushNamed(Routes.applyLeave);
  }

  Future<void> _pickMonth() async {
    final parts = _selectedMonth.split('-');
    final initial = DateTime(int.parse(parts[0]), int.parse(parts[1]));
    final now = DateTime.now();

    await showDialog<void>(
      context: context,
      builder: (ctx) => _MonthPickerDialog(
        initialDate: initial,
        lastDate: now,
        onSelected: (date) {
          setState(() {
            _selectedMonth =
                '${date.year}-${date.month.toString().padLeft(2, '0')}';
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(monthlyAttendanceOverviewProvider(_selectedMonth));

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.attendance),
        titleSpacing: context.dimensions.spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        actions: [
          TextButton.icon(
            onPressed: _pickMonth,
            icon: const Icon(Icons.calendar_month_outlined, size: 18),
            label: Text(_selectedMonth),
          ),
        ],
      ),
      body: state.when(
        data: (summary) => _AttendanceBody(
          summary: summary,
          onItemTap: _onItemTap,
          onApplyLeave: _onApplyLeave,
          showApplyLeave: ref.watch(
            userSessionProvider.select(
              (session) => session?.can(AppPermission.leaveRequest) ?? false,
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
      ),
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

  String _monthLabel(BuildContext context, int month) =>
      DateFormat('MMM', Localizations.localeOf(context).languageCode)
          .format(DateTime(2000, month));

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
