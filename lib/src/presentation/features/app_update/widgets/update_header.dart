part of '../view/app_update_dialog.dart';

class _UpdateHeader extends StatelessWidget {
  const _UpdateHeader({
    required this.isHardUpdate,
    this.latestVersionName,
    this.latestVersionCode,
    this.currentVersionName,
    this.currentVersionCode,
  });

  final bool isHardUpdate;
  final String? latestVersionName;
  final int? latestVersionCode;
  final String? currentVersionName;
  final int? currentVersionCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(context.dimensions.padding.p16),
          decoration: BoxDecoration(
            color: isHardUpdate
                ? context.color.error.withValues(alpha: 0.1)
                : context.color.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.system_update_rounded,
            size: 40,
            color: isHardUpdate ? context.color.error : context.color.primary,
          ),
        ),
        SizedBox(height: context.dimensions.spacing.s16),
        Text(
          isHardUpdate
              ? context.locale.mandatoryUpdateTitle
              : context.locale.appUpdateAvailable,
          style: context.textStyle.titleMedium.copyWith(
            color: context.color.text.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        if (latestVersionName != null || currentVersionName != null) ...[
          SizedBox(height: context.dimensions.spacing.s12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.dimensions.padding.p16,
              vertical: context.dimensions.spacing.s8,
            ),
            decoration: BoxDecoration(
              color: context.color.brandSubtle,
              borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentVersionName != null) ...[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.locale.currentVersion,
                        style: context.textStyle.labelSmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                      SizedBox(height: context.dimensions.spacing.s2),
                      Text(
                        'v$currentVersionName${currentVersionCode != null ? ' ($currentVersionCode)' : ''}',
                        style: context.textStyle.labelMedium.copyWith(
                          color: context.color.text.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.dimensions.spacing.s12,
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: context.color.primary,
                    ),
                  ),
                ],
                if (latestVersionName != null) ...[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.locale.latestVersion,
                        style: context.textStyle.labelSmall.copyWith(
                          color: context.color.primary,
                        ),
                      ),
                      SizedBox(height: context.dimensions.spacing.s2),
                      Text(
                        'v$latestVersionName${latestVersionCode != null ? ' ($latestVersionCode)' : ''}',
                        style: context.textStyle.labelMedium.copyWith(
                          color: context.color.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
        SizedBox(height: context.dimensions.spacing.s12),
        Text(
          isHardUpdate
              ? context.locale.mandatoryUpdateMessage
              : context.locale.softUpdateMessage,
          style: context.textStyle.bodyRegular.copyWith(
            color: context.color.text.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
