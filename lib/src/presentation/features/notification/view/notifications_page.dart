import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_notification_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../riverpod/app_notifications_provider.dart';
import '../widgets/notification_filter.dart';
import '../widgets/notification_group_header.dart';
import '../widgets/notification_list_item.dart';

/// The notification inbox, newest first, grouped by day.
class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  NotificationFilter _filter = NotificationFilter.all;

  Future<void> _run(Future<Failure?> Function() action) async {
    final failure = await action();
    if (failure != null && mounted) {
      AppSnackBar.showError(context, failure.localizedMessage(context));
    }
  }

  String _dayLabel(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = today.difference(DateTime(day.year, day.month, day.day));
    if (difference.inDays == 0) return context.locale.today;
    if (difference.inDays == 1) return context.locale.yesterday;

    return DateFormatter.shortDate(day);
  }

  /// Items in the order they arrived, split into one list per calendar day.
  List<(DateTime, List<AppNotificationEntity>)> _byDay(
    List<AppNotificationEntity> items,
  ) {
    final sorted = [...items]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final groups = <(DateTime, List<AppNotificationEntity>)>[];
    for (final item in sorted) {
      final day = DateTime(
        item.createdAt.year,
        item.createdAt.month,
        item.createdAt.day,
      );
      if (groups.isNotEmpty && groups.last.$1 == day) {
        groups.last.$2.add(item);
      } else {
        groups.add((day, [item]));
      }
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final inbox = ref.watch(appNotificationsProvider);
    final unread = inbox.valueOrNull?.unreadCount;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.notificationsTitle,
        subtitle: unread == null ? null : context.locale.unreadCount(unread),
        actions: [
          IconButton(
            tooltip: context.locale.settings,
            onPressed: () => context.pushNamed(Routes.notificationSettings),
            icon: Icon(Icons.tune_rounded, color: color.text.primary),
          ),
        ],
      ),
      body: inbox.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorWidget(
          message: error.localizedMessage(context),
          onRetry: () => ref.invalidate(appNotificationsProvider),
        ),
        data: (list) {
          final visible = list.items.where(_filter.matches).toList();
          final groups = _byDay(visible);

          // WHY unread counts only: a count on a category chip says how much
          // is waiting there, and read items are not waiting.
          int waiting(NotificationFilter filter) => list.items
              .where((item) => !item.isRead && filter.matches(item))
              .length;

          return ListView(
            padding: EdgeInsets.all(spacing.s16),
            children: [
              CategoryFilterChips<NotificationFilter>(
                categories: NotificationFilter.values,
                selectedCategory: _filter,
                onSelected: (filter) => setState(() => _filter = filter),
                labelBuilder: (context, filter) =>
                    filter == NotificationFilter.all
                    ? filter.label(context)
                    : '${filter.label(context)} '
                          '${context.numbers.number(waiting(filter))}',
              ),
              Gap(spacing.s12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _filter == NotificationFilter.all
                          ? context.locale.notificationsShowing(
                              visible.length,
                              list.total,
                            )
                          : context.locale.notificationsShowingFiltered(
                              visible.length,
                            ),
                      style: context.textStyle.bodySmall.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: list.unreadCount == 0
                        ? null
                        : () => _run(
                            ref
                                .read(appNotificationsProvider.notifier)
                                .markAllRead,
                          ),
                    child: Text(
                      context.locale.markAllRead,
                      style: context.textStyle.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (groups.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing.s48),
                  child: Center(
                    child: Text(
                      context.locale.noNotifications,
                      style: context.textStyle.bodyMedium.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  ),
                ),
              for (final (day, items) in groups) ...[
                Gap(spacing.s16),
                NotificationGroupHeader(
                  label: _dayLabel(day),
                  count: items.length,
                ),
                Gap(spacing.s12),
                for (final item in items) ...[
                  NotificationListItem(
                    notification: item,
                    onTap: () {
                      if (item.isRead) return;
                      _run(
                        () => ref
                            .read(appNotificationsProvider.notifier)
                            .markRead(item.id),
                      );
                    },
                  ),
                  Gap(spacing.s12),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}
