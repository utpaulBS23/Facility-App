import 'facility_stock_averaging_overview_entity.dart';
import 'top_demand_item_entity.dart';

class StockAveragingPageEntity {
  const StockAveragingPageEntity({
    required this.facilities,
    required this.monthlyDemand,
  });

  final List<FacilityStockAveragingOverviewEntity> facilities;
  final List<TopDemandItemEntity> monthlyDemand;
}
