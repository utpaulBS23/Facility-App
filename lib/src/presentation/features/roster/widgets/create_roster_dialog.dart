part of '../view/roster_list_page.dart';

/// Single-week roster creation. Week always starts on Sunday (backend
/// validation: "Week must start on Sunday") — the app has no configurable
/// week-start setting yet, so this is hardcoded rather than exposed as a dead
/// control.
class CreateRosterDialog extends ConsumerStatefulWidget {
  const CreateRosterDialog({super.key, this.initialFacilityId});

  final int? initialFacilityId;

  @override
  ConsumerState<CreateRosterDialog> createState() =>
      _CreateRosterDialogState();
}

class _CreateRosterDialogState extends ConsumerState<CreateRosterDialog> {
  static const _weekLength = 7;

  int? _facilityId;
  late DateTime _weekStart;
  final Set<int> _activeDays = {
    for (var day = 1; day <= _weekLength; day++) day,
  };

  @override
  void initState() {
    super.initState();
    _facilityId = widget.initialFacilityId;
    _weekStart = _nextOrCurrentSunday(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFacilities());
  }

  void _loadFacilities() {
    final facilities = ref.read(facilityListProvider).valueOrNull;
    if (facilities == null || facilities.isEmpty) {
      ref.read(facilityListProvider.notifier).fetch();
    }
  }

  static DateTime _nextOrCurrentSunday(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final daysUntilSunday =
        (DateTime.sunday - normalized.weekday) % _weekLength;
    return normalized.add(Duration(days: daysUntilSunday));
  }

  DateTime get _weekEnd => _weekStart.add(const Duration(days: _weekLength - 1));

  Future<void> _pickWeekStart() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _weekStart,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: (date) => date.weekday == DateTime.sunday,
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
    final radius = context.dimensions.radius;
    final facilitiesState = ref.watch(facilityListProvider);
    final createState = ref.watch(createRosterProvider);

    ref.listen(createRosterProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        Navigator.of(context).pop(true);
      }
    });

    final isSubmitEnabled =
        _facilityId != null && _activeDays.isNotEmpty && !createState.isLoading;

    return Dialog(
      backgroundColor: context.color.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.r16),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogHeader(onClose: _onCancel),
              Divider(height: 1, color: context.color.borderSubtle),
              Padding(
                padding: EdgeInsets.all(spacing.s20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FacilityField(
                      facilitiesState: facilitiesState,
                      selectedFacilityId: _facilityId,
                      onChanged: _onFacilityChanged,
                    ),
                    Gap(spacing.s20),
                    _WeekStartField(weekStart: _weekStart, onTap: _pickWeekStart),
                    Gap(spacing.s20),
                    _ActiveDaysField(
                      activeDays: _activeDays,
                      onToggle: _toggleDay,
                    ),
                    Gap(spacing.s20),
                    _RosterInfoBox(weekStart: _weekStart, weekEnd: _weekEnd),
                    if (createState is AsyncError) ...[
                      Gap(spacing.s12),
                      Text(
                        createState.error.toString(),
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Divider(height: 1, color: context.color.borderSubtle),
              _DialogFooter(
                onCancel: _onCancel,
                onSubmit: isSubmitEnabled ? _onSubmit : null,
                isSubmitting: createState.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Padding(
      padding: EdgeInsets.fromLTRB(spacing.s20, spacing.s20, spacing.s12, spacing.s16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.locale.createRoster,
              style: context.textStyle.titleMedium.copyWith(
                color: context.color.text.primary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: Icon(Icons.close_rounded, color: context.color.icon),
          ),
        ],
      ),
    );
  }
}

class _FacilityField extends StatelessWidget {
  const _FacilityField({
    required this.facilitiesState,
    required this.selectedFacilityId,
    required this.onChanged,
  });

  final AsyncValue<List<FacilityEntity>> facilitiesState;
  final int? selectedFacilityId;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(context.locale.facilityName, required: true),
        Gap(context.dimensions.spacing.s8),
        facilitiesState.when(
          loading: () => const LinearProgressIndicator(),
          error: (err, _) => Text(
            err.toString(),
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.error,
            ),
          ),
          data: (facilities) => DropdownButtonFormField<int>(
            initialValue: selectedFacilityId,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r6,
                ),
              ),
            ),
            items: [
              for (final facility in facilities)
                DropdownMenuItem(value: facility.id, child: Text(facility.name)),
            ],
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}

class _WeekStartField extends StatelessWidget {
  const _WeekStartField({required this.weekStart, required this.onTap});

  final DateTime weekStart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(
          context.locale.weekStartLabel(DateFormat('EEE').format(weekStart)),
        ),
        Gap(spacing.s8),
        GestureDetector(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: context.color.icon,
                ),
                Gap(spacing.s8),
                Text(
                  DateFormat('d MMM yyyy').format(weekStart),
                  style: context.textStyle.bodyMedium.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActiveDaysField extends StatelessWidget {
  const _ActiveDaysField({required this.activeDays, required this.onToggle});

  final Set<int> activeDays;
  final ValueChanged<int> onToggle;

  static const _weekLength = 7;

  String _weekdayLabel(BuildContext context, int weekday) {
    return switch (weekday) {
      DateTime.monday => context.locale.mon,
      DateTime.tuesday => context.locale.tue,
      DateTime.wednesday => context.locale.wed,
      DateTime.thursday => context.locale.thu,
      DateTime.friday => context.locale.fri,
      DateTime.saturday => context.locale.sat,
      _ => context.locale.sun,
    };
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(context.locale.activeDaysThisWeek),
        Gap(spacing.s8),
        Wrap(
          spacing: spacing.s8,
          runSpacing: spacing.s8,
          children: [
            for (var day = 1; day <= _weekLength; day++)
              _DayChip(
                label: _weekdayLabel(context, day),
                isSelected: activeDays.contains(day),
                onTap: () => onToggle(day),
              ),
          ],
        ),
      ],
    );
  }
}

class _RosterInfoBox extends StatelessWidget {
  const _RosterInfoBox({required this.weekStart, required this.weekEnd});

  final DateTime weekStart;
  final DateTime weekEnd;

  @override
  Widget build(BuildContext context) {
    final apiFormat = DateFormat('yyyy-MM-dd');
    return Container(
      padding: EdgeInsets.all(context.dimensions.spacing.s12),
      decoration: BoxDecoration(
        color: context.color.backgroundMuted,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
      ),
      child: Text(
        context.locale.rosterCoversMessage(
          apiFormat.format(weekStart),
          apiFormat.format(weekEnd),
        ),
        style: context.textStyle.bodySmall.copyWith(
          color: context.color.text.secondary,
        ),
      ),
    );
  }
}

class _DialogFooter extends StatelessWidget {
  const _DialogFooter({
    required this.onCancel,
    required this.onSubmit,
    required this.isSubmitting,
  });

  final VoidCallback onCancel;
  final VoidCallback? onSubmit;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final radius = context.dimensions.radius;
    return Padding(
      padding: EdgeInsets.all(context.dimensions.spacing.s16),
      // WHY: OverflowBar (not a bare Row) — every button in this app's theme
      // forces minimumSize.width = infinity, which collides with the
      // unbounded main-axis width a plain Row gives non-flex children.
      // OverflowBar bounds each child's width instead.
      child: OverflowBar(
        alignment: MainAxisAlignment.end,
        spacing: context.dimensions.spacing.s8,
        children: [
          TextButton(
            onPressed: onCancel,
            child: Text(
              context.locale.cancel,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius.r6),
              ),
            ),
            onPressed: onSubmit,
            child: isSubmitting
                ? SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation(context.color.onPrimary),
                    ),
                  )
                : Text(
                    context.locale.createDraftRoster,
                    style: context.textStyle.labelLarge.copyWith(
                      color: context.color.onPrimary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label, {this.required = false});

  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.textStyle.labelMedium.copyWith(
            color: context.color.text.primary,
          ),
        ),
        if (required)
          Text(
            ' •',
            style: context.textStyle.labelMedium.copyWith(
              color: context.color.error,
            ),
          ),
      ],
    );
  }
}
