import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/create_issue_provider.dart';
import 'issue_attendant_picker_tile.dart';

class IssueAttendantPickerSheet extends ConsumerWidget {
  const IssueAttendantPickerSheet({super.key, required this.facilityId});

  final int facilityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final attendantsAsync = ref.watch(issueAttendantsProvider(facilityId));

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
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
              borderRadius: BorderRadius.circular(context.dimensions.radius.r4),
            ),
          ),
          Gap(spacing.s16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: LabelLargeText(context.locale.assignResponsibility),
          ),
          Gap(spacing.s16),
          Flexible(
            child: attendantsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              error: (err, _) => Center(
                child: BodySmallText(
                  err.toString(),
                  color: context.color.error,
                ),
              ),
              data: (attendants) {
                if (attendants.isEmpty) {
                  return Center(
                    child: BodySmallText(
                      context.locale.noAttendantsFound,
                      color: context.color.text.secondary,
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(
                    spacing.s16,
                    0,
                    spacing.s16,
                    spacing.s16,
                  ),
                  itemCount: attendants.length,
                  separatorBuilder: (_, _) => Gap(spacing.s12),
                  itemBuilder: (context, index) {
                    final attendant = attendants[index];
                    return IssueAttendantPickerTile(
                      attendant: attendant,
                      onTap: () => Navigator.of(context).pop(attendant),
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
