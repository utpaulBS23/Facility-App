import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../domain/entities/app_notification_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/text/typography.dart';
import 'notification_data_fields.dart';

/// One notification in full, shown in place of a detail page. Read only; the
/// notification never links out to a record.
class NotificationDetailsSheet extends StatelessWidget {
  const NotificationDetailsSheet({super.key, required this.notification});

  final AppNotificationEntity notification;

  static Future<void> show(
    BuildContext context,
    AppNotificationEntity notification,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NotificationDetailsSheet(notification: notification),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;
    final fields = notificationFields(context, notification.data);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        color: color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                notification.title,
                style: context.textStyle.titleMedium.copyWith(
                  color: color.text.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(spacing.s4),
              BodySmallText(
                DateFormatter.timestamp(notification.createdAt),
                color: color.text.secondary,
              ),
              Gap(spacing.s12),
              Text(notification.body, style: context.textStyle.bodyMedium),
              if (fields.isNotEmpty) ...[
                Gap(spacing.s16),
                for (final field in fields)
                  Padding(
                    padding: EdgeInsets.only(bottom: spacing.s8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: BodySmallText(
                            field.label,
                            color: color.text.secondary,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            field.value,
                            style: context.textStyle.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
