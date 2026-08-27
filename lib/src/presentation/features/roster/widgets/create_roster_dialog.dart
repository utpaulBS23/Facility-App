part of '../view/roster_list_page.dart';

const _weekLength = 7;

/// Carbon/JS day numbering from the backend (0=Sunday...6=Saturday) mapped to
/// [DateTime]'s 1=Monday...7=Sunday. Shared by every widget in this library
/// that needs to translate the backend's week-start setting.
int _carbonToFlutterWeekday(int weekStartDay) {
  if (weekStartDay == 0) return DateTime.sunday;
  return weekStartDay.clamp(DateTime.monday, DateTime.saturday);
}

class CreateRosterDialog extends ConsumerStatefulWidget {
  const CreateRosterDialog({
    super.key,
    this.initialFacilityId,
    required this.weekStartDay,
  });

  final int? initialFacilityId;

  /// Carbon/JS day numbering from the backend: 0=Sunday ... 6=Saturday.
  final int weekStartDay;

  @override
  ConsumerState<CreateRosterDialog> createState() => _CreateRosterDialogState();
}

class _CreateRosterDialogState extends ConsumerState<CreateRosterDialog> {
  int? _facilityId;
  late DateTime _weekStart;
  final Set<int> _activeDays = {
    for (var day = 1; day <= _weekLength; day++) day,
  };

  @override
  void initState() {
    super.initState();
    _facilityId = widget.initialFacilityId;
    _weekStart = _nextOrCurrentWeekStart(DateTime.now(), widget.weekStartDay);
  }

  static DateTime _nextOrCurrentWeekStart(DateTime date, int weekStartDay) {
    final normalized = DateTime(date.year, date.month, date.day);
    final targetWeekday = _carbonToFlutterWeekday(weekStartDay);
    final daysUntilWeekStart =
        (targetWeekday - normalized.weekday) % _weekLength;
    return normalized.add(Duration(days: daysUntilWeekStart));
  }

  DateTime get _weekEnd =>
      _weekStart.add(const Duration(days: _weekLength - 1));

  int get _flutterWeekStartDay => _carbonToFlutterWeekday(widget.weekStartDay);

  Future<void> _pickWeekStart() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _weekStart,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: (date) => date.weekday == _flutterWeekStartDay,
    );
    if (picked != null) setState(() => _weekStart = picked);
  }

  void _onFacilityChanged(int facilityId) {
    setState(() => _facilityId = facilityId);
  }

  void _toggleDay(int weekday) {
    setState(() {
      if (_activeDays.contains(weekday)) {
        _activeDays.remove(weekday);
      } else {
        _activeDays.add(weekday);
      }
    });
  }

  void _onCancel() => Navigator.of(context).pop(false);

  void _onSubmit() {
    final facilityId = _facilityId;
    if (facilityId == null || _activeDays.isEmpty) return;

    final offDays = [
      for (var day = 1; day <= _weekLength; day++)
        if (!_activeDays.contains(day)) day,
    ];
    final apiFormat = DateFormat('yyyy-MM-dd');

    ref
        .read(createRosterProvider.notifier)
        .create(
          facilityId: facilityId,
          weekStartDate: apiFormat.format(_weekStart),
          weekEndDate: apiFormat.format(_weekEnd),
          offDays: offDays,
        );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final createState = ref.watch(createRosterProvider);

    ref.listen(createRosterProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        Navigator.of(context).pop(true);
      }
    });

    final isSubmitEnabled =
        _facilityId != null && _activeDays.isNotEmpty && !createState.isLoading;

    return FormDialogShell(
      title: context.locale.createRoster,
      onClose: _onCancel,
      onCancel: _onCancel,
      onSubmit: isSubmitEnabled ? _onSubmit : null,
      isSubmitting: createState.isLoading,
      submitLabel: context.locale.createDraftRoster,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FacilityField(
            facilities: facilities,
            selectedFacilityId: _facilityId,
            onChanged: _onFacilityChanged,
          ),
          Gap(spacing.s20),
          _WeekStartField(weekStart: _weekStart, onTap: _pickWeekStart),
          Gap(spacing.s20),
          _ActiveDaysField(
            activeDays: _activeDays,
            weekStartDay: widget.weekStartDay,
            onToggle: _toggleDay,
          ),
          Gap(spacing.s20),
          _RosterInfoBox(weekStart: _weekStart, weekEnd: _weekEnd),
          if (createState is AsyncError) ...[
            Gap(spacing.s12),
            Text(
              createState.error!.localizedMessage(context),
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
