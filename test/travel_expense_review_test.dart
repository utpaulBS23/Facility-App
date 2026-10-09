import 'package:facility_management_app/src/data/extension/travel_expense_mapper.dart';
import 'package:facility_management_app/src/data/models/travel_expense_model.dart';
import 'package:facility_management_app/src/domain/entities/app_permission.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the review permission matches the backend key', () {
    expect(UserPermission.travelExpenseReview.key, 'travel_expense.review');
  });

  test('a claim carries who filed it', () {
    final entity = TravelExpenseModel.fromJson({
      'id': 9,
      'user_id': 72,
      'status': 'waiting',
    }).toEntity();

    expect(entity.userId, 72);
  });

  test('a claim without user_id has no filer', () {
    final entity = TravelExpenseModel.fromJson({'id': 9}).toEntity();

    expect(entity.userId, isNull);
  });
}
