import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/user_tracking_entity.dart';
import '../../../core/theme/theme.dart';
import 'user_tracking_style.dart';

/// All / Online / Offline chips with counts.
class UserStatusChips extends StatelessWidget {
  const UserStatusChips({
    super.key,
    required this.data,
    required this.selected,
    required this.onSelected,
  });

  final UserTrackingEntity data;
  final UserStatusFilter selected;
  final ValueChanged<UserStatusFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final numbers = context.numbers;

    String label(String text, int count) => '$text (${numbers.integer(count)})';

    return Wrap(
      spacing: spacing.s8,
      runSpacing: spacing.s8,
      children: [
        _Chip(
          label: label(context.locale.all, data.positions.length),
          selected: selected == UserStatusFilter.all,
          onTap: () => onSelected(UserStatusFilter.all),
        ),
        _Chip(
          label: label(context.locale.statusOnline, data.onlineCount),
          selected: selected == UserStatusFilter.online,
          onTap: () => onSelected(UserStatusFilter.online),
        ),
        _Chip(
          label: label(context.locale.offline, data.offlineCount),
          selected: selected == UserStatusFilter.offline,
          onTap: () => onSelected(UserStatusFilter.offline),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.dimensions.radius.r16),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s12,
          vertical: spacing.s6,
        ),
        decoration: BoxDecoration(
          color: selected ? context.color.primary : context.color.onPrimary,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r16),
          border: Border.all(
            color: selected
                ? context.color.primary
                : context.color.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: context.textStyle.labelMedium.copyWith(
            color: selected
                ? context.color.onPrimary
                : context.color.text.primary,
          ),
        ),
      ),
    );
  }
}
