import 'package:facility_management_app/src/data/extension/leave_mapper.dart';
import 'package:facility_management_app/src/data/models/leave/leave_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('leave summary decodes the four card counts', () {
    final summary = LeaveSummaryResponseModel.fromJson({
      'success': true,
      'message': 'Leave summary retrieved successfully.',
      'summary': {
        'pending': 4,
        'manager_approval': 2,
        'approved': 17,
        'rejected': 3,
      },
    }).toEntity();

    expect(summary.pending, 4);
    expect(summary.managerApproval, 2);
    expect(summary.approved, 17);
    expect(summary.rejected, 3);
  });

  test('leave summary without a summary payload throws', () {
    expect(
      () => LeaveSummaryResponseModel.fromJson({'success': true}).toEntity(),
      throwsA(isA<FormatException>()),
    );
  });
}
