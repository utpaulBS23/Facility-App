import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/checklist_entity.dart';
import '../../../../domain/entities/visit_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/inspection_checklist_provider.dart';

part '../widgets/inspection_bottom_bar.dart';
part '../widgets/inspection_facility_card.dart';
part '../widgets/inspection_item_tile.dart';
part '../widgets/inspection_progress_header.dart';
part '../widgets/inspection_repair_work_section.dart';

class InspectionChecklistPage extends ConsumerStatefulWidget {
  const InspectionChecklistPage({super.key, required this.detail});

  final VisitDetailEntity detail;

  @override
  ConsumerState<InspectionChecklistPage> createState() =>
      _InspectionChecklistPageState();
}

class _InspectionChecklistPageState
    extends ConsumerState<InspectionChecklistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onLoadChecklist());
  }

  void _onLoadChecklist() {
    ref
        .read(inspectionChecklistProvider.notifier)
        .loadChecklist(visitId: widget.detail.id);
  }

  Future<void> _onSubmit() async {
    await ref
        .read(inspectionChecklistProvider.notifier)
        .submit(visitId: widget.detail.id);
    if (!mounted) return;
    final state = ref.read(inspectionChecklistProvider);
    if (state.submitSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.locale.visitSubmittedSuccessfully),
          backgroundColor: context.color.success,
        ),
      );
      context.goNamed(Routes.myVisits);
    } else if (state.submitError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.locale.submitChecklistFailed),
          backgroundColor: context.color.error,
        ),
      );
    }
  }

  void _onNewIssue() {
    context.pushNamed(Routes.problemReport, extra: widget.detail.id);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final checklistState = ref.watch(inspectionChecklistProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: LabelLargeText(context.locale.inspectionChecklist),
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: checklistState.isLoadingChecklist
          ? const Center(child: CircularProgressIndicator.adaptive())
          : checklistState.checklistError != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BodyRegularText(
                    context.locale.inspectionChecklistLoadFailed,
                    color: context.color.text.secondary,
                    textAlign: TextAlign.center,
                  ),
                  Gap(spacing.s16),
                  TextButton(
                    onPressed: _onLoadChecklist,
                    child: Text(context.locale.retry),
                  ),
                ],
              ),
            )
          : _ChecklistBody(
              detail: widget.detail,
              checklistState: checklistState,
              onSubmit: _onSubmit,
              onNewIssue: _onNewIssue,
              canSubmit: ref.watch(
                userSessionProvider.select(
                  (session) =>
                      session?.can(UserPermission.checklistResponseSubmit) ??
                      false,
                ),
              ),
            ),
    );
  }
}

class _ChecklistBody extends StatelessWidget {
  const _ChecklistBody({
    required this.detail,
    required this.checklistState,
    required this.onSubmit,
    required this.onNewIssue,
    required this.canSubmit,
  });

  final VisitDetailEntity detail;
  final InspectionChecklistState checklistState;
  final VoidCallback onSubmit;
  final VoidCallback onNewIssue;
  final bool canSubmit;

  void _onCancel(BuildContext context) => context.pop();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final checklist = checklistState.checklist!;
    final isResolved = detail.status == VisitStatus.resolved;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(spacing.s16),
            children: [
              _InspectionFacilityCard(detail: detail),
              Gap(spacing.s16),
              _InspectionProgressHeader(state: checklistState),
              Gap(spacing.s8),
              ...checklist.items.expand((item) {
                if (item.answerType == ChecklistAnswerType.repairWork) {
                  return [
                    _InspectionRepairWorkSection(
                      item: item,
                      issues: checklist.issues,
                      onNewIssue: onNewIssue,
                    ),
                    Divider(color: context.color.borderSubtle, height: 1),
                  ];
                }
                return [
                  _InspectionItemTile(
                    item: item,
                    state: checklistState,
                    visitId: detail.id,
                    isResolved: isResolved,
                  ),
                  Divider(color: context.color.borderSubtle, height: 1),
                ];
              }),
              Gap(spacing.s8),
            ],
          ),
        ),
        _InspectionBottomBar(
          state: checklistState,
          isResolved: isResolved,
          canSubmit: canSubmit,
          onSubmit: onSubmit,
          onCancel: () => _onCancel(context),
        ),
      ],
    );
  }
}
