import 'facility_stock_target_entity.dart';
import 'top_demand_item_entity.dart';

class StockAveragingPageEntity {
  const StockAveragingPageEntity({
    required this.items,
    required this.topDemandItems,
  });

  final List<FacilityStockTargetEntity> items;
  final List<TopDemandItemEntity> topDemandItems;
}
