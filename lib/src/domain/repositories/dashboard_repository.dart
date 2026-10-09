import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/dashboard_entity.dart';

abstract base class DashboardRepository extends Repository {
  /// The home dashboard for the signed-in user. The server picks the shape
  /// from the token's role; a role without a dashboard (e.g. attendant) is a
  /// 404 failure.
  ///
  /// [month] (`YYYY-MM`) moves the sections that have a month picker; the
  /// server ignores it for the partner owner and defaults to this month.
  Future<Result<DashboardEntity, Failure>> getDashboard({String? month});
}
