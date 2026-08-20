import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';

/// Navigation payload for `Routes.confirmDelivery`.
///
/// WHY: [DeliveryEntity] carries no urgency or requester-name field, so both
/// are threaded through separately from the originating supply request.
class ConfirmDeliveryPageArgs {
  const ConfirmDeliveryPageArgs({
    required this.delivery,
    required this.urgency,
    required this.requestedByName,
  });

  final DeliveryEntity delivery;
  final SupplyUrgency urgency;
  final String requestedByName;
}
