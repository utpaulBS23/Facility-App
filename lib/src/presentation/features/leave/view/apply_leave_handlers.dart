part of 'apply_leave_page.dart';

Future<void> _pickDate(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime firstDate,
  required ValueChanged<DateTime> onPicked,
}) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );

  if (picked != null) {
    onPicked(picked);
  }
}

Future<void> _onPickStartDate(BuildContext context, WidgetRef ref) async {
  final form = ref.read(applyLeaveFormProvider);

  await _pickDate(
    context,
    initialDate: form.startDate,
    firstDate: DateTime.now(),
    onPicked: ref.read(applyLeaveFormProvider.notifier).setStartDate,
  );
}

Future<void> _onPickEndDate(BuildContext context, WidgetRef ref) async {
  final form = ref.read(applyLeaveFormProvider);
  final initialDate =
      form.endDate.isBefore(form.startDate) ? form.startDate : form.endDate;

  await _pickDate(
    context,
    initialDate: initialDate,
    firstDate: form.startDate,
    onPicked: ref.read(applyLeaveFormProvider.notifier).setEndDate,
  );
}

Future<void> _onSelectShiftTap(BuildContext context, WidgetRef ref) async {
  final form = ref.read(applyLeaveFormProvider);
  final date = DateFormat('yyyy-MM-dd').format(form.startDate);
  final s = await context.pushNamed<ShiftEntity>(
    Routes.selectShift,
    extra: date,
  );

  if (s != null) {
    ref.read(applyLeaveFormProvider.notifier).setSelectedShift(s);
  }
}

Future<void> _onSelectAttendantTap(BuildContext context, WidgetRef ref) async {
  final a = await context.pushNamed<LeaveAttendantEntity>(
    Routes.selectAttendant,
  );

  if (a != null) {
    ref.read(applyLeaveFormProvider.notifier).setSelectedAttendant(a);
  }
}

Future<void> _onSubmit(BuildContext context, WidgetRef ref) async {
  final form = ref.read(applyLeaveFormProvider);
  if (!form.isSubmitEnabled) {
    return;
  }

  await ref.read(applyLeaveActionProvider.notifier).submit(form.toParams());
}
