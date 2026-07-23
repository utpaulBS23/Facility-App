import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/permission_guard.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/shift_slot_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/assign_shift_slot_provider.dart';
import '../riverpod/partner_staff_provider.dart';
import '../riverpod/shift_slots_provider.dart';

class AssignStaffPage extends ConsumerStatefulWidget {
  const AssignStaffPage({super.key, required this.slot});

  final ShiftSlotEntity slot;

  @override
  ConsumerState<AssignStaffPage> createState() => _AssignStaffPageState();
}

class _AssignStaffPageState extends ConsumerState<AssignStaffPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(partnerStaffProvider.notifier).fetch(),
    );
  }

  Future<void> _onStaffTap(PartnerStaffEntity person) async {
    // WHY: facility lives on the day payload, not the slot, so it is read
    // back from the same provider rather than threaded through navigation
    // (same pattern as SlotDetailsPage).
    final facilityId = ref
        .read(shiftSlotsProvider)
        .valueOrNull
        ?.facility
        ?.id;
    final rosterId = widget.slot.weeklyRosterId;
    if (facilityId == null || rosterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.assignmentUnavailable)),
      );
      return;
    }

    final isSlotLead = await showDialog<bool>(
      context: context,
      builder: (_) => _SlotLeadConfirmDialog(staffName: person.name),
    );
    if (isSlotLead == null || !mounted) return;

    ref
        .read(assignShiftSlotProvider.notifier)
        .assign(
          facilityId: facilityId,
          rosterId: rosterId,
          shiftSlotId: widget.slot.shiftSlotId,
          attendantId: person.id,
          isSlotLead: isSlotLead,
        );
  }

  // WHY: assigning changes assigned_count/attendants on this day's slots, so
  // the list backing shift_slots_page must be refetched, not just popped
  // back to — its cached state would otherwise show the pre-assign roster.
  void _refreshShiftSlots() {
    final current = ref.read(shiftSlotsProvider).valueOrNull;
    final partnerId = ref.activePartnerId;
    if (current == null || partnerId == null) return;
    ref
        .read(shiftSlotsProvider.notifier)
        .fetch(
          partnerId: partnerId,
          date: current.date,
          facilityId: current.facility?.id,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(assignShiftSlotProvider, (_, next) {
      if (next is AsyncData && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.locale.staffAssignedSuccessfully)),
        );
        _refreshShiftSlots();
        context.pop();
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    final spacing = context.dimensions.spacing;
    final staffState = ref.watch(partnerStaffProvider);
    final isAssigning = ref.watch(assignShiftSlotProvider).isLoading;
    final assignedIds = widget.slot.activeAttendants
        .map((attendant) => attendant.userId)
        .toSet();

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
      body: SafeArea(
        top: false,
        child: staffState.when(
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (err, _) => Center(
            child: Text(
              err.toString(),
              style: context.textStyle.bodyMedium.copyWith(
                color: context.color.text.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          data: (staff) {
            if (staff.isEmpty) {
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
              itemCount: staff.length,
              separatorBuilder: (context, index) => Gap(spacing.s12),
              itemBuilder: (context, index) {
                final person = staff[index];
                final isSelected = assignedIds.contains(person.id);
                return _StaffTile(
                  staff: person,
                  isSelected: isSelected,
                  onAssign: isAssigning || isSelected
                      ? null
                      : () {
                          _onStaffTap(person);
                        },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _StaffTile extends StatelessWidget {
  const _StaffTile({
    required this.staff,
    required this.isSelected,
    required this.onAssign,
  });

  final PartnerStaffEntity staff;
  final bool isSelected;
  final VoidCallback? onAssign;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onAssign,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: isSelected
              ? context.color.brandAccent
              : context.color.onPrimary,
          border: Border.all(
            color: isSelected
                ? context.color.primary
                : context.color.borderSubtle,
          ),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Row(
          children: [
            _StaffAvatar(imageUrl: staff.profileImageUrl),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    staff.name,
                    style: context.textStyle.labelLarge.copyWith(
                      color: context.color.text.primary,
                    ),
                  ),
                  Gap(spacing.s2),
                  Text(
                    staff.phoneNumber ?? staff.email,
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.s8,
                  vertical: spacing.s4,
                ),
                decoration: BoxDecoration(
                  color: context.color.primary,
                  borderRadius: BorderRadius.circular(radius.r4),
                ),
                child: Text(
                  context.locale.assigned,
                  style: context.textStyle.labelSmall.copyWith(
                    color: context.color.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SlotLeadConfirmDialog extends StatelessWidget {
  const _SlotLeadConfirmDialog({required this.staffName});

  final String staffName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.color.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      title: Text(
        context.locale.assignAsSlotLead,
        style: context.textStyle.titleMedium.copyWith(
          color: context.color.text.primary,
        ),
      ),
      content: Text(
        context.locale.assignAsSlotLeadMessage(staffName),
        style: context.textStyle.bodyRegular.copyWith(
          color: context.color.text.secondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            context.locale.no,
            style: context.textStyle.labelLarge.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            context.locale.yes,
            style: context.textStyle.labelLarge.copyWith(
              color: context.color.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _StaffAvatar extends StatelessWidget {
  const _StaffAvatar({required this.imageUrl});

  final String? imageUrl;

  static const _size = 44.0;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox.square(
        dimension: _size,
        child: Container(
          color: context.color.brandAccent,
          // WHY: loadingBuilder/errorBuilder keep the placeholder icon
          // showing until the image is fully decoded, avoiding a
          // partial/broken-image flash while it loads.
          child: imageUrl == null
              ? _placeholder(context)
              : Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) =>
                      progress == null ? child : _placeholder(context),
                  errorBuilder: (context, error, stackTrace) =>
                      _placeholder(context),
                ),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Center(
      child: Icon(
        Icons.person_outline_rounded,
        color: context.color.text.primary,
        size: 22,
      ),
    );
  }
}
