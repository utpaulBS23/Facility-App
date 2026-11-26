import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/approval/approval_config_entity.dart';

abstract base class ApprovalConfigRepository extends Repository {
  Future<Result<List<ApprovalConfigEntity>, Failure>> getApprovalConfigs(
    ApprovalModule module,
  );
}
