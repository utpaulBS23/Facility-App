part of 'apply_leave_page.dart';

Future<void> _onPickStartDate(BuildContext context, WidgetRef ref) async {
  final form = ref.read(applyLeaveFormProvider);
  final formNotifier = ref.read(applyLeaveFormProvider.notifier);
  final picked = await showDatePicker(
    context: context,
    initialDate: form.startDate,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
  if (picked != null) {
    formNotifier.setStartDate(picked);
  }
}

Future<void> _onPickEndDate(BuildContext context, WidgetRef ref) async {
  final form = ref.read(applyLeaveFormProvider);
  final formNotifier = ref.read(applyLeaveFormProvider.notifier);
  final picked = await showDatePicker(
    context: context,
    initialDate:
        form.endDate.isBefore(form.startDate) ? form.startDate : form.endDate,
    firstDate: form.startDate,
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
  if (picked != null) {
    formNotifier.setEndDate(picked);
  }
}

Future<void> _onSelectShiftTap(BuildContext context, WidgetRef ref) async {
  final pid = ref.read(getActivePartnerUseCaseProvider).call();
  if (pid == null) return;
  final form = ref.read(applyLeaveFormProvider);
  final date = DateFormat('yyyy-MM-dd').format(form.startDate);
  final s = await context.pushNamed<ShiftEntity>(
    Routes.selectShift,
    extra: (date: date, partnerId: pid),
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
  if (!form.isSubmitEnabled) return;
  await ref.read(applyLeaveActionProvider.notifier).submit(form.toParams());
}
