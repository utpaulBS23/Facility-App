part of '../view/app_update_dialog.dart';

class _UpdateChangelog extends StatelessWidget {
  const _UpdateChangelog({required this.changelog});

  final List<String> changelog;

  @override
  Widget build(BuildContext context) {
    if (changelog.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: context.color.primary,
            ),
            SizedBox(width: context.dimensions.spacing.s6),
            Text(
              context.locale.whatsNew,
              style: context.textStyle.titleSmall.copyWith(
                color: context.color.text.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: context.dimensions.spacing.s8),
        ...changelog.map(
          (item) => Padding(
            padding: EdgeInsets.only(
              bottom: context.dimensions.spacing.s6,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: context.dimensions.spacing.s6,
                    right: context.dimensions.spacing.s8,
                  ),
                  width: context.dimensions.spacing.s6,
                  height: context.dimensions.spacing.s6,
                  decoration: BoxDecoration(
                    color: context.color.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: context.textStyle.bodyRegular.copyWith(
                      color: context.color.text.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
