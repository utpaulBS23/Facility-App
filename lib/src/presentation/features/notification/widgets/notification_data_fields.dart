import 'package:flutter/widgets.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/gen/l10n/app_localizations.dart';
import '../../../core/utils/date_formatter.dart';

enum _Kind { text, raw, number, money, date, dateTime }

typedef _Spec = (String Function(AppLocalizations) label, _Kind kind);

/// One labelled line in the details sheet.
typedef NotificationField = ({String label, String value});

/// The `data` keys worth showing, with a label and how to format each.
///
/// WHY an allow-list: ids (`issue_id`, `shift_slot_id`, ...) mean nothing to
/// the reader, and a source the app has never seen must not dump raw keys.
final Map<String, _Spec> _specs = {
  'shift_date': ((l) => l.notifFieldShiftDate, _Kind.date),
  'required_count': ((l) => l.notifFieldRequired, _Kind.number),
  'filled_count': ((l) => l.notifFieldAssigned, _Kind.number),
  'shift_start_time': ((l) => l.notifFieldShiftStart, _Kind.raw),
  'grace_minutes': ((l) => l.notifFieldGraceMinutes, _Kind.number),
  'issue_type': ((l) => l.notifFieldIssueType, _Kind.text),
  'reported_at': ((l) => l.notifFieldReportedAt, _Kind.dateTime),
  'sensor_type': ((l) => l.notifFieldSensor, _Kind.text),
  'reading_value': ((l) => l.notifFieldReading, _Kind.number),
  'threshold_value': ((l) => l.notifFieldThreshold, _Kind.number),
  'breach_started_at': ((l) => l.notifFieldBreachStarted, _Kind.dateTime),
  'business_date': ((l) => l.notifFieldBusinessDate, _Kind.date),
  'expected_amount': ((l) => l.notifFieldExpected, _Kind.money),
  'actual_amount': ((l) => l.notifFieldActual, _Kind.money),
  'variance_amount': ((l) => l.notifFieldVariance, _Kind.money),
  'tolerance_threshold': ((l) => l.notifFieldTolerance, _Kind.number),
  'request_type': ((l) => l.notifFieldRequestType, _Kind.text),
  'pending_hours': ((l) => l.notifFieldPendingHours, _Kind.number),
  'attendance_type': ((l) => l.notifFieldAttendanceType, _Kind.text),
  'recorded_at': ((l) => l.notifFieldRecordedAt, _Kind.dateTime),
  'reason': ((l) => l.notifFieldReason, _Kind.raw),
  'month': ((l) => l.notifFieldMonth, _Kind.raw),
  'close_date': ((l) => l.notifFieldCloseDate, _Kind.date),
  'days_remaining': ((l) => l.notifFieldDaysLeft, _Kind.number),
  'last_seen_at': ((l) => l.notifFieldLastSeen, _Kind.dateTime),
  'offline_since': ((l) => l.notifFieldOfflineSince, _Kind.dateTime),
  'offline_minutes': ((l) => l.notifFieldOfflineMinutes, _Kind.number),
};

/// The wording for a value the API reference lists (`attendance_type` and
/// `request_type`), or null for any other.
String? _knownValue(AppLocalizations locale, String value) => switch (value) {
  'check_in' => locale.notifValueCheckIn,
  'check_out' => locale.notifValueCheckOut,
  'leave' => locale.notifValueLeave,
  'supply' => locale.notifValueSupply,
  _ => null,
};

/// `hydrogen_sulfide` -> `Hydrogen sulfide`. English only, for a value the
/// app has no wording for.
String _humanize(String value) {
  final spaced = value.replaceAll('_', ' ').trim();
  if (spaced.isEmpty) return spaced;

  return spaced[0].toUpperCase() + spaced.substring(1);
}

/// The labelled lines for a notification's [data], in the order the server
/// sent them. Null and unknown keys are left out.
List<NotificationField> notificationFields(
  BuildContext context,
  Map<String, dynamic> data,
) {
  final locale = context.locale;
  final numbers = context.numbers;
  final fields = <NotificationField>[];

  for (final MapEntry(:key, :value) in data.entries) {
    final spec = _specs[key];
    if (spec == null || value == null || value.toString().isEmpty) continue;

    final (label, kind) = spec;
    final text = switch (kind) {
      // WHY raw is shown as sent: free text such as a reason, a time or a
      // month must not be reworded.
      _Kind.raw => value.toString(),
      _Kind.text =>
        _knownValue(locale, value.toString()) ?? _humanize(value.toString()),
      _Kind.number => numbers.number(value),
      _Kind.money => numbers.currency(value),
      _Kind.date => DateFormatter.formatDateOnly(value.toString()),
      _Kind.dateTime => switch (DateTime.tryParse(value.toString())) {
        final time? => DateFormatter.timestamp(time),
        null => value.toString(),
      },
    };
    fields.add((label: label(locale), value: text));
  }

  return fields;
}
