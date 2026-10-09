import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

/// Loads the home dashboard for the signed-in user's role.
final class GetDashboardUseCase {
  GetDashboardUseCase({required this.dashboardRepository});

  final DashboardRepository dashboardRepository;

  Future<Result<DashboardEntity, Failure>> call({String? month}) {
    return dashboardRepository.getDashboard(month: month);
  }
}
