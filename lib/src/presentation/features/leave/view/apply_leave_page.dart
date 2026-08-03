import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_attendant_entity.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/apply_leave_form_provider.dart';
import '../riverpod/apply_leave_provider.dart';
import '../widgets/apply_leave_body.dart';
import '../widgets/apply_leave_submit_bar.dart';

class ApplyLeavePage extends ConsumerStatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  ConsumerState<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends ConsumerState<ApplyLeavePage> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(applyLeaveActionProvider, _onActionStateChanged);
  }

  void _onActionStateChanged(AsyncValue? previous, AsyncValue next) {
    next.whenOrNull(
      data: (value) {
        if (value == null || !mounted) {
          return;
        }

        ref.read(applyLeaveFormProvider.notifier).reset();
        context.pushReplacementNamed(Routes.leaveSubmitted, extra: value);
      },
      error: (e, _) {
        AppSnackBar.showError(context, context.locale.somethingWentWrong);
      },
    );
  }

  Future<void> _pickDate({
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

  Future<void> _onPickStartDate() async {
    final form = ref.read(applyLeaveFormProvider);

    await _pickDate(
      initialDate: form.startDate,
      firstDate: DateTime.now(),
      onPicked: ref.read(applyLeaveFormProvider.notifier).setStartDate,
    );
  }

  Future<void> _onPickEndDate() async {
    final form = ref.read(applyLeaveFormProvider);
    final initialDate =
        form.endDate.isBefore(form.startDate) ? form.startDate : form.endDate;

    await _pickDate(
      initialDate: initialDate,
      firstDate: form.startDate,
      onPicked: ref.read(applyLeaveFormProvider.notifier).setEndDate,
    );
  }

  Future<void> _onSelectShiftTap() async {
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

  Future<void> _onSelectAttendantTap() async {
    final a = await context.pushNamed<LeaveAttendantEntity>(
      Routes.selectAttendant,
    );

    if (a != null) {
      ref.read(applyLeaveFormProvider.notifier).setSelectedAttendant(a);
    }
  }

  Future<void> _onSubmit() async {
    final form = ref.read(applyLeaveFormProvider);
    if (!form.isSubmitEnabled) {
      return;
    }

    await ref.read(applyLeaveActionProvider.notifier).submit(form.toParams());
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitEnabled = ref.watch(
      applyLeaveFormProvider.select((s) => s.isSubmitEnabled),
    );

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.applyLeave),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: ApplyLeaveBody(
        onPickStartDate: _onPickStartDate,
        onPickEndDate: _onPickEndDate,
        onSelectShiftTap: _onSelectShiftTap,
        onSelectAttendantTap: _onSelectAttendantTap,
      ),
      bottomNavigationBar: ApplyLeaveSubmitBar(
        isEnabled: isSubmitEnabled,
        onTap: _onSubmit,
      ),
    );
  }
}
