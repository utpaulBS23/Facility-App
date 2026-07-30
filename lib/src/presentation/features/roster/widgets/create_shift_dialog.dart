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

    return FormDialogShell(
      title: context.locale.createShift,
      onClose: _onCancel,
      onCancel: _onCancel,
      onSubmit: isSubmitEnabled ? _onSubmit : null,
      isSubmitting: createState.isLoading,
      submitLabel: context.locale.createShift,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShiftTemplateField(
            templatesState: templatesState,
            selectedTemplateId: _shiftTemplateId,
            onChanged: (value) => setState(() => _shiftTemplateId = value),
          ),
          Gap(spacing.s20),
          _ShiftDateField(shiftDate: _shiftDate, onTap: _pickShiftDate),
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
    );
  }
}
