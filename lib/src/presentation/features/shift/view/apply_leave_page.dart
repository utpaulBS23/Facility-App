import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import 'shift_page.dart';

part '../widgets/apply_leave_body.dart';
part '../widgets/select_shift_body.dart';
part 'select_shift_page.dart';

// WHY: Computes mock shifts relative to today so they are always
// visible when the user opens apply leave, regardless of the current date.
// WHY: Uses formatShiftDate from shift_body.dart (part of shift_page library)
// to avoid duplicating the date-formatting logic.
List<ShiftCardData> _buildApplyLeaveShifts() {
  final today = DateTime.now();
  final tomorrow = today.add(const Duration(days: 1));
  return [
    ShiftCardData(
      facilityName: 'Mirpur-10 Public Facility',
      supervisorName: 'Alice Rahman',
      supervisorPhone: '+880 1911-234567',
      address: 'Mirpur-10, Dhaka',
      timeRange: '07:00 AM – 03:00 PM',
      date: formatShiftDate(today),
      shiftDate: today,
      status: ShiftStatus.inProgress,
      shiftType: 'Morning',
    ),
    ShiftCardData(
      facilityName: 'Bijoy Sarani Tower',
      supervisorName: 'Rezaul Karim',
      supervisorPhone: '+880 1922-345678',
      address: 'Bijoy Sarani, Dhaka',
      timeRange: '08:00 AM – 04:00 PM',
      date: formatShiftDate(tomorrow),
      shiftDate: tomorrow,
      status: ShiftStatus.upcoming,
      shiftType: 'Morning',
    ),
  ];
}

class ApplyLeavePage extends StatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  ShiftCardData? _selectedShift;
  String? _selectedLeaveType;
  final _reasonController = TextEditingController();
  late final List<ShiftCardData> _allShifts;

  @override
  void initState() {
    super.initState();
    _allShifts = _buildApplyLeaveShifts();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _onSelectShiftTap() async {
    // WHY: go_router's pushNamed returns Future<T?> — pop(shift) on the
    // destination page delivers the selected shift back here without needing
    // a shared provider or a callback in extra.
    final shift = await context.pushNamed<ShiftCardData>(
      Routes.selectShift,
      extra: _allShifts,
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
