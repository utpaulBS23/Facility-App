import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/user_tracking_entity.dart';
import '../../../core/theme/theme.dart';

/// Which users the Tracking screen lists.
enum UserStatusFilter { all, online, offline }

extension UserPositionStyle on UserPositionEntity {
  Color statusColor(BuildContext context) =>
      online ? context.color.success : context.color.text.muted;

  String statusLabel(BuildContext context) =>
      online ? context.locale.statusOnline : context.locale.offline;

  String facilityLabel(BuildContext context) =>
      facilityName.isEmpty ? context.locale.unassigned : facilityName;

  String activityLabel(BuildContext context) => switch (activity) {
    UserActivity.idle => context.locale.activityIdle,
    UserActivity.onShift => context.locale.activityOnShift,
    UserActivity.onSite => context.locale.activityOnSite,
    UserActivity.visitCompleted => context.locale.activityVisitCompleted,
    UserActivity.traveling => context.locale.activityTraveling,
    UserActivity.unknown => activityText,
  };

  String geofenceLabel(BuildContext context) => switch (withinGeofence) {
    true => context.locale.geofenceInside,
    false => context.locale.geofenceOutside,
    null => context.locale.geofenceNotApplicable,
  };

  Color? geofenceColor(BuildContext context) => switch (withinGeofence) {
    true => context.color.success,
    _ => null,
  };

  /// "±12 m", or null when the server sent no accuracy.
  String? accuracyText(BuildContext context) {
    final meters = accuracyMeters;
    if (meters == null) return null;
    return context.locale.metersValue(
      '±${context.numbers.integer(meters.round())}',
    );
  }

  /// "77%", or null when the device did not report a battery level.
  String? batteryText(BuildContext context) {
    final level = batteryLevel;
    if (level == null) return null;
    return context.numbers.percent(level);
  }

  /// Low battery is drawn in the error colour.
  bool get isBatteryLow => (batteryLevel ?? 100) <= 20;
}

/// Up to two initials from a name, for the marker and the avatar.
String userInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  if (parts.isEmpty) return '?';
  final first = parts.first.characters.first;
  if (parts.length == 1) return first.toUpperCase();
  return (first + parts.last.characters.first).toUpperCase();
}
