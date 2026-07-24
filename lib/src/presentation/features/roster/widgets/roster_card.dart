part of '../view/roster_list_page.dart';

class _RosterCard extends ConsumerWidget {
  const _RosterCard({required this.roster, required this.onTap});

  final RosterEntity roster;
  final VoidCallback onTap;

  bool get _isPublished => roster.status.toLowerCase() == 'published';

  void _onPublish(WidgetRef ref) {
    ref
        .read(publishRosterProvider.notifier)
        .publish(facilityId: roster.facilityId, rosterId: roster.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final progress = roster.totalShifts > 0
        ? roster.filledShifts / roster.totalShifts
        : 0.0;
    final isPublishing = ref.watch(
      publishRosterProvider.select((state) => state.isLoading),
    );

    return Material(
      color: context.color.onPrimary,
      borderRadius: BorderRadius.circular(radius.r12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius.r12),
        child: Container(
          padding: EdgeInsets.all(spacing.s16),
          decoration: BoxDecoration(
            border: Border.all(color: context.color.borderSubtle),
            borderRadius: BorderRadius.circular(radius.r12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      roster.facility?.name ?? '',
                      style: context.textStyle.labelLarge.copyWith(
                        color: context.color.text.primary,
                      ),
                    ),
                  ),
                  _Pill(
                    label: context.locale.weekly,
                    background: context.color.backgroundMuted,
                    foreground: context.color.text.secondary,
                  ),
                ],
              ),
              Gap(spacing.s4),
              Text(
                '${roster.weekStartDate} → ${roster.weekEndDate}',
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
              Gap(spacing.s12),
              _ActiveDaysRow(offDays: roster.offDays),
              Gap(spacing.s12),
              Row(
                children: [
                  _Pill(
                    label: roster.status.toLowerCase(),
                    background: _isPublished
                        ? context.color.successAlt
                        : context.color.warningAlt,
                    foreground: _isPublished
                        ? context.color.success
                        : context.color.warning,
                  ),
                  Gap(spacing.s12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius.r4),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0, 1),
                        minHeight: 6,
                        backgroundColor: context.color.backgroundMuted,
                        color: context.color.primary,
                      ),
                    ),
                  ),
                  Gap(spacing.s8),
                  Text(
                    '${roster.filledShifts}/${roster.totalShifts}',
                    style: context.textStyle.labelMedium.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ],
              ),
              if (roster.notes != null && roster.notes!.isNotEmpty) ...[
                Gap(spacing.s12),
                _LabeledText(label: context.locale.notes, value: roster.notes!),
              ],
              if (_isPublished && roster.createdBy != null) ...[
                Gap(spacing.s8),
                _LabeledText(
                  label: context.locale.publishedBy,
                  value: roster.createdBy!.fullName,
                ),
              ],
              if (!_isPublished) ...[
                Gap(spacing.s12),
                PermissionGate(
                  permission: AppPermission.rosterPublish,
                  // WHY: OverflowBar (not Align) — this app's OutlinedButton theme
                  // forces minimumSize.width = infinity, which collides with the
                  // unbounded constraints Align gives its child.
                  child: OverflowBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: isPublishing ? null : () => _onPublish(ref),
                        child: isPublishing
                            ? SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator.adaptive(
                                  valueColor: AlwaysStoppedAnimation(
                                    context.color.primary,
                                  ),
                                ),
                              )
                            : Text(context.locale.publish),
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

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimensions.spacing.s8,
        vertical: context.dimensions.spacing.s4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r4),
      ),
      child: Text(
        label,
        style: context.textStyle.labelSmall.copyWith(color: foreground),
      ),
    );
  }
}

class _LabeledText extends StatelessWidget {
  const _LabeledText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: context.textStyle.bodySmall.copyWith(
          color: context.color.text.secondary,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: context.textStyle.labelSmall.copyWith(
              color: context.color.text.primary,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

/// Mon..Sun day-of-week indicators, keyed by [DateTime.weekday] — filled when
/// active, muted when listed in [offDays].
class _ActiveDaysRow extends StatelessWidget {
  const _ActiveDaysRow({required this.offDays});

  final List<int> offDays;

  static const _initials = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var day = 1; day <= 7; day++) ...[
          if (day > 1) Gap(context.dimensions.spacing.s4),
          _DayCircle(
            label: _initials[day - 1],
            isActive: !offDays.contains(day),
          ),
        ],
      ],
    );
  }
}

class _DayCircle extends StatelessWidget {
  const _DayCircle({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  static const _size = 24.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? context.color.primary : context.color.backgroundMuted,
      ),
      child: Text(
        label,
        style: context.textStyle.labelTiny.copyWith(
          color: isActive
              ? context.color.onPrimary
              : context.color.text.secondary,
        ),
      ),
    );
  }
}
