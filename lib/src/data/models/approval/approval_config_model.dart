import 'package:dart_mappable/dart_mappable.dart';

part 'approval_config_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ApprovalConfigModel with ApprovalConfigModelMappable {
  const ApprovalConfigModel({
    this.partnerId,
    this.approverPermission,
    this.approverRoleLabel,
    this.isActive,
  });

  final int? partnerId;
  final String? approverPermission;
  final String? approverRoleLabel;
  final bool? isActive;

  static const fromJson = ApprovalConfigModelMapper.fromJson;
}

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.decode,
)
class ApprovalConfigListResponseModel
    with ApprovalConfigListResponseModelMappable {
  const ApprovalConfigListResponseModel({this.data = const []});

  final List<ApprovalConfigModel> data;

  static const fromJson = ApprovalConfigListResponseModelMapper.fromJson;
}
