import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_update_entity.dart';
import '../../../core/theme/theme.dart';
import '../riverpod/app_update_download_provider.dart';
import '../riverpod/app_update_provider.dart';

part '../widgets/update_action_buttons.dart';
part '../widgets/update_changelog.dart';
part '../widgets/update_download_progress.dart';
part '../widgets/update_header.dart';

class AppUpdateDialog extends ConsumerWidget {
  const AppUpdateDialog({
    super.key,
    required this.update,
  });

  final AppUpdateCheckResponseEntity update;

  static Future<void> show(
    BuildContext context,
    AppUpdateCheckResponseEntity update,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: !update.isHardUpdate,
      builder: (context) => AppUpdateDialog(update: update),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadState = ref.watch(appUpdateDownloadProvider);
    final isBusy = downloadState.isDownloading ||
        downloadState.isVerifying ||
        downloadState.isCompleted;

    return PopScope(
      canPop: !update.isHardUpdate && !isBusy,
      child: Dialog(
        backgroundColor: context.color.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        insetPadding: EdgeInsets.all(context.dimensions.padding.p24),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.dimensions.padding.p24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _UpdateHeader(
                isHardUpdate: update.isHardUpdate,
                latestVersionName: update.latestVersionName,
                latestVersionCode: update.latestVersionCode,
                currentVersionName: update.currentVersionName,
                currentVersionCode: update.currentVersionCode,
              ),
              if (update.changelog.isNotEmpty) ...[
                SizedBox(height: context.dimensions.spacing.s16),
                _UpdateChangelog(changelog: update.changelog),
              ],
              SizedBox(height: context.dimensions.spacing.s24),
              if (downloadState.status != DownloadStatus.idle)
                _UpdateDownloadProgress(
                  progress: downloadState,
                  onRetry: () => _handleUpdateNow(context, ref),
                )
              else
                _UpdateActionButtons(
                  isHardUpdate: update.isHardUpdate,
                  onUpdateNow: () => _handleUpdateNow(context, ref),
                  onLater: () => _handleLater(context, ref),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleUpdateNow(BuildContext context, WidgetRef ref) {
    ref.read(appUpdateDownloadProvider.notifier).startDownloadAndInstall(update);
  }

  void _handleLater(BuildContext context, WidgetRef ref) {
    context.pop();
    ref.read(appUpdateNotifierProvider.notifier).onDismissTap(update);
  }
}
