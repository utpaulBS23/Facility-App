import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/attendant_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/facility_attendants_provider.dart';

class AssignStaffPage extends ConsumerStatefulWidget {
  const AssignStaffPage({super.key, required this.facilityId});

  final int facilityId;

  @override
  ConsumerState<AssignStaffPage> createState() => _AssignStaffPageState();
}

class _AssignStaffPageState extends ConsumerState<AssignStaffPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref
          .read(facilityAttendantsProvider.notifier)
          .fetch(facilityId: widget.facilityId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final attendantsState = ref.watch(facilityAttendantsProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: context.pop,
          child: Row(
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: context.color.primary,
                size: 28,
              ),
              Text(
                context.locale.back,
                style: context.textStyle.labelXl.copyWith(
                  color: context.color.primary,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
        title: LabelLargeText(context.locale.assignStaff),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: attendantsState.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, _) => Center(
          child: Text(
            err.toString(),
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.text.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        data: (attendants) {
          if (attendants.isEmpty) {
            return Center(
              child: Text(
                context.locale.noAttendantsFound,
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(spacing.s16),
            itemCount: attendants.length,
            separatorBuilder: (context, index) => Gap(spacing.s12),
            itemBuilder: (context, index) =>
                _AttendantTile(attendant: attendants[index]),
          );
        },
      ),
    );
  }
}

class _AttendantTile extends StatelessWidget {
  const _AttendantTile({required this.attendant});

  final AttendantEntity attendant;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(color: context.color.borderSubtle),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
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
                Text(
                  attendant.name,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
                Gap(spacing.s2),
                Text(
                  attendant.phone,
                  style: context.textStyle.bodySmall.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s8,
              vertical: spacing.s4,
            ),
            decoration: BoxDecoration(
              color: attendant.assignment.isActive
                  ? context.color.successAlt
                  : context.color.warningAlt,
              borderRadius: BorderRadius.circular(
                context.dimensions.radius.r4,
              ),
            ),
            child: Text(
              attendant.assignment.assignmentType,
              style: context.textStyle.labelSmall.copyWith(
                color: attendant.assignment.isActive
                    ? context.color.success
                    : context.color.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
