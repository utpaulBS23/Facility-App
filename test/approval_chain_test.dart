import 'dart:convert';

import 'package:facility_management_app/src/data/extension/leave_mapper.dart';
import 'package:facility_management_app/src/data/extension/supply_request_mapper.dart';
import 'package:facility_management_app/src/data/models/leave/leave_models.dart';
import 'package:facility_management_app/src/data/models/supply/supply_request_model.dart';
import 'package:facility_management_app/src/domain/entities/app_permission.dart';
import 'package:facility_management_app/src/domain/entities/leave/leave_status.dart';
import 'package:flutter_test/flutter_test.dart';

String _leave({String extra = ''}) => '''
{"id":1,"reference_code":"REQ-001","start_date":"2026-10-10","end_date":"2026-10-11",
"days_count":2,"leave_type":"sick_leave","status":"pending_manager","created_at":"2026-10-07T00:00:00Z",
"applicant":{"id":13,"name":"Nadia Islam"}$extra}
''';

String _supply({String extra = ''}) => '''
{"id":14,"request_code":"SR-14","facility_id":1,"facility_name":"F","requested_by":2,
"requested_by_name":"A","initiated_by_role":"supervisor","status":"pending_operation_manager",
"item_count":0,"total_value":0,"created_at":"2026-10-07T00:00:00Z"$extra}
''';

void main() {
  group('permission strings', () {
    test('the step-numbered keys resolve', () {
      final set = UserPermission.setFromKeys([
        'leave.approve_step_1',
        'leave.approve_step_2',
        'leave.approve_step_3',
        'supply_request.approve_step_1',
        'supply_request.approve_step_2',
      ]);
      expect(set, {
        UserPermission.leaveApproveSupervisor,
        UserPermission.leaveApproveManager,
        UserPermission.leaveApproveOwner,
        UserPermission.supplyRequestApproveSupervisor,
        UserPermission.supplyRequestApproveOperationManager,
      });
    });

    test('the retired role-named keys no longer resolve', () {
      expect(
        UserPermission.setFromKeys([
          'leave.approve_supervisor',
          'leave.approve_manager',
          'leave.approve_owner',
          'supply_request.approve_supervisor',
          'supply_request.approve_operation_manager',
        ]),
        isEmpty,
      );
    });
  });

  group('leave request', () {
    test('reads the step fields', () {
      final r = LeaveRequestModel.fromJson(jsonDecode(_leave(
        extra: ',"current_step":2,"current_permission":"leave.approve_step_2",'
            '"current_step_label":"Waiting for Ops Manager approval","can_action":true',
      ))).toEntity();
      expect(r.currentStep, 2);
      expect(r.currentPermission, 'leave.approve_step_2');
      expect(r.currentStepLabel, 'Waiting for Ops Manager approval');
      expect(r.canAction, isTrue);
    });

    test('a terminal request has no step', () {
      final r = LeaveRequestModel.fromJson(jsonDecode(_leave(
        extra: ',"current_step":null,"current_permission":null,'
            '"current_step_label":null,"can_action":false',
      ))).toEntity();
      expect(r.currentStep, isNull);
      expect(r.currentStepLabel, isNull);
      expect(r.canAction, isFalse);
    });

    test('only the applicant can cancel, and only while pending', () {
      final r = LeaveRequestModel.fromJson(jsonDecode(_leave())).toEntity();
      expect(r.status, LeaveStatus.pendingManager);
      expect(r.canCancel(13), isTrue);
      expect(r.canCancel(99), isFalse);
      expect(r.canCancel(null), isFalse);

      final done = LeaveRequestModel.fromJson(jsonDecode(
        _leave().replaceFirst('pending_manager', 'approved'),
      )).toEntity();
      expect(done.canCancel(13), isFalse);
    });
  });

  group('supply request', () {
    test('reads the step fields', () {
      final r = SupplyRequestModel.fromJson(jsonDecode(_supply(
        extra: ',"current_step":1,"current_permission":"supply_request.approve_step_2",'
            '"current_step_label":"Waiting for Operation Manager approval","can_action":true',
      ))).toEntity();
      expect(r.currentStep, 1);
      expect(r.currentPermission, 'supply_request.approve_step_2');
      expect(r.currentStepLabel, 'Waiting for Operation Manager approval');
      expect(r.canAction, isTrue);
    });

    test('an older response without the fields reads as cannot-act', () {
      final r =
          SupplyRequestModel.fromJson(jsonDecode(_supply())).toEntity();
      expect(r.canAction, isFalse);
      expect(r.currentStep, isNull);
      expect(r.currentStepLabel, isNull);
    });
  });
}
