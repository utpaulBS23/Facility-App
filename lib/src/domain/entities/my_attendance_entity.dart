class MyAttendanceStatsEntity {
  const MyAttendanceStatsEntity({
    required this.records,
    required this.supervisors,
    required this.stillOnRound,
    required this.daysCovered,
  });

  final int records;
  final int supervisors;
  final int stillOnRound;
  final int daysCovered;
}

class MyAttendanceItemEntity {
  const MyAttendanceItemEntity({
    required this.userId,
    required this.supervisorName,
    required this.facilityId,
    required this.facilityName,
    required this.date,
    this.checkInAt,
    this.checkOutAt,
    required this.visitCount,
    this.hours,
  });

  final int userId;
  final String supervisorName;
  final int facilityId;
  final String facilityName;
  final String date;
  final DateTime? checkInAt;
  final DateTime? checkOutAt;
  final int visitCount;
  final double? hours;

  // WHY: a null check-out with a present check-in means the supervisor is
  // still on their round — mirrors `stats.still_on_round` for a single row.
  bool get isStillOnRound => checkInAt != null && checkOutAt == null;
}

class MyAttendanceOverviewEntity {
  const MyAttendanceOverviewEntity({required this.stats, required this.items});

  final MyAttendanceStatsEntity stats;
  final List<MyAttendanceItemEntity> items;
}
