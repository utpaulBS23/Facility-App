import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_request_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/leave_action_notifier.dart';

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
  bool _isApproving = false;
  bool _isRejecting = false;

  @override
  void initState() {
    super.initState();
    _actionSub = ref.listenManual(leaveRequestActionProvider, (_, next) {
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
    super.dispose();
  }

  void _onApprove() async {
    if (_isApproving || _isRejecting) return;
    setState(() => _isApproving = true);

    final success = await ref
        .read(leaveRequestActionProvider.notifier)
        .approve(widget.request.id);

    if (mounted) setState(() => _isApproving = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.color.success,
          content: Text(
            'Leave request approved.',
            style: TextStyle(color: context.color.onPrimary),
          ),
        ),
      );
      context.pop();
    }
  }

  void _onReject() async {
    if (_isApproving || _isRejecting) return;
    setState(() => _isRejecting = true);

    final success = await ref
        .read(leaveRequestActionProvider.notifier)
        .reject(widget.request.id);

    if (mounted) setState(() => _isRejecting = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.color.error,
          content: Text(
            'Leave request rejected.',
            style: TextStyle(color: context.color.onPrimary),
          ),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final spacing = context.dimensions.spacing;
    final color = context.color;

    final isActionable = request.canAction;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const BackLeading(),
        leadingWidth: 100,
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
          if (isActionable)
            Container(
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                spacing.s12,
                spacing.s16,
                spacing.s20,
              ),
              decoration: BoxDecoration(
                color: color.onPrimary,
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
                border: Border(top: BorderSide(color: color.borderSubtle)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed:
                          (_isApproving || _isRejecting) ? null : _onApprove,
                      style: FilledButton.styleFrom(
                        backgroundColor: color.primary,
                        foregroundColor: color.onPrimary,
                        minimumSize: Size(double.infinity, spacing.s44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                      ),
                      child: _isApproving
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: color.onPrimary,
                              ),
                            )
                          : Text(context.locale.approved),
                    ),
                  ),
                  Gap(spacing.s12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          (_isApproving || _isRejecting) ? null : _onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color.primary,
                        side: BorderSide(color: color.primary),
                        minimumSize: Size(double.infinity, spacing.s44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                      ),
                      child: _isRejecting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: color.primary,
                              ),
                            )
                          : Text(context.locale.rejection),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
