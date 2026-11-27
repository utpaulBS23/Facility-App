import '../../core/utils/localized_text.dart';

class MyAttendanceStatsEntity {
  const MyAttendanceStatsEntity({
    required this.records,
    required this.supervisors,
    required this.stillOnRound,
    required this.daysCovered,
    this.facilities = 0,
  });

  final int records;
  final int supervisors;
  final int stillOnRound;
  final int daysCovered;
  final int facilities;
}

class MyAttendanceItemEntity {
  const MyAttendanceItemEntity({
    required this.userId,
    required this.supervisorName,
    this.supervisorNameBn = '',
    this.facilityId,
    required this.facilityName,
    this.facilityNameBn = '',
    this.officeId,
    this.officeName,
    this.officeNameBn = '',
    this.locationType,
    required this.date,
    this.checkInAt,
    this.checkOutAt,
    required this.visitCount,
    this.minutes,
  });

  final int userId;
  final String supervisorName;
  final String supervisorNameBn;
  final int? facilityId;
  final String facilityName;
  final String facilityNameBn;
  final int? officeId;
  final String? officeName;
  final String officeNameBn;
  final String? locationType;
  final String date;
  final DateTime? checkInAt;
  final DateTime? checkOutAt;
  final int visitCount;
  final int? minutes;

  // WHY: a null check-out with a present check-in means the supervisor is
  // still on their round — mirrors `stats.still_on_round` for a single row.
  bool get isStillOnRound => checkInAt != null && checkOutAt == null;

  String localizedSupervisorName(String languageCode) =>
      localizedText(languageCode, supervisorName, supervisorNameBn);

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);

  String? localizedOfficeName(String languageCode) =>
      localizedTextOrNull(languageCode, officeName, officeNameBn);
}

class MyAttendanceOverviewEntity {
  const MyAttendanceOverviewEntity({
    required this.stats,
    required this.items,
    this.page = 1,
    this.lastPage = 1,
  });

  final MyAttendanceStatsEntity stats;
  final List<MyAttendanceItemEntity> items;
  final int page;
  final int lastPage;

  bool get hasMore => page < lastPage;

  /// Merges the next page's rows onto this one. The stats stay the first
  /// page's: the server computes them over the whole filter, not per page.
  MyAttendanceOverviewEntity appended(MyAttendanceOverviewEntity next) {
    return MyAttendanceOverviewEntity(
      stats: stats,
      items: [...items, ...next.items],
      page: next.page,
      lastPage: next.lastPage,
    );
  }
}
