part of '../view/notification_settings_page.dart';

class _SettingsSectionLabel extends StatelessWidget {
  const _SettingsSectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: context.textStyle.labelMedium.copyWith(
        color: context.color.text.secondary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
