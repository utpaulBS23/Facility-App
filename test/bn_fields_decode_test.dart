import 'package:facility_management_app/src/data/extension/stock_item_mapper.dart';
import 'package:facility_management_app/src/data/models/master_data_model.dart';
import 'package:facility_management_app/src/data/models/shift_template_model.dart';
import 'package:facility_management_app/src/data/models/supply/stock_item_model.dart';
import 'package:facility_management_app/src/data/models/task_model.dart';
import 'package:facility_management_app/src/data/models/visit_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('task decodes title_bn / description_bn', () {
    final task = TaskModel.fromJson({
      'id': 1,
      'title': 'Leaking pipe',
      'title_bn': 'পাইপ লিক',
      'description': 'Stall 2',
      'description_bn': 'স্টল ২',
      'issue_status': 'open',
      'priority': 'high',
    }).toEntity();
    expect(task.localizedTitle('bn'), 'পাইপ লিক');
    expect(task.localizedTitle('en'), 'Leaking pipe');
    expect(task.localizedDescription('bn'), 'স্টল ২');
  });

  test('task without _bn falls back to English in bn', () {
    final task = TaskModel.fromJson({
      'id': 1,
      'title': 'Leaking pipe',
      'issue_status': 'open',
      'priority': 'high',
    }).toEntity();
    expect(task.localizedTitle('bn'), 'Leaking pipe');
  });

  test('stock item, shift template, master data decode _bn', () {
    final item = StockItemModel.fromJson({
      'id': 1,
      'item_code': 'A',
      'name': 'Hand Soap',
      'name_bn': 'হ্যান্ড সোপ',
      'category': 'c',
      'unit': 'u',
      'unit_price': 85.0,
      'is_active': true,
    }).toEntity();
    expect(item.localizedName('bn'), 'হ্যান্ড সোপ');

    final template = ShiftTemplateDataModel.fromJson({
      'id': 1,
      'name': 'Morning Shift',
      'name_bn': 'সকালের শিফট',
    });
    expect(template.nameBn, 'সকালের শিফট');

    final master = MasterDataItemModel.fromJson({
      'id': 1,
      'value': 'v',
      'label': 'Mop Handle',
      'label_bn': 'মপ হ্যান্ডেল',
    });
    expect(master.labelBn, 'মপ হ্যান্ডেল');
  });

  test('visit summary decodes title_bn', () {
    final visit = VisitSummaryModel.fromJson({
      'id': 1,
      'status': 'scheduled',
      'title': 'Morning Inspection',
      'title_bn': 'সকালের পরিদর্শন',
      'scheduled_date': '2026-10-05',
    }).toEntity();
    expect(visit.localizedTitle('bn'), 'সকালের পরিদর্শন');
  });
}
