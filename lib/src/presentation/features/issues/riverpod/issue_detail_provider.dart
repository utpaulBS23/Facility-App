import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/issue_detail_entity.dart';

part 'issue_detail_provider.g.dart';

/// One issue by id, for the details page. A failure is thrown so the page can
/// show it with a retry.
@riverpod
Future<IssueDetailEntity> issueDetailById(Ref ref, int issueId) async {
  final result = await ref
      .read(getVisitIssueDetailUseCaseProvider)
      .call(issueId: issueId);

  return result.when(
    success: (data) => data!,
    error: (error) => throw error,
  );
}
