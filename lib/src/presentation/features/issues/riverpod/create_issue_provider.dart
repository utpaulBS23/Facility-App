import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/checklist_entity.dart';
import '../../../../domain/entities/problem_category_entity.dart';
import '../../../../domain/entities/report_issue_entity.dart';

part 'create_issue_provider.g.dart';

class CreateIssueState {
  const CreateIssueState({
    this.isSubmitting = false,
    this.createdIssue,
    this.error,
  });

  final bool isSubmitting;
  final ChecklistIssueEntity? createdIssue;
  final Failure? error;

  bool get submitSuccess => createdIssue != null;

  CreateIssueState copyWith({
    bool? isSubmitting,
    ChecklistIssueEntity? createdIssue,
    Failure? error,
    bool clearError = false,
  }) => CreateIssueState(
    isSubmitting: isSubmitting ?? this.isSubmitting,
    createdIssue: createdIssue ?? this.createdIssue,
    error: clearError ? null : error ?? this.error,
  );
}

@riverpod
class CreateIssue extends _$CreateIssue {
  @override
  CreateIssueState build() => const CreateIssueState();

  Future<void> submit({
    required ReportIssueRequestEntity request,
    required String categoryName,
    required String facilityName,
  }) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    final result = await ref
        .read(reportIssueUseCaseProvider)
        .call(partnerId: partnerId, visitId: request.visitId, request: request);

    state = result.when(
      success: (response) => state.copyWith(
        isSubmitting: false,
        createdIssue: response == null
            ? null
            : ChecklistIssueEntity(
                id: response.id,
                title: response.title,
                category: categoryName,
                location: facilityName,
                priority: response.priority,
                status: response.status,
              ),
      ),
      error: (err) => state.copyWith(isSubmitting: false, error: err),
    );
  }

  int get partnerId {
    final user = ref.read(getCurrentUserUseCaseProvider).call();
    return user?.partnerId ?? 0;
  }
}

// WHY: AutoDispose + family so categories are fetched once per partner and
// discarded when the page is popped, avoiding stale cache.
@riverpod
Future<List<ProblemCategoryEntity>> problemCategories(
  Ref ref,
  int partnerId,
) async {
  final result = await ref
      .read(getProblemCategoriesUseCaseProvider)
      .call(partnerId: partnerId);
  return switch (result) {
    Success(:final data) => data ?? [],
    Error() => [],
    _ => [],
  };
}

@riverpod
Future<List<PartnerStaffEntity>> issueAttendants(
  Ref ref,
  int facilityId,
) async {
  final result = await ref
      .read(getPartnerStaffUseCaseProvider)
      .call(facilityId: facilityId);
  return switch (result) {
    Success(:final data) => data ?? [],
    Error() => [],
    _ => [],
  };
}
