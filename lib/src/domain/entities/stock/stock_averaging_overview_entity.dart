import 'facility_stock_averaging_overview_entity.dart';
import 'top_demand_item_entity.dart';

class StockAveragingOverviewEntity {
  const StockAveragingOverviewEntity({
    required this.facilities,
    required this.topDemandItems,
  });

  final List<FacilityStockAveragingOverviewEntity> facilities;
  final List<TopDemandItemEntity> topDemandItems;
}
