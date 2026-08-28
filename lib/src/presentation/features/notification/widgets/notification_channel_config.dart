import 'package:flutter/widgets.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/notification_channel_entity.dart';

/// One toggleable row on the Notification page. [NotificationChannelType.general]
/// is deliberately excluded — it's the fallback bucket for every untyped push
/// today, so switching it off would silence all of them.
class NotificationChannelConfig {
  const NotificationChannelConfig({
    required this.type,
    required this.label,
    required this.subtitle,
    this.permissions = const [],
  });

  final NotificationChannelType type;
  final String Function(BuildContext context) label;
  final String Function(BuildContext context) subtitle;

  /// Holding any one of these shows the channel — an OR, matching
  /// [PermissionGate]. Empty = always visible.
  final List<UserPermission> permissions;
}

final List<NotificationChannelConfig> notificationChannelConfigs = [
  NotificationChannelConfig(
    type: NotificationChannelType.task,
    label: (context) => context.locale.taskChannel,
    subtitle: (context) => context.locale.taskChannelSubtitle,
    permissions: [UserPermission.taskView, UserPermission.taskOccurrenceView],
  ),
  NotificationChannelConfig(
    type: NotificationChannelType.attendanceLeave,
    label: (context) => context.locale.attendanceLeaveChannel,
    subtitle: (context) => context.locale.attendanceLeaveChannelSubtitle,
    permissions: [
      UserPermission.attendanceView,
      UserPermission.leaveApproveSupervisor,
      UserPermission.leaveApproveManager,
      UserPermission.leaveRequestView,
      UserPermission.leaveRequestCreateOwn,
      UserPermission.leaveRequestCreateForOthers,
      UserPermission.leaveRequestApprove,
    ],
  ),
  NotificationChannelConfig(
    type: NotificationChannelType.issue,
    label: (context) => context.locale.issueChannel,
    subtitle: (context) => context.locale.issueChannelSubtitle,
    permissions: [UserPermission.issueView, UserPermission.issueCreate],
  ),
  NotificationChannelConfig(
    type: NotificationChannelType.supply,
    label: (context) => context.locale.supplyChannel,
    subtitle: (context) => context.locale.supplyChannelSubtitle,
    permissions: [
      UserPermission.supplyRequestView,
      UserPermission.deliveryTrackingView,
      UserPermission.deliveryComplaintView,
    ],
  ),
];
