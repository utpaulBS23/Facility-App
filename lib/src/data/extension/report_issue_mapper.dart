import '../../domain/entities/report_issue_entity.dart';
import '../models/report_issue_model.dart';

String _priorityToString(IssuePriority priority) => switch (priority) {
      IssuePriority.high => 'high',
      IssuePriority.medium => 'medium',
      IssuePriority.normal => 'normal',
      IssuePriority.low => 'low',
    };

extension ReportIssueRequestEntityToJson on ReportIssueRequestEntity {
  Map<String, dynamic> toJson() => {
        'visit_id': visitId,
        'department': department,
        'specific_problem': specificProblem,
        'location': location,
        'priority': _priorityToString(priority),
        if (notes != null) 'notes': notes,
        if (photoPath != null) 'photo_path': photoPath,
        if (assignedTo != null) 'assigned_to': assignedTo,
      };
}

extension ReportIssueResponseModelToEntity on ReportIssueResponseModel {
  ReportIssueResponseEntity toEntity() => ReportIssueResponseEntity(
        id: id,
        message: message ?? 'Issue reported successfully',
      );
}
