import '../../core/utils/localized_text.dart';

/// One supervisor's day: the visits behind a supervisor-attendance row.
class SupervisorAttendanceDetailEntity {
  const SupervisorAttendanceDetailEntity({
    required this.userId,
    required this.supervisorName,
    this.supervisorNameBn = '',
    required this.date,
    this.checkInAt,
    this.checkOutAt,
    this.minutes,
    required this.visitCount,
    required this.facilitiesCount,
    required this.stillOnRound,
    required this.visits,
  });

  final int userId;
  final String supervisorName;
  final String supervisorNameBn;
  final String date;
  final DateTime? checkInAt;
  final DateTime? checkOutAt;
  final int? minutes;
  final int visitCount;
  final int facilitiesCount;
  final bool stillOnRound;
  final List<SupervisorVisitEntity> visits;

  String localizedSupervisorName(String languageCode) =>
      localizedText(languageCode, supervisorName, supervisorNameBn);
}

class SupervisorVisitEntity {
  const SupervisorVisitEntity({
    this.taskId,
    this.visitId,
    required this.title,
    this.titleBn = '',
    this.status,
    this.visitType,
    this.facilityId,
    required this.facilityName,
    this.facilityNameBn = '',
    this.locationType,
    this.officeName,
    this.officeNameBn = '',
    this.address,
    this.scheduledStart,
    this.scheduledEnd,
    this.checkInAt,
    this.checkInDistanceMeters,
    this.locationVerified,
    this.checkOutAt,
    this.minutes,
    this.itemsTotal,
    this.itemsCompleted,
    this.totalScore,
    this.maxScore,
    this.scorePercentage,
    this.passMark,
    this.supervisorNotes,
  });

  final int? taskId;
  final int? visitId;
  final String title;
  final String titleBn;
  final String? status;
  final String? visitType;
  final int? facilityId;
  final String facilityName;
  final String facilityNameBn;
  final String? locationType;
  final String? officeName;
  final String officeNameBn;
  final String? address;
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;
  final DateTime? checkInAt;
  final num? checkInDistanceMeters;
  final bool? locationVerified;
  final DateTime? checkOutAt;
  final int? minutes;
  final int? itemsTotal;
  final int? itemsCompleted;
  final num? totalScore;
  final num? maxScore;
  final num? scorePercentage;
  final num? passMark;
  final String? supervisorNotes;

  bool get isExternal => locationType == 'external';

  // WHY: a check-in without a check-out is a visit still in progress.
  bool get isInProgress => checkInAt != null && checkOutAt == null;

  /// Null without a checklist template, so no pass/fail can be shown.
  bool? get hasPassed {
    final percentage = scorePercentage;
    final mark = passMark;
    if (percentage == null || mark == null) return null;
    return percentage >= mark;
  }

  String localizedTitle(String languageCode) =>
      localizedText(languageCode, title, titleBn);

  /// The place the visit happened: an office for an external visit,
  /// otherwise the facility.
  String localizedPlace(String languageCode) {
    if (isExternal) {
      return localizedTextOrNull(languageCode, officeName, officeNameBn) ??
          localizedText(languageCode, facilityName, facilityNameBn);
    }
    return localizedText(languageCode, facilityName, facilityNameBn);
  }
}
