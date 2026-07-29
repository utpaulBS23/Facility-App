import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/shift_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/leave_shifts_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/select_shift_body.dart';
part '../widgets/shimmer/shift_shimmer.dart';

class SelectShiftPage extends ConsumerWidget {
  const SelectShiftPage({
    super.key,
    required this.date,
    required this.partnerId,
  });

  final String date;
  final int partnerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = context.color;
    final shiftsAsync = ref.watch(
      leaveShiftsProvider(partnerId: partnerId, date: date),
    );

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const BackLeading(),
        leadingWidth: 100,
        title: Headline2xlTinyText(context.locale.selectShift),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: shiftsAsync.when(
        loading: () => const _ShiftListShimmer(),
        error: (err, _) => Center(
          child: Text(
            err.toString().replaceAll('Exception: ', ''),
            style: context.textStyle.bodyMedium.copyWith(
              color: color.text.secondary,
            ),
          ),
        ),
        data: (shifts) => _SelectShiftBody(shifts: shifts),
      ),
    );
  }
}
