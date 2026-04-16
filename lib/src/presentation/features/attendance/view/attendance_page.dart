import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/attendance_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/attendance_provider.dart';

part '../widgets/attendance_body.dart';
part '../widgets/attendance_stats_card.dart';
part '../widgets/attendance_list_item.dart';
part 'attendance_details_page.dart';
part '../widgets/attendance_details_body.dart';
part '../widgets/attendance_detail_check_card.dart';
part '../widgets/attendance_detail_info_card.dart';
part '../widgets/attendance_detail_selfie_card.dart';
part '../widgets/attendance_detail_supervisor_card.dart';

class AttendancePage extends ConsumerWidget {
  const AttendancePage({super.key});

  void _onItemTap(BuildContext context, String id) {
    context.pushNamed(Routes.attendanceDetails, extra: id);
  }

  void _onApplyLeave(BuildContext context) {
    context.pushNamed(Routes.applyLeave);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(attendanceSummaryProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(context.locale.attendance),
        titleSpacing: context.dimensions.spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: state.when(
        data: (summary) => _AttendanceBody(
          summary: summary,
          onItemTap: (id) => _onItemTap(context, id),
          onApplyLeave: () => _onApplyLeave(context),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
      ),
    );
  }
}
