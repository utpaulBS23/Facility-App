import '../../domain/entities/approval/approval_config_entity.dart';
import '../models/approval/approval_config_model.dart';

extension ApprovalConfigListResponseModelToEntity
    on ApprovalConfigListResponseModel {
  /// Rows without a role label cannot name a group, so they are dropped.
  List<ApprovalConfigEntity> toEntity() {
    return [
      for (final row in data)
        if (row.approverRoleLabel != null && row.approverRoleLabel!.isNotEmpty)
          ApprovalConfigEntity(
            approverRoleLabel: row.approverRoleLabel!,
            // WHY default true: the doc only says "active rows"; a row with
            // no flag is not known to be switched off.
            isActive: row.isActive ?? true,
            approverPermission: row.approverPermission,
            partnerId: row.partnerId,
          ),
    ];
  }
}
