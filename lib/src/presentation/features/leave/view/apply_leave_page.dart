import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/leave/leave_attendant_entity.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../../domain/repositories/leave_repository.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/apply_leave_notifier.dart';
import '../riverpod/leave_balance_provider.dart';
import '../riverpod/leave_policies_provider.dart';
import '../widgets/shimmer/stat_tile_shimmer.dart';
import '../widgets/stat_tile.dart';

part 'apply_leave_handlers.dart';
part '../widgets/apply_leave_attendant_selector.dart';
part '../widgets/apply_leave_body.dart';
part '../widgets/apply_leave_date_selector.dart';
part '../widgets/apply_leave_shift_selector.dart';
part '../widgets/apply_leave_summary_card.dart';
part '../widgets/apply_leave_type_switch.dart';

enum LeaveApplicationType { own, onBehalf }

class ApplyLeavePage extends ConsumerStatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  ConsumerState<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends ConsumerState<ApplyLeavePage> {
  ShiftEntity? _selectedShift;
  int? _selectedLeavePolicyId;
  LeaveAttendantEntity? _selectedAttendant;
  LeaveApplicationType _appType = LeaveApplicationType.own;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final _reasonController = TextEditingController();
  ProviderSubscription<AsyncValue>? _actionSub;

  void updateState(VoidCallback fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    _actionSub = ref.listenManual(applyLeaveActionProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _actionSub?.close();
    _reasonController.dispose();
    super.dispose();
  }

  bool get _isSubmitEnabled {
    final hasLeaveType = _selectedLeavePolicyId != null;
    if (_appType == LeaveApplicationType.onBehalf) {
      return _selectedAttendant != null && hasLeaveType;
    }
    return hasLeaveType;
  }

  @override
  Widget build(BuildContext context) {
    final canFileOnBehalf = ref
        .watch(hasPermissionUseCaseProvider)
        .call(AppPermission.leaveFileOnBehalf);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: const BackLeading(),
        leadingWidth: 100,
        title: Headline2xlTinyText(context.locale.applyLeave),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: _ApplyLeaveBody(
        appType: _appType,
        onAppTypeChanged: (type) {
          if (_appType == type) return;
          setState(() {
            _appType = type;
            _selectedLeavePolicyId = null;
            _selectedShift = null;
            _startDate = DateTime.now();
            _endDate = DateTime.now();
            _selectedAttendant = null;
          });
        },
        startDate: _startDate,
        endDate: _endDate,
        onStartDateTap: _onPickStartDate,
        onEndDateTap: _onPickEndDate,
        selectedShift: _selectedShift,
        selectedLeavePolicyId: _selectedLeavePolicyId,
        onLeavePolicyChanged: (id) =>
            setState(() => _selectedLeavePolicyId = id),
        reasonController: _reasonController,
        onSelectShiftTap: _onSelectShiftTap,
        selectedAttendant: _selectedAttendant,
        onSelectAttendantTap: _onSelectAttendantTap,
        showAttendantTab: canFileOnBehalf,
      ),
      bottomNavigationBar: _SubmitBar(
        isEnabled: _isSubmitEnabled,
        onTap: _onSubmit,
      ),
    );
  }
}
