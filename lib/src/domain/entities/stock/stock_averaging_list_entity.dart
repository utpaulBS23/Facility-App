import 'facility_stock_target_entity.dart';
import 'top_demand_item_entity.dart';

/// One page of stock-averaging target rows, exactly as the API returns them
/// — flat (facility, item) rows, never grouped by facility server-side.
class StockAveragingListEntity {
  const StockAveragingListEntity({
    required this.targets,
    required this.topDemandItems,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final List<FacilityStockTargetEntity> targets;

  /// Top 4 items by total demand across the full scope — unaffected by any
  /// `facility_id` filter on this same request.
  final List<TopDemandItemEntity> topDemandItems;
  final int currentPage;
  final int lastPage;
  final int total;
}
