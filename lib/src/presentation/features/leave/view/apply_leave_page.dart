import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_attendant_entity.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/apply_leave_form_provider.dart';
import '../riverpod/apply_leave_provider.dart';
import '../widgets/apply_leave_body.dart';
import '../widgets/apply_leave_submit_bar.dart';

part 'apply_leave_handlers.dart';

class ApplyLeavePage extends ConsumerStatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  ConsumerState<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends ConsumerState<ApplyLeavePage> {
  ProviderSubscription<AsyncValue>? _actionSub;

  @override
  void initState() {
    super.initState();
    _actionSub = ref.listenManual(applyLeaveActionProvider, (_, next) {
      next.whenOrNull(
        data: (value) {
          if (value == null || !mounted) return;
          ref.read(applyLeaveFormProvider.notifier).reset();
          context.pushReplacementNamed(Routes.leaveSubmitted, extra: value);
        },
        error: (e, _) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.locale.somethingWentWrong)),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _actionSub?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitEnabled = ref.watch(
      applyLeaveFormProvider.select((s) => s.isSubmitEnabled),
    );

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: const BackLeading(),
        leadingWidth: context.dimensions.spacing.s100,
        title: Headline2xlTinyText(context.locale.applyLeave),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: ApplyLeaveBody(
        onPickStartDate: () => _onPickStartDate(context, ref),
        onPickEndDate: () => _onPickEndDate(context, ref),
        onSelectShiftTap: () => _onSelectShiftTap(context, ref),
        onSelectAttendantTap: () => _onSelectAttendantTap(context, ref),
      ),
      bottomNavigationBar: ApplyLeaveSubmitBar(
        isEnabled: isSubmitEnabled,
        onTap: () => _onSubmit(context, ref),
      ),
    );
  }
}
