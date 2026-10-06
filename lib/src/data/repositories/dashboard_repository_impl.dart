import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../extension/dashboard_mapper.dart';
import '../models/dashboard/dashboard_model.dart';
import '../services/network/rest_client.dart';

final class DashboardRepositoryImpl extends DashboardRepository {
  DashboardRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<DashboardEntity, Failure>> getDashboard({String? month}) {
    return asyncGuard(() async {
      final response = await remote.getDashboard(month: month);
      return DashboardResponseModel.fromJson(response.data).toEntity();
    });
  }
}
