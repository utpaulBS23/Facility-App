import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../riverpod/apply_leave_provider/leave_shifts_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/select_shift_body.dart';
part '../widgets/shimmer/shift_shimmer.dart';

class SelectShiftPage extends ConsumerStatefulWidget {
  const SelectShiftPage({super.key, required this.date});

  final String date;

  @override
  ConsumerState<SelectShiftPage> createState() => _SelectShiftPageState();
}

class _SelectShiftPageState extends ConsumerState<SelectShiftPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaveShiftsProvider.notifier).fetch(widget.date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final shiftsAsync = ref.watch(leaveShiftsProvider);

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.selectShift),
      body: shiftsAsync.when(
        loading: () => const _ShiftListShimmer(),
        error: (err, _) => AppErrorWidget(
          message: err.toString(),
          onRetry: () =>
              ref.read(leaveShiftsProvider.notifier).fetch(widget.date),
        ),
        data: (shifts) => _SelectShiftBody(shifts: shifts),
      ),
    );
  }
}
