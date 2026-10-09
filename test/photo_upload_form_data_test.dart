import 'dart:io';

import 'package:facility_management_app/src/data/extension/stock_count_mapper.dart';
import 'package:facility_management_app/src/data/extension/supply_request_mapper.dart';
import 'package:facility_management_app/src/domain/entities/stock/shift_stock_count_entity.dart';
import 'package:facility_management_app/src/domain/entities/supply/supply_request_payloads.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  late String photoPath;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('photo_form_data');
    photoPath = '${dir.path}/photo.jpg';
    File(photoPath).writeAsBytesSync([1, 2, 3]);
  });

  tearDown(() => dir.deleteSync(recursive: true));

  Map<String, String> fields(dynamic formData) => {
    for (final e in formData.fields) e.key: e.value,
  };

  List<String> fileKeys(dynamic formData) => [
    for (final e in formData.files) e.key as String,
  ];

  group('confirm delivery', () {
    ConfirmDeliveryRequestEntity request({String? photo}) =>
        ConfirmDeliveryRequestEntity(
          deliveryId: 5,
          items: const [
            ConfirmDeliveryItem(
              stockItemId: 5,
              qtyReceived: 9,
              isVerified: true,
            ),
            ConfirmDeliveryItem(
              stockItemId: 6,
              qtyReceived: 2,
              isVerified: false,
            ),
          ],
          receiptPhotoPath: photo,
          deliveryNotes: 'short by 1',
        );

    test('sends is_verified as 1/0 and item fields indexed', () async {
      final form = await request().toFormData();
      final f = fields(form);
      expect(f['items[0][stock_item_id]'], '5');
      expect(f['items[0][qty_received]'], '9.0');
      expect(f['items[0][is_verified]'], '1');
      expect(f['items[1][is_verified]'], '0');
      expect(f['delivery_notes'], 'short by 1');
    });

    test('omits the photo when none was picked', () async {
      expect(fileKeys(await request().toFormData()), isEmpty);
    });

    test('sends the picked photo as receipt_photo', () async {
      final form = await request(photo: photoPath).toFormData();
      expect(fileKeys(form), ['receipt_photo']);
    });
  });

  group('delivery complaint', () {
    FileDeliveryComplaintRequestEntity request({String? photo}) =>
        FileDeliveryComplaintRequestEntity(
          deliveryId: 5,
          deliveryItemId: 7,
          reportedQtyReceived: 8,
          reason: 'short',
          evidencePhotoPath: photo,
        );

    test('sends text fields and no photo when none was picked', () async {
      final form = await request().toFormData();
      final f = fields(form);
      expect(f['delivery_item_id'], '7');
      expect(f['reason'], 'short');
      expect(fileKeys(form), isEmpty);
    });

    test('sends the picked photo as evidence_photo', () async {
      final form = await request(photo: photoPath).toFormData();
      expect(fileKeys(form), ['evidence_photo']);
    });
  });

  group('shift stock count', () {
    test('sends a photo only on the lines that have one', () async {
      final form = await [
        const SubmitStockCountItemEntity(stockItemId: 5, qtyOnHand: 20),
        SubmitStockCountItemEntity(
          stockItemId: 6,
          qtyOnHand: 3,
          photoPath: photoPath,
        ),
      ].toFormData();
      final f = fields(form);
      expect(f['items[0][stock_item_id]'], '5');
      expect(f['items[1][qty_on_hand]'], '3.0');
      expect(fileKeys(form), ['items[1][photo]']);
    });
  });
}
