import 'create_supply_request_item_entity.dart';

class ApproveSupplyRequestEntity {
  const ApproveSupplyRequestEntity({
    required this.supplyRequestId,
    this.notes,
    this.items,
  });

  final int supplyRequestId;
  final String? notes;
  final List<CreateSupplyRequestItemEntity>? items;
}
