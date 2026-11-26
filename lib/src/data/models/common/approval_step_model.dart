import 'package:dart_mappable/dart_mappable.dart';

part 'approval_step_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ApprovalStepApproverModel with ApprovalStepApproverModelMappable {
  const ApprovalStepApproverModel({required this.id, required this.name});

  final int id;
  final String name;

  static const fromJson = ApprovalStepApproverModelMapper.fromJson;
}

/// One step of a request's frozen approval chain. Leave and supply requests
/// name two fields differently (`decided_at`/`acted_at`,
/// `rejection_note`/`notes`), so this carries both and the mapper merges them.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ApprovalStepModel with ApprovalStepModelMappable {
  const ApprovalStepModel({
    required this.stepNumber,
    required this.approverRole,
    this.requiredPermission,
    this.approver,
    this.status,
    this.decidedAt,
    this.actedAt,
    this.rejectionNote,
    this.notes,
  });

  final int stepNumber;
  final String approverRole;
  final String? requiredPermission;
  final ApprovalStepApproverModel? approver;
  final String? status;
  final String? decidedAt;
  final String? actedAt;
  final String? rejectionNote;
  final String? notes;

  static const fromJson = ApprovalStepModelMapper.fromJson;
}
