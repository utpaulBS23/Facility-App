import 'package:facility_management_app/src/data/extension/supply_request_mapper.dart';
import 'package:facility_management_app/src/data/models/supply/delivery_model.dart';
import 'package:facility_management_app/src/domain/entities/supply/delivery_complaint_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> item(Map<String, dynamic> extra) => {
    'id': 23,
    'stock_item_id': 4,
    'item_code': 'ST-004',
    'item_name': 'Hand Wash',
    'item_name_bn': null,
    'unit': 'roll',
    'qty_expected': 4,
    'qty_received': 3,
    'is_verified': true,
    'has_shortage': true,
    ...extra,
  };

  test('maps the latest complaint of an item', () {
    final entity = DeliveryItemModel.fromJson(
      item({
        'has_complaint': true,
        'complaint_id': 5,
        'complaint_status': 'pending_supervisor',
      }),
    ).toEntity();

    expect(entity.hasComplaint, isTrue);
    expect(entity.complaintId, 5);
    expect(entity.complaintStatus, DeliveryComplaintStatus.pendingSupervisor);
  });

  test('an item without a complaint has none', () {
    final entity = DeliveryItemModel.fromJson(
      item({
        'has_complaint': false,
        'complaint_id': null,
        'complaint_status': null,
      }),
    ).toEntity();

    expect(entity.hasComplaint, isFalse);
    expect(entity.complaintId, isNull);
    expect(entity.complaintStatus, isNull);
  });

  test('older responses without the fields still parse', () {
    final entity = DeliveryItemModel.fromJson(item({})).toEntity();

    expect(entity.hasComplaint, isFalse);
    expect(entity.complaintStatus, isNull);
  });
}
