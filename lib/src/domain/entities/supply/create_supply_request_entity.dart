import 'create_supply_request_item_entity.dart';
import 'supply_request_status.dart';

/// Write request payload for `POST /supply-requests`.
class CreateSupplyRequestEntity {
  const CreateSupplyRequestEntity({
    required this.facilityId,
    this.urgency,
    this.notes,
    required this.items,
  });

  final int facilityId;
  final SupplyUrgency? urgency;
  final String? notes;
  final List<CreateSupplyRequestItemEntity> items;
}
