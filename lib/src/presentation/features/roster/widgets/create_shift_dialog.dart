part of '../view/roster_shifts_page.dart';

class CreateShiftDialog extends ConsumerStatefulWidget {
  const CreateShiftDialog({super.key, required this.roster});

  final RosterEntity roster;

  @override
  ConsumerState<CreateShiftDialog> createState() => _CreateShiftDialogState();
}

class _CreateShiftDialogState extends ConsumerState<CreateShiftDialog> {
  late DateTime _shiftDate;
  int? _shiftTemplateId;
  final _minController = TextEditingController(text: '1');
  final _maxController = TextEditingController(text: '1');
  final _notesController = TextEditingController();

  DateTime get _weekStart => DateTime.parse(widget.roster.weekStartDate);
  DateTime get _weekEnd => DateTime.parse(widget.roster.weekEndDate);

  @override
  void initState() {
    super.initState();
    _shiftDate = _weekStart;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final templates = ref.read(shiftTemplateListProvider).valueOrNull;
      if (templates == null || templates.isEmpty) {
        ref.read(shiftTemplateListProvider.notifier).fetch();
      }
    });
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickShiftDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _shiftDate,
      firstDate: _weekStart,
      lastDate: _weekEnd,
    );
    if (picked != null) setState(() => _shiftDate = picked);
  }

  void _onCancel() => Navigator.of(context).pop(false);

  void _onSubmit() {
    final templateId = _shiftTemplateId;
    final min = int.tryParse(_minController.text);
    final max = int.tryParse(_maxController.text);
    if (templateId == null || min == null || max == null || max < min) return;

    ref
        .read(createShiftProvider.notifier)
        .create(
          facilityId: widget.roster.facilityId,
          rosterId: widget.roster.id,
          shiftTemplateId: templateId,
          shiftDate: DateFormat('yyyy-MM-dd').format(_shiftDate),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          minAttendants: min,
          maxAttendants: max,
        );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final templatesState = ref.watch(shiftTemplateListProvider);
    final createState = ref.watch(createShiftProvider);

    ref.listen(createShiftProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        Navigator.of(context).pop(true);
      }
    });

    final min = int.tryParse(_minController.text);
    final max = int.tryParse(_maxController.text);
    final isMinMaxValid = min != null && max != null && min > 0 && max >= min;
    final isSubmitEnabled =
        _shiftTemplateId != null && isMinMaxValid && !createState.isLoading;

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
              _ShiftDialogHeader(onClose: _onCancel),
              Divider(height: 1, color: context.color.borderSubtle),
              Padding(
                padding: EdgeInsets.all(spacing.s20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShiftTemplateField(
                      templatesState: templatesState,
                      selectedTemplateId: _shiftTemplateId,
                      onChanged: (value) =>
                          setState(() => _shiftTemplateId = value),
                    ),
                    Gap(spacing.s20),
                    _ShiftDateField(
                      shiftDate: _shiftDate,
                      onTap: _pickShiftDate,
                    ),
                    Gap(spacing.s20),
                    Row(
                      children: [
                        Expanded(
                          child: _AttendantCountField(
                            label: context.locale.minAttendants,
                            controller: _minController,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        Gap(spacing.s12),
                        Expanded(
                          child: _AttendantCountField(
                            label: context.locale.maxAttendants,
                            controller: _maxController,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    if (min != null && max != null && max < min) ...[
                      Gap(spacing.s8),
                      Text(
                        context.locale.maxAttendantsError,
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.error,
                        ),
                      ),
                    ],
                    Gap(spacing.s20),
                    _NotesField(controller: _notesController),
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
              ),
              Divider(height: 1, color: context.color.borderSubtle),
              _ShiftDialogFooter(
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

class _ShiftDialogHeader extends StatelessWidget {
  const _ShiftDialogHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.s20,
        spacing.s20,
        spacing.s12,
        spacing.s16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.locale.createShift,
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

class _ShiftTemplateField extends StatelessWidget {
  const _ShiftTemplateField({
    required this.templatesState,
    required this.selectedTemplateId,
    required this.onChanged,
  });

  final AsyncValue<List<ShiftTemplateEntity>> templatesState;
  final int? selectedTemplateId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShiftFieldLabel(context.locale.shiftTemplate),
        Gap(context.dimensions.spacing.s8),
        templatesState.when(
          loading: () => const LinearProgressIndicator(),
          error: (err, _) => Text(
            err.localizedMessage(context),
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.error,
            ),
          ),
          data: (templates) => DropdownButtonFormField<int>(
            initialValue: selectedTemplateId,
            hint: Text(context.locale.selectShiftTemplate),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r6,
                ),
              ),
            ),
            items: [
              for (final template in templates)
                DropdownMenuItem(
                  value: template.id,
                  child: Text(
                    '${template.name} (${template.startTime}–${template.endTime})',
                  ),
                ),
            ],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _ShiftDateField extends StatelessWidget {
  const _ShiftDateField({required this.shiftDate, required this.onTap});

  final DateTime shiftDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShiftFieldLabel(context.locale.shiftDate),
        Gap(spacing.s8),
        GestureDetector(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r6,
                ),
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
                  DateFormat('d MMM yyyy').format(shiftDate),
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

class _AttendantCountField extends StatelessWidget {
  const _AttendantCountField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShiftFieldLabel(label),
        Gap(context.dimensions.spacing.s8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
            ),
          ),
        ),
      ],
    );
  }
}

class _NotesField extends StatelessWidget {
  const _NotesField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShiftFieldLabel(context.locale.notes),
        Gap(context.dimensions.spacing.s8),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShiftDialogFooter extends StatelessWidget {
  const _ShiftDialogFooter({
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
                      valueColor: AlwaysStoppedAnimation(
                        context.color.onPrimary,
                      ),
                    ),
                  )
                : Text(
                    context.locale.createShift,
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

class _ShiftFieldLabel extends StatelessWidget {
  const _ShiftFieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textStyle.labelMedium.copyWith(
        color: context.color.text.primary,
      ),
    );
  }
}
