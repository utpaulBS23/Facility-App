import 'package:facility_management_app/src/data/extension/auth_mapper.dart';
import 'package:facility_management_app/src/data/extension/issue_list_mapper.dart';
import 'package:facility_management_app/src/data/models/additional_income/named_ref_model.dart';
import 'package:facility_management_app/src/data/models/issue_list_model.dart';
import 'package:facility_management_app/src/data/models/login_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('issue decodes facility_name_bn / assigned_to_name_bn', () {
    final issue = IssueItemModel.fromJson({
      'id': 1,
      'title': 'Leak',
      'priority': 'high',
      'status': 'open',
      'facility_name': 'Dhanmondi Branch',
      'facility_name_bn': 'ধানমন্ডি শাখা',
      'assigned_to_name': 'Nadia Islam',
      'assigned_to_name_bn': 'নাদিয়া ইসলাম',
    }).toEntity();

    expect(issue.localizedFacilityName('bn'), 'ধানমন্ডি শাখা');
    expect(issue.localizedFacilityName('en'), 'Dhanmondi Branch');
    expect(issue.localizedAssignedToName('bn'), 'নাদিয়া ইসলাম');
  });

  test('missing _bn falls back to English in bn', () {
    final issue = IssueItemModel.fromJson({
      'id': 1,
      'title': 'Leak',
      'priority': 'high',
      'status': 'open',
      'facility_name': 'Dhanmondi Branch',
    }).toEntity();

    expect(issue.localizedFacilityName('bn'), 'Dhanmondi Branch');
  });

  test('accessible facility decodes name_bn', () {
    final facility = AccessibleFacilityModel.fromJson({
      'id': 44,
      'name': 'Dhanmondi Branch',
      'name_bn': 'ধানমন্ডি শাখা',
      'is_primary': true,
    }).toEntity();

    expect(facility.localizedName('bn'), 'ধানমন্ডি শাখা');
    expect(facility.localizedName('en'), 'Dhanmondi Branch');
  });

  test('nested ref decodes name_bn', () {
    final ref = NamedRefModel.fromJson({
      'id': 1,
      'name': 'Dhanmondi Branch',
      'name_bn': 'ধানমন্ডি শাখা',
    });

    expect(ref.nameBn, 'ধানমন্ডি শাখা');
  });
}
