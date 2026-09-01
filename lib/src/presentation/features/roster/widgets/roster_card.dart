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
                      style: context.textStyle.titleMedium.copyWith(
                        color: context.color.text.muted,
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
                style: context.textStyle.titleMedium.copyWith(
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
                        minHeight: spacing.s6,
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
                  permissions: [UserPermission.rosterPublish],
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
                                dimension: context.dimensions.spacing.s16,
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
