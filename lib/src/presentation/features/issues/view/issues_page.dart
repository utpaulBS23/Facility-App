import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/checklist_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

part '../widgets/issue_card.dart';
part '../widgets/checklist_item_tile.dart';

sealed class _DemoItem {}

final class _RatingDemo extends _DemoItem {
  _RatingDemo({
    required this.order,
    required this.question,
    this.maxPoints = 5,
    this.requiresProof = false,
  });
  final int order;
  final String question;
  final int maxPoints;
  final bool requiresProof;
}

final class _BoolDemo extends _DemoItem {
  _BoolDemo({
    required this.order,
    required this.question,
    this.requiresProof = false,
  });
  final int order;
  final String question;
  final bool requiresProof;
}

final class _AttachmentOnlyDemo extends _DemoItem {
  _AttachmentOnlyDemo({required this.order, required this.instruction});
  final int order;
  final String instruction;
}

final class _IssueDemo extends _DemoItem {
  _IssueDemo({required this.issue});
  final ChecklistIssueEntity issue;
}

final _demoItems = <_DemoItem>[
  _RatingDemo(
    order: 1,
    question: 'Cleanliness of floor',
    maxPoints: 5,
    requiresProof: true,
  ),
  _BoolDemo(order: 2, question: 'Are all lights working?', requiresProof: true),
  _IssueDemo(
    issue: const ChecklistIssueEntity(
      id: 1,
      title: 'Broken light fixture',
      category: 'Electrical',
      location: 'Mirpur-10, Dhaka',
      priority: 'high',
      status: 'reported',
    ),
  ),
  _RatingDemo(
    order: 3,
    question: 'Condition of washroom fixtures',
    maxPoints: 5,
  ),
  _BoolDemo(order: 4, question: 'Is the area hazard-free?'),
  _AttachmentOnlyDemo(
    order: 5,
    instruction: 'Take a photo of the main entrance',
  ),
  _IssueDemo(
    issue: const ChecklistIssueEntity(
      id: 2,
      title: 'Clogged floor drain',
      category: 'Plumbing',
      location: 'Farmgate Overbridge, Dhaka',
      priority: 'medium',
      status: 'reported',
    ),
  ),
  _IssueDemo(
    issue: const ChecklistIssueEntity(
      id: 3,
      title: 'Cracked wall tile',
      category: 'Structural',
      location: 'Gulshan-1, Dhaka',
      priority: 'low',
      status: 'reported',
    ),
  ),
];

class IssuesPage extends StatelessWidget {
  const IssuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: LabelLargeText(context.locale.issues),
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(spacing.s16),
        itemCount: _demoItems.length,
        separatorBuilder: (context, index) {
          final item = _demoItems[index];
          final next = _demoItems[index + 1];
          final showDivider = item is! _IssueDemo && next is! _IssueDemo;
          return showDivider
              ? Divider(color: context.color.borderSubtle, height: 1)
              : Gap(spacing.s12);
        },
        itemBuilder: (context, index) {
          return switch (_demoItems[index]) {
            _RatingDemo(
              :final order,
              :final question,
              :final maxPoints,
              :final requiresProof,
            ) =>
              _RatingPickerTile(
                order: order,
                question: question,
                maxPoints: maxPoints,
                requiresProof: requiresProof,
              ),
            _BoolDemo(:final order, :final question, :final requiresProof) =>
              _BoolPickerTile(
                order: order,
                question: question,
                requiresProof: requiresProof,
              ),
            _AttachmentOnlyDemo(:final order, :final instruction) =>
              _AttachmentOnlyPickerTile(order: order, instruction: instruction),
            _IssueDemo(:final issue) => _IssueCard(issue: issue),
          };
        },
      ),
    );
  }
}
