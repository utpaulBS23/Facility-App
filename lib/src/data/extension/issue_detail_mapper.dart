import '../../domain/entities/issue_detail_entity.dart';
import '../models/issue_detail_model.dart';

extension IssueDetailMapper on IssueDetailModel {
  IssueDetailEntity toEntity() {
    final photoUrl = (data.media?.isNotEmpty ?? false) ? data.media!.first.url : null;
    return IssueDetailEntity(
      id: data.id,
      title: data.title,
      priority: data.priority,
      status: data.status,
      description: data.description,
      assignedTo: data.assignedTo,
      problemCategory: data.problemCategory,
      facilityName: data.facilityName,
      dueDate: data.dueAt != null ? DateTime.tryParse(data.dueAt!) : null,
      photoUrl: photoUrl,
    );
  }
}