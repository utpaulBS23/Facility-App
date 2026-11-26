import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/approval/approval_config_entity.dart';
import '../../domain/repositories/approval_config_repository.dart';
import '../extension/approval_config_mapper.dart';
import '../models/approval/approval_config_model.dart';
import '../services/network/rest_client.dart';

final class ApprovalConfigRepositoryImpl extends ApprovalConfigRepository {
  ApprovalConfigRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<List<ApprovalConfigEntity>, Failure>> getApprovalConfigs(
    ApprovalModule module,
  ) {
    return asyncGuard(() async {
      final response = await remote.getApprovalConfigs(
        module: module.wireValue,
      );
      final responseModel = ApprovalConfigListResponseModel.fromJson(
        response.data,
      );

      return responseModel.toEntity();
    });
  }
}
