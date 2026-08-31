import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../../domain/entities/leave/leave_status.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../extensions/leave_presentation_extension.dart';
import '../riverpod/leave_requests_provider.dart';
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
  bool _lastActionWasApprove = true;

  @override
  void initState() {
    super.initState();
    ref.listenManual(leaveRequestsProvider, _onActionStateChanged);
  }

  void _onActionStateChanged(AsyncValue? previous, AsyncValue next) {
    next.whenOrNull(
      data: (value) {
        if (value == null || !mounted) return;
        final msg = switch (_lastActionWasApprove) {
          true => context.locale.approved,
          false => context.locale.rejection,
        };
        AppSnackBar.showSuccess(context, msg);
        if (context.canPop()) {
          context.pop();
        } else {
          context.goNamed(Routes.leaveRequests);
        }
      },
      error: (e, _) {
        AppSnackBar.showError(context, context.locale.somethingWentWrong);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.leaveDetails),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _LeaveDetailHeaderCard(leaveRequest: request),
                  Gap(spacing.s12),
                  _LeaveDetailInfoSection(leaveRequest: request),
                  Gap(spacing.s12),
                  _LeaveDetailShiftSection(leaveRequest: request),
                  Gap(spacing.s12),
                  _LeaveStatusTimeline(leaveRequest: request),
                ],
              ),
            ),
          ),
          // Show action bar only when server confirms caller can act on this
          // specific request right now (can_action is UX-only; server re-checks).
          if (request.canAction) ...[
            PermissionGate(
              permissions: const [
                UserPermission.leaveApproveSupervisor,
                UserPermission.leaveApproveManager,
              ],
              child: LeaveDetailsActionBar(
                leaveRequest: request,
                onActionStarted: (isApprove) =>
                    _lastActionWasApprove = isApprove,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
