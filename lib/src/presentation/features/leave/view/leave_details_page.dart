import 'package:facility_management_app/src/domain/entities/login_entity.dart';
import 'package:facility_management_app/src/presentation/core/widgets/permission_gate.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../../domain/entities/leave/leave_status.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../extensions/leave_type_extension.dart';
import '../riverpod/leave_request_action_provider.dart';
import '../widgets/leave_details_action_bar.dart';

part '../widgets/leave_detail_header_card.dart';
part '../widgets/leave_detail_info_section.dart';
part '../widgets/leave_detail_shift_section.dart';
part '../widgets/leave_status_timeline.dart';

class LeaveDetailsPage extends ConsumerStatefulWidget {
  const LeaveDetailsPage({super.key, required this.request});

  final LeaveRequestEntity request;

  @override
  ConsumerState<LeaveDetailsPage> createState() => _LeaveDetailsPageState();
}

class _LeaveDetailsPageState extends ConsumerState<LeaveDetailsPage> {
  ProviderSubscription<AsyncValue>? _actionSub;
  bool _lastActionWasApprove = true;

  @override
  void initState() {
    super.initState();
    _actionSub = ref.listenManual(leaveRequestActionProvider, (_, next) {
      next.whenOrNull(
        data: (value) {
          if (value == null || !mounted) return;
          final msg = _lastActionWasApprove
              ? context.locale.approved
              : context.locale.rejection;
          AppSnackBar.showSuccess(context, msg);
          context.pop();
        },
        error: (e, _) {
          if (!mounted) return;
          AppSnackBar.showError(context, context.locale.somethingWentWrong);
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
    final request = widget.request;
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const BackLeading(),
        leadingWidth: context.dimensions.spacing.s100,
        title: Headline2xlTinyText(context.locale.leaveDetails),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _LeaveDetailHeaderCard(request: request),
                  Gap(spacing.s12),
                  _LeaveDetailInfoSection(request: request),
                  Gap(spacing.s12),
                  _LeaveDetailShiftSection(request: request),
                  Gap(spacing.s12),
                  _LeaveStatusTimeline(request: request),
                ],
              ),
            ),
          ),
          // Show action bar based on permission
          PermissionGate(
            anyOf: const [
              AppPermission.leaveApproveSupervisor,
              AppPermission.leaveApproveManager,
            ],
            child: LeaveDetailsActionBar(
              request: request,
              onActionStarted: (isApprove) => _lastActionWasApprove = isApprove,
            ),
          ),
        ],
      ),
    );
  }
}
