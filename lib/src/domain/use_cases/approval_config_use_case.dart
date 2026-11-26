import '../../core/base/base.dart';
import '../entities/approval/approval_config_entity.dart';
import '../repositories/approval_config_repository.dart';
import 'partner_use_case.dart';

/// The approver groups a request of [ApprovalModule] can be waiting on, one
/// per distinct role, in the order the groups sit in an approval chain.
final class GetApprovalGroupsUseCase extends PartnerUseCase {
  GetApprovalGroupsUseCase({
    required this.approvalConfigRepository,
    required super.authRepository,
  });

  final ApprovalConfigRepository approvalConfigRepository;

  Future<Result<List<ApprovalGroupEntity>, Failure>> call(
    ApprovalModule module,
  ) async {
    final partnerId = getPartnerId();
    final result = await approvalConfigRepository.getApprovalConfigs(module);

    return switch (result) {
      Success(:final data) => Success(
        data: _toGroups(data ?? const [], partnerId),
      ),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('load approval groups')),
    };
  }

  List<ApprovalGroupEntity> _toGroups(
    List<ApprovalConfigEntity> configs,
    int partnerId,
  ) {
    // WHY filter by partner: the list also carries other partners' own
    // chains; a role only they use would never match one of our requests.
    final byRole = <String, ({String label, int order})>{};
    for (final config in configs) {
      if (!config.isActive) continue;
      if (config.partnerId != null && config.partnerId != partnerId) continue;

      final role = _roleSlug(config.approverRoleLabel);
      if (role.isEmpty) continue;

      final order = _roleOrder(config.approverPermission);
      final known = byRole[role];
      if (known == null || order < known.order) {
        byRole[role] = (label: config.approverRoleLabel, order: order);
      }
    }

    final entries = byRole.entries.toList()
      ..sort((a, b) => a.value.order.compareTo(b.value.order));

    return [
      for (final entry in entries)
        ApprovalGroupEntity(role: entry.key, label: entry.value.label),
    ];
  }

  /// `HR & Admin` becomes `hr_admin`, `Ops Manager` becomes `ops_manager`:
  /// the slug form the list endpoints take as `waiting_for`.
  String _roleSlug(String label) {
    return label
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  /// The trailing number of `leave.approve_step_4` is the same for a role in
  /// every chain, unlike `step_number`, which is a position within one chain.
  int _roleOrder(String? permission) {
    final match = RegExp(r'(\d+)$').firstMatch(permission ?? '');
    return match == null ? 1 << 20 : int.parse(match.group(1)!);
  }
}
