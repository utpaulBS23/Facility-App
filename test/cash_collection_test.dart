import 'dart:io';

import 'package:facility_management_app/src/data/extension/cash_collection_mapper.dart';
import 'package:facility_management_app/src/data/models/cash_collection/cash_collection_model.dart';
import 'package:facility_management_app/src/domain/entities/cash_collection/cash_collection_payloads.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  late String photoPath;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('cash_collection');
    photoPath = '${dir.path}/count.jpg';
    File(photoPath).writeAsBytesSync([1, 2, 3]);
  });

  tearDown(() => dir.deleteSync(recursive: true));

  group('create request form data', () {
    CreateCashCollectionRequestEntity request({String? note}) =>
        CreateCashCollectionRequestEntity(
          facilityId: 41,
          collectionDate: DateTime(2026, 10, 9),
          productSellingAmount: 100,
          rentingOthersAmount: 50,
          note: note,
          photoPath: photoPath,
          lines: const [
            CashCollectionLineEntity(
              facilityServiceId: 366,
              gender: 'male',
              quantity: 10,
            ),
            CashCollectionLineEntity(
              facilityServiceId: 367,
              gender: 'female',
              quantity: 0,
            ),
          ],
        );

    test(
      'sends bracket-notation items, zero quantities and no unit price',
      () async {
        final formData = await request().toFormData();
        final fields = {for (final e in formData.fields) e.key: e.value};

        expect(fields['facility_id'], '41');
        expect(fields['collection_date'], '2026-10-09');
        expect(fields['items[0][facility_service_id]'], '366');
        expect(fields['items[0][gender]'], 'male');
        expect(fields['items[0][quantity]'], '10');
        expect(fields['items[1][quantity]'], '0');
        expect(fields.keys.where((k) => k.contains('unit_price')), isEmpty);
      },
    );

    test('sends the evidence photo as a file under photo_url', () async {
      final formData = await request().toFormData();

      expect([for (final e in formData.files) e.key], ['photo_url']);
    });

    test('omits a blank note and keeps a real one', () async {
      final blank = await request(note: '  ').toFormData();
      final real = await request(note: 'counted twice').toFormData();

      expect(blank.fields.any((e) => e.key == 'note'), isFalse);
      expect(
        real.fields.firstWhere((e) => e.key == 'note').value,
        'counted twice',
      );
    });
  });

  group('response parsing', () {
    test('maps a list response with its summary', () {
      final model = CashCollectionListResponseModel.fromJson({
        'data': [
          {
            'id': 1,
            'facility': {'id': 41, 'name': 'Banani'},
            'collection_date': '2026-07-30',
            'product_selling_amount': 100,
            'renting_others_amount': 50,
            'line_items_total': 150,
            'total_cash_amount': 300,
            'items': [
              {
                'id': 1,
                'facility_service': {
                  'id': 366,
                  'service_id': 1,
                  'service_name': 'Shower',
                  'section': 'Ground Floor',
                },
                'gender': 'male',
                'quantity': 10,
                'unit_price': 10,
                'amount': 100,
              },
            ],
            'photo_url': 'https://example.test/p.jpg',
            'submitted_by': {'id': 72, 'name': 'Utpaul'},
          },
        ],
        'meta': {'current_page': 1, 'last_page': 1, 'per_page': 20, 'total': 1},
        'summary': {'entries_count': 1, 'manual_total': 300},
      });

      final result = model.toEntity();

      expect(result.summary.entriesCount, 1);
      expect(result.summary.manualTotal, 300);
      final entry = result.list.items.single;
      expect(entry.totalCashAmount, 300);
      expect(entry.items.single.serviceName, 'Shower');
      expect(entry.items.single.amount, 100);
      expect(entry.submittedByName, 'Utpaul');
    });

    test('maps a facility service row with its Bangla title', () {
      final entity = FacilityServiceModel.fromJson({
        'id': 366,
        'service': {'id': 1, 'title_en': 'Shower', 'title_bn': 'শাওয়ার'},
        'gender': 'male',
        'price': 10,
      }).toEntity();

      expect(entity.id, 366);
      expect(entity.localizedServiceName('bn'), 'শাওয়ার');
      expect(entity.localizedServiceName('en'), 'Shower');
      expect(entity.price, 10);
    });
  });
}
