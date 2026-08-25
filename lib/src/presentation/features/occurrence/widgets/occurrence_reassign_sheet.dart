part of '../view/occurrence_page.dart';

class _OccurrenceReassignSheet extends ConsumerWidget {
  const _OccurrenceReassignSheet({
    required this.occurrence,
    required this.facilityId,
  });

  final TaskOccurrenceEntity occurrence;
  final int facilityId;

  Future<void> _onPick(BuildContext context, WidgetRef ref, int attendantId) async {
    Navigator.of(context).pop();
    final result = await ref
        .read(taskOccurrenceReassignProvider.notifier)
        .reassign(taskOccurrenceId: occurrence.id, assignedTo: attendantId);
    if (!context.mounted) return;
    result.when(
      success: (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.occurrenceReassignSuccess)),
      ),
      error: (error) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.localized(context))),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final staffAsync = ref.watch(occurrenceFacilityStaffProvider(facilityId));

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.75),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(spacing.s12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.color.borderSubtle,
              borderRadius: BorderRadius.circular(radius.r4),
            ),
          ),
          Gap(spacing.s16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: LabelLargeText(context.locale.assignResponsibility),
          ),
          Gap(spacing.s16),
          Flexible(
            child: staffAsync.when(
              loading: () => const Center(child: CircularProgressIndicator.adaptive()),
              error: (err, _) => Center(
                child: BodySmallText(err.toString(), color: context.color.error),
              ),
              data: (staff) {
                if (staff.isEmpty) {
                  return Center(
                    child: BodySmallText(
                      context.locale.occurrenceAttendantPickerEmpty,
                      color: context.color.text.secondary,
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(spacing.s16, 0, spacing.s16, spacing.s16),
                  itemCount: staff.length,
                  separatorBuilder: (_, _) => Gap(spacing.s12),
                  itemBuilder: (context, index) {
                    final attendant = staff[index];
                    return _OccurrenceAttendantTile(
                      attendant: attendant,
                      onTap: () => _onPick(context, ref, attendant.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OccurrenceAttendantTile extends StatelessWidget {
  const _OccurrenceAttendantTile({required this.attendant, required this.onTap});

  final PartnerStaffEntity attendant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: context.color.brandAccent,
              child: Icon(
                Icons.person_outline_rounded,
                color: context.color.text.primary,
                size: 22,
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelLargeText(attendant.name),
                  Gap(spacing.s2),
                  BodySmallText(
                    attendant.phoneNumber ?? attendant.email,
                    color: context.color.text.secondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
