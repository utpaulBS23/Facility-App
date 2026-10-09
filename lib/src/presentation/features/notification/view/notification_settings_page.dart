import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/dashboard_entity.dart';
import '../../../../domain/entities/notification_preference_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../riverpod/notification_preferences_provider.dart';
import '../widgets/notification_category_card.dart';
import '../widgets/notification_category_config.dart';
import '../widgets/notification_info_banner.dart';
import '../widgets/notification_info_card.dart';
import '../widgets/notification_tone.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  String _subtitle(BuildContext context, UserRole? role) {
    final locale = context.locale;
    final roleName = switch (role) {
      UserRole.partnerOwner => locale.partnerOwnerRole,
      UserRole.opsManager => locale.opsManagerRole,
      UserRole.supervisor => locale.supervisor,
      UserRole.attendant => locale.attendant,
      null => null,
    };

    return roleName == null
        ? locale.pushAndEmail
        : locale.notificationSettingsSubtitle(roleName);
  }

  Future<void> _onChanged(
    BuildContext context,
    WidgetRef ref,
    NotificationCategory category,
    NotificationChannel channel,
    bool enabled,
  ) async {
    final failure = await ref
        .read(notificationPreferencesProvider.notifier)
        .setEnabled(category: category, channel: channel, enabled: enabled);
    if (failure != null && context.mounted) {
      AppSnackBar.showError(context, failure.localizedMessage(context));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final preferences = ref.watch(notificationPreferencesProvider);
    final role = ref.watch(userSessionProvider.select((s) => s?.role));

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.notificationSettingsTitle,
        subtitle: _subtitle(context, role),
      ),
      body: preferences.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorWidget(
          message: error.localizedMessage(context),
          onRetry: () => ref.invalidate(notificationPreferencesProvider),
        ),
        data: (items) {
          final byCategory = {for (final item in items) item.category: item};
          NotificationPreferenceEntity of(NotificationCategory category) =>
              byCategory[category] ??
              NotificationPreferenceEntity.defaults(category);

          Widget card(NotificationCategoryConfig config) {
            return NotificationCategoryCard(
              config: config,
              preference: of(config.category),
              onChanged: (channel, enabled) =>
                  _onChanged(context, ref, config.category, channel, enabled),
            );
          }

          Widget sectionLabel(String text) => Text(
            text.toUpperCase(),
            style: context.textStyle.labelMedium.copyWith(
              color: context.color.text.secondary,
              fontWeight: FontWeight.bold,
            ),
          );

          return ListView(
            padding: EdgeInsets.all(spacing.s16),
            children: [
              NotificationInfoBanner(
                message: context.locale.notificationInfoBanner,
              ),
              Gap(spacing.s20),
              sectionLabel(context.locale.alertCategories),
              Gap(spacing.s12),
              for (final config in alertCategoryConfigs) ...[
                card(config),
                Gap(spacing.s12),
              ],
              Gap(spacing.s8),
              sectionLabel(context.locale.digestAndInfo),
              Gap(spacing.s12),
              card(weeklyDigestConfig),
              Gap(spacing.s12),
              NotificationInfoCard(
                icon: Icons.trending_up_rounded,
                tone: NotificationTone.success,
                title: context.locale.milestonesTitle,
                description: context.locale.milestonesDescription,
              ),
              Gap(spacing.s20),
              Center(
                child: Text(
                  context.locale.notificationRetention,
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
              ),
              Gap(spacing.s16),
            ],
          );
        },
      ),
    );
  }
}
