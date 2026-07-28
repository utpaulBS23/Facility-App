import 'package:facility_management_app/src/presentation/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

part '../widgets/apply_leave_body.dart';
part '../widgets/apply_leave_shift_selector.dart';
part '../widgets/apply_leave_summary_card.dart';
part '../widgets/select_shift_body.dart';
part 'select_shift_page.dart';

class ApplyLeavePage extends ConsumerStatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  ConsumerState<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends ConsumerState<ApplyLeavePage> {
  ShiftEntity? _selectedShift;
  String? _selectedLeaveType;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _onSelectShiftTap() async {
    // WHY: leave owns its own fetch instead of reading the shift tab's
    // provider. That provider is no longer populated for attendants (the tab
    // moved to shift-slots), and reaching across features for cached state
    // broke silently when the other feature changed.
    final result = await ref
        .read(getShiftsUseCaseProvider)
        .call(date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    final shifts = switch (result) {
      Success(:final data) => data ?? const <ShiftEntity>[],
      _ => const <ShiftEntity>[],
    };
    if (!mounted) return;
    // WHY: go_router's pushNamed returns Future<T?> — pop(shift) on the
    // destination page delivers the selected shift back here without needing
    // a shared provider or a callback in extra.
    final shift = await context.pushNamed<ShiftEntity>(
      Routes.selectShift,
      extra: shifts,
    );
    if (shift != null && mounted) {
      setState(() => _selectedShift = shift);
    }
  }

  void _onSubmit() {
    // TODO: submit leave request
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: context.pop,
          child: Row(
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: context.color.primary,
                size: 28,
              ),
              Text(
                context.locale.back,
                style: context.textStyle.labelXl.copyWith(
                  color: context.color.primary,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
        title: Headline2xlTinyText(context.locale.applyLeave),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: _ApplyLeaveBody(
        selectedShift: _selectedShift,
        selectedLeaveType: _selectedLeaveType,
        reasonController: _reasonController,
        onSelectShiftTap: _onSelectShiftTap,
      ),
      bottomNavigationBar: _SubmitBar(onTap: _onSubmit),
    );
  }
}
