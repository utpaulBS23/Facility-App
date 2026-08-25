part of '../view/app_update_dialog.dart';

class _UpdateDownloadProgress extends StatelessWidget {
  const _UpdateDownloadProgress({
    required this.progress,
    required this.onRetry,
  });

  final DownloadProgressEntity progress;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (progress.isError) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: context.color.error,
            size: 36,
          ),
          SizedBox(height: context.dimensions.spacing.s8),
          Text(
            context.locale.downloadFailed,
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.error,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.dimensions.spacing.s16),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: context.color.primary,
              foregroundColor: context.color.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
              ),
            ),
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(
              context.locale.retry,
              style: context.textStyle.labelMedium.copyWith(
                color: context.color.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    final statusText = switch (progress.status) {
      DownloadStatus.verifying => context.locale.verifyingUpdate,
      DownloadStatus.completed => context.locale.installingUpdate,
      _ => context.locale.downloadingUpdate,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              statusText,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (progress.isDownloading && progress.totalBytes > 0)
              Text(
                '${progress.progressPercent}%',
                style: context.textStyle.labelSmall.copyWith(
                  color: context.color.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        SizedBox(height: context.dimensions.spacing.s8),
        ClipRRect(
          borderRadius: BorderRadius.circular(context.dimensions.radius.r4),
          child: LinearProgressIndicator(
            value: progress.isDownloading && progress.totalBytes > 0
                ? progress.progress
                : null,
            backgroundColor: context.color.borderSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(context.color.primary),
            minHeight: context.dimensions.spacing.s8,
          ),
        ),
      ],
    );
  }
}
