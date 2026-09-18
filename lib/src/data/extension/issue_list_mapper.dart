import '../../domain/entities/issue_list_entity.dart';
import '../models/issue_list_model.dart';

extension IssueItemMapper on IssueItemModel {
  IssueEntity toEntity() {
    return IssueEntity(
      id: id,
      title: title,
      priority: priority,
      status: status,
      facilityName: facilityName,
      assignedToName: assignedToName,
      dueDate: dueAt != null ? DateTime.tryParse(dueAt!) : null,
      problemCategory: problemCategory,
      issueStatus: issueStatus,
      photoUrl: media?.isNotEmpty ?? false ? media!.first.url : null,
    );
  }
}

extension IssueListResponseMapper on IssueListResponseModel {
  List<IssueEntity> toEntity() {
    return data.map((item) => item.toEntity()).toList();
  }
}