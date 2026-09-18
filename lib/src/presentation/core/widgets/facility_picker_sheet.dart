import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions/app_localization.dart';
import '../../../domain/entities/accessible_facility_entity.dart';
import '../theme/theme.dart';
import 'text/typography.dart';

/// Facility picker shown as a modal bottom sheet from an AppBar filter
/// action — the shared shape behind Shift/Occurrence/Task/Roster's
/// facility filters, which all opened `showModalBottomSheet` with this
/// exact structure duplicated per feature.
///
/// Pops a `({int? facilityId})` record, never a bare `int?` — a bare
/// nullable return can't distinguish "picked All" from "dismissed with no
/// selection," and [includeAllOption] callers need that distinction.
class FacilityPickerSheet extends StatelessWidget {
  /// Creates a [FacilityPickerSheet].
  const FacilityPickerSheet({
    super.key,
    required this.facilities,
    required this.selectedFacilityId,
    this.includeAllOption = false,
  });

  /// The facilities to list.
  final List<AccessibleFacilityEntity> facilities;

  /// The currently selected facility id, or null for "All"/none.
  final int? selectedFacilityId;

  /// Prepends an "All facilities" row (facilityId: null) when true — for
  /// endpoints that support an unscoped query. Facility-scoped endpoints
  /// (every accessible facility resolves to exactly one) leave this false.
  final bool includeAllOption;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final itemCount = facilities.length + (includeAllOption ? 1 : 0);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      // WHY Material: ListTile paints its background/ink splashes on the
      // nearest Material ancestor. Without this, the outer Container's own
      // BoxDecoration color sits on top and hides them (Flutter's own
      // "ListTile background color or ink splashes may be invisible"
      // assertion).
      child: Material(
        type: MaterialType.transparency,
        // WHY: sheet content can sit behind the gesture/nav bar on devices
        // with no bottom inset otherwise handled by the list's own padding.
        child: SafeArea(
          top: false,
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
                child: LabelLargeText(context.locale.facilityName),
              ),
              Gap(spacing.s8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(
                    spacing.s16,
                    0,
                    spacing.s16,
                    spacing.s16,
                  ),
                  itemCount: itemCount,
                  separatorBuilder: (_, _) => Gap(spacing.s8),
                  itemBuilder: (context, index) {
                    final isAllRow = includeAllOption && index == 0;
                    final facility = isAllRow
                        ? null
                        : facilities[includeAllOption ? index - 1 : index];
                    final facilityId = facility?.id;
                    final label = isAllRow
                        ? context.locale.all
                        : facility!.name;
                    final isSelected = facilityId == selectedFacilityId;
                    return ListTile(
                      onTap: () =>
                          Navigator.of(context).pop((facilityId: facilityId)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius.r10),
                        side: BorderSide(
                          color: isSelected
                              ? context.color.primary
                              : context.color.borderSubtle,
                        ),
                      ),
                      title: Text(label),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: context.color.primary,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
