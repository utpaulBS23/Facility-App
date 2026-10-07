import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facility_management_app/src/core/base/result.dart';
import 'package:facility_management_app/src/data/repositories/visit_repository_impl.dart';
import 'package:facility_management_app/src/data/services/network/rest_client.dart';
import 'package:facility_management_app/src/domain/entities/report_issue_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retrofit/retrofit.dart';

/// Records which of the two issue update calls was made.
class _FakeClient implements RestClient {
  String? call;
  Map<String, dynamic>? jsonBody;
  FormData? formBody;

  HttpResponse _ok() => HttpResponse(
    {
      'data': {'id': 237, 'title': 'T', 'priority': 'medium', 'status': 'open'},
    },
    Response(requestOptions: RequestOptions(), statusCode: 200),
  );

  @override
  Future<HttpResponse> updateIssue({
    required int partnerId,
    required int issueId,
    required Map<String, dynamic> body,
  }) async {
    call = 'PATCH $partnerId/$issueId';
    jsonBody = body;
    return _ok();
  }

  @override
  Future<HttpResponse> updateIssueWithPhoto({
    required int partnerId,
    required int issueId,
    required FormData formData,
  }) async {
    call = 'POST $partnerId/$issueId';
    formBody = formData;
    return _ok();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ReportIssueRequestEntity _request({String? photoPath, int? assignedTo}) =>
    ReportIssueRequestEntity(
      visitId: 9,
      categoryValue: 'safety_hazard',
      title: '01 gju',
      priority: 'medium',
      description: 'hello',
      assignedTo: assignedTo,
      dueAt: '2026-10-09 23:59:59',
      photoPath: photoPath,
    );

void main() {
  test('no new photo: a JSON PATCH on the issue, not a new report', () async {
    final client = _FakeClient();
    final result = await VisitRepositoryImpl(
      client,
    ).updateIssue(partnerId: 6, issueId: 237, request: _request());

    expect(result, isA<Success>());
    expect(client.call, 'PATCH 6/237');
    expect(client.jsonBody, {
      'problem_category': 'safety_hazard',
      'title': '01 gju',
      'priority': 'medium',
      'description': 'hello',
      'due_at': '2026-10-09 23:59:59',
    });
  });

  test('an assignee is sent only when one is picked', () async {
    final client = _FakeClient();
    await VisitRepositoryImpl(client).updateIssue(
      partnerId: 6,
      issueId: 237,
      request: _request(assignedTo: 137),
    );

    expect(client.jsonBody!['assigned_to'], 137);
  });

  test('a new photo: multipart POST with _method PATCH', () async {
    final photo = File('${Directory.systemTemp.path}/issue_edit_photo.png')
      ..writeAsBytesSync([1, 2, 3]);
    addTearDown(photo.deleteSync);

    final client = _FakeClient();
    final result = await VisitRepositoryImpl(client).updateIssue(
      partnerId: 6,
      issueId: 237,
      request: _request(photoPath: photo.path),
    );

    expect(result, isA<Success>());
    expect(client.call, 'POST 6/237');
    final fields = {for (final f in client.formBody!.fields) f.key: f.value};
    expect(fields['_method'], 'PATCH');
    expect(fields['title'], '01 gju');
    expect(fields['alt'], '01 gju');
    expect(client.formBody!.files.single.key, 'photo');
  });
}
