import '../../domain/entities/common/approval_step_entity.dart';
import '../models/common/approval_step_model.dart';

extension ApprovalStepApproverModelToEntity on ApprovalStepApproverModel {
  ApprovalStepApproverEntity toEntity() =>
      ApprovalStepApproverEntity(id: id, name: name);
}

extension ApprovalStepModelToEntity on ApprovalStepModel {
  ApprovalStepEntity toEntity() {
    return ApprovalStepEntity(
      stepNumber: stepNumber,
      approverRole: approverRole,
      status: ApprovalStepStatus.fromWireString(status),
      requiredPermission: requiredPermission,
      approver: approver?.toEntity(),
      decidedAt: decidedAt ?? actedAt,
      note: rejectionNote ?? notes,
    );
  }
}
