/// What the toilet details page shows from `GET .../facilities/{id}`.
///
/// A text that is null (code, distance, air quality, cleaning) is one the
/// server does not measure yet, so the page shows "-" for it.
class ToiletDetailsEntity {
  const ToiletDetailsEntity({
    required this.id,
    this.code,
    this.distanceKm,
    this.visitsToday = 0,
    this.visitsThisWeek = 0,
    this.visitsThisMonth = 0,
    this.hourly = const [],
    this.peakHoursLabel,
    this.dailyTarget = 0,
    this.todayAchieved = 0,
    this.monthlyTarget = 0,
    this.monthAchieved = 0,
    this.progressTarget = 0,
    this.progressAchieved = 0,
    this.progressRemaining = 0,
    this.percentComplete = 0,
    this.daysLeft = 0,
    this.airQuality,
    this.cleaningFrequency,
    this.lastCleaningAt,
    this.supplyStock = const [],
    this.present = 0,
    this.late = 0,
    this.notCheckedIn = 0,
    this.staff = const [],
  });

  final int id;
  final String? code;
  final num? distanceKm;

  final int visitsToday;
  final int visitsThisWeek;
  final int visitsThisMonth;

  /// Always 24 buckets when the server sent them, in hour order.
  final List<ToiletHourlyVisit> hourly;
  final String? peakHoursLabel;

  final num dailyTarget;
  final num todayAchieved;
  final num monthlyTarget;
  final num monthAchieved;

  final num progressTarget;
  final num progressAchieved;
  final num progressRemaining;
  final num percentComplete;
  final int daysLeft;

  final String? airQuality;
  final String? cleaningFrequency;
  final String? lastCleaningAt;

  final List<ToiletSupplyItem> supplyStock;

  final int present;
  final int late;
  final int notCheckedIn;
  final List<ToiletStaffMember> staff;

  /// No target set, so there is nothing to compare against.
  bool get hasProgressTarget => progressTarget > 0;
}

class ToiletHourlyVisit {
  const ToiletHourlyVisit({
    required this.hour,
    required this.count,
    required this.isPeak,
  });

  final int hour;
  final int count;
  final bool isPeak;
}

enum ToiletSupplyLevel {
  ok,
  low,
  out;

  static ToiletSupplyLevel fromWire(String? value) => switch (value) {
    'low' => low,
    'out' => out,
    _ => ok,
  };
}

class ToiletSupplyItem {
  const ToiletSupplyItem({
    required this.name,
    required this.level,
    this.unit = '',
    this.quantity,
  });

  final String name;
  final ToiletSupplyLevel level;

  /// e.g. `roll`, `bottle`.
  final String unit;
  final num? quantity;
}

enum ToiletStaffStatus {
  present,
  late,
  notCheckedIn;

  static ToiletStaffStatus fromWire(String? value) => switch (value) {
    'present' => present,
    'late' => late,
    _ => notCheckedIn,
  };
}

class ToiletStaffMember {
  const ToiletStaffMember({
    required this.name,
    required this.phone,
    required this.role,
    required this.status,
    this.checkInTime,
  });

  final String name;
  final String phone;
  final String role;
  final ToiletStaffStatus status;

  /// As sent; null when the person has not checked in.
  final String? checkInTime;
}
