import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/notification/app_notification_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../extensions/notification_grouping_extension.dart';
import '../riverpod/app_notifications_provider.dart';
import '../widgets/notification_details_sheet.dart';
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
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    // WHY no load here: the inbox is kept alive and already loaded for the
    // dashboard bell. The navigation shell refreshes it on a push and on
    // resume, so opening the page needs no request of its own.
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scroll.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      ref.read(appNotificationsProvider.notifier).loadMore();
    }
  }

  Future<void> _open(AppNotificationEntity item) async {
    final notifier = ref.read(appNotificationsProvider.notifier);
    NotificationDetailsSheet.show(context, item);
    await _run(() => notifier.markRead(item.id));
  }

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

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final inbox = ref.watch(appNotificationsProvider);
    final filter = ref.watch(notificationInboxFilterProvider);
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
          final groups = list.items.groupByDay();

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(appNotificationsProvider.notifier).refresh(),
            child: ListView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(spacing.s16),
              children: [
                // WHY a scaled box: the chips hug their content and sit in the
                // middle, and a long translation shrinks instead of overflowing.
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CategoryFilterChips<AppNotificationFilter>(
                      fitContent: true,
                      categories: AppNotificationFilter.values,
                      selectedCategory: filter,
                      onSelected: (next) => ref
                          .read(appNotificationsProvider.notifier)
                          .selectFilter(next),
                      // WHY a count on Unread only: the server counts unread
                      // across everything, not per filter.
                      labelBuilder: (context, next) =>
                          next == AppNotificationFilter.unread
                          ? '${next.label(context)} '
                                '${context.numbers.number(list.unreadCount)}'
                          : next.label(context),
                    ),
                  ),
                ),
                Gap(spacing.s12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        filter == AppNotificationFilter.all
                            ? context.locale.notificationsShowing(
                                list.items.length,
                                list.total,
                              )
                            : context.locale.notificationsShowingFiltered(
                                list.items.length,
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
                for (final (:day, :items) in groups) ...[
                  Gap(spacing.s16),
                  NotificationGroupHeader(
                    label: _dayLabel(day),
                    count: items.length,
                  ),
                  Gap(spacing.s12),
                  for (final item in items) ...[
                    NotificationListItem(
                      notification: item,
                      onTap: () => _open(item),
                    ),
                    Gap(spacing.s12),
                  ],
                ],
                if (list.hasMore)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing.s16),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
