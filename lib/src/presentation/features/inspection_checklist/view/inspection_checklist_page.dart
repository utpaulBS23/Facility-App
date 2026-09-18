import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/checklist_entity.dart';
import '../../../../domain/entities/problem_category_entity.dart';
import '../../../../domain/entities/visit_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../../issues/riverpod/create_issue_provider.dart';
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

  Future<void> _onNewIssue() async {
    final result = await context.pushNamed<ChecklistIssueEntity>(
      Routes.problemReport,
      extra: {
        'visitId': widget.detail.id,
        'facilityId': widget.detail.facilityId ?? 0,
        'facilityName': widget.detail.facilityName,
      },
    );
    if (result != null) {
      ref.read(inspectionChecklistProvider.notifier).addLocalIssue(result);
    }
  }

  Future<void> _onEditIssue(ChecklistIssueEntity issue) async {
    final result = await context.pushNamed<ChecklistIssueEntity>(
      Routes.problemReport,
      extra: {
        'visitId': widget.detail.id,
        'facilityId': widget.detail.facilityId ?? 0,
        'facilityName': widget.detail.facilityName,
        'issue': issue,
      },
    );
    if (result != null) {
      ref.read(inspectionChecklistProvider.notifier).addLocalIssue(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final checklistState = ref.watch(inspectionChecklistProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.inspectionChecklist),
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
          : PermissionGate(
              permissions: [UserPermission.checklistResponseSubmit],
              builder: (context, isGranted) {
                // Check if all required items are answered (either via local state or existing response)
                final allRequiredAnswered = checklistState.checklist?.items
                    .where((item) => item.answerType != ChecklistAnswerType.repairWork && item.isRequired)
                    .every((item) {
                      final hasLocalAnswer = checklistState.starAnswers.containsKey(item.id) || checklistState.yesNoAnswers.containsKey(item.id);
                      final hasExistingAnswer = item.isAnswered;
                      return hasLocalAnswer || hasExistingAnswer;
                    }) ??
                    true;

                return _ChecklistBody(
                  detail: widget.detail,
                  checklistState: checklistState,
                  onSubmit: _onSubmit,
                  onNewIssue: _onNewIssue,
                  onEditIssue: (issue) => _onEditIssue(issue),
                  canSubmit: isGranted && allRequiredAnswered,
                );
              },
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
    this.onEditIssue,
  });

  final VisitDetailEntity detail;
  final InspectionChecklistState checklistState;
  final VoidCallback onSubmit;
  final VoidCallback onNewIssue;
  final Function(ChecklistIssueEntity)? onEditIssue;
  final bool canSubmit;

  void _onCancel(BuildContext context) => context.pop();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final checklist = checklistState.checklist!;
    // WHY: only resolved and completed visits are final — inProgress visits
    // still allow editing of checklist items.
    final isResolved =
        detail.status == VisitStatus.resolved ||
        detail.status == VisitStatus.completed;

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
              ...checklist.items
                  .where(
                    (item) => item.answerType != ChecklistAnswerType.repairWork,
                  )
                  .expand(
                    (item) => [
                      _InspectionItemTile(
                        item: item,
                        state: checklistState,
                        visitId: detail.id,
                        isResolved: isResolved,
                      ),
                      Divider(color: context.color.borderSubtle, height: 1),
                    ],
                  ),
              if (detail.facilityName != null) ...[
                _InspectionRepairWorkSection(
                  issues: [...checklist.issues, ...checklistState.localIssues],
                  onNewIssue: onNewIssue,
                  onEditIssue: onEditIssue,
                  canAddIssue: !isResolved,
                ),
                Gap(spacing.s8),
              ],
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
