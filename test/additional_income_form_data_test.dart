import 'dart:io';

import 'package:facility_management_app/src/data/extension/additional_income_mapper.dart';
import 'package:facility_management_app/src/domain/entities/additional_income/additional_income_payloads.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  late String photoPath;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('income_form_data');
    photoPath = '${dir.path}/proof.jpg';
    File(photoPath).writeAsBytesSync([1, 2, 3]);
  });

  tearDown(() => dir.deleteSync(recursive: true));

  CreateAdditionalIncomeRequestEntity request({
    String? photo,
    String? description,
  }) => CreateAdditionalIncomeRequestEntity(
    facilityId: 41,
    incomeType: 'locker',
    amount: 150,
    description: description,
    evidencePhotoPath: photo,
  );

  test('sends the fields as plain form values', () async {
    final formData = await request(description: 'two lockers').toFormData();
    final fields = {for (final e in formData.fields) e.key: e.value};

    expect(fields['facility_id'], '41');
    expect(fields['income_type'], 'locker');
    expect(fields['amount'], '150.0');
    expect(fields['description'], 'two lockers');
  });

  test('sends the photo as a file under evidence_photo_url', () async {
    final formData = await request(photo: photoPath).toFormData();

    expect([for (final e in formData.files) e.key], ['evidence_photo_url']);
  });

  test('leaves the photo and a blank description out', () async {
    final formData = await request(description: '').toFormData();

    expect(formData.files, isEmpty);
    expect(formData.fields.any((e) => e.key == 'description'), isFalse);
  });
}
