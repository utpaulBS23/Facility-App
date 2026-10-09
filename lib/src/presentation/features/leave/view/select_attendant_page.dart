import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_attendant_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/selection_picker_sheet.dart';
import '../riverpod/apply_leave_provider/leave_attendants_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/selectable_attendant_card.dart';
part '../widgets/shimmer/attendant_shimmer.dart';

class SelectAttendantPage extends ConsumerStatefulWidget {
  const SelectAttendantPage({super.key});

  @override
  ConsumerState<SelectAttendantPage> createState() =>
      _SelectAttendantPageState();
}

class _SelectAttendantPageState extends ConsumerState<SelectAttendantPage> {
  final _searchController = TextEditingController();

  /// Null = all facilities. Filtering is local: the attendants list already
  /// carries each attendant's facility.
  int? _facilityId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickFacility(List<LeaveAttendantEntity> attendants) async {
    final facilities = <int, String>{
      for (final attendant in attendants)
        attendant.facilityId: attendant.facilityName,
    };
    final result = await showModalBottomSheet<({int? value})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SelectionPickerSheet<int?>(
        title: context.locale.selectFacility,
        options: [
          (value: null, label: context.locale.allFacilities),
          for (final entry in facilities.entries)
            (value: entry.key, label: entry.value),
        ],
        isSelected: (value) => value == _facilityId,
      ),
    );
    if (result == null || !mounted) return;
    setState(() => _facilityId = result.value);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final attendantsState = ref.watch(leaveAttendantsProvider);
    final searchQuery = _searchController.text.trim().toLowerCase();
    final attendants = attendantsState.asData?.value;
    // WHY: a facility filter is pointless with a single facility.
    final hasMultipleFacilities =
        (attendants?.map((a) => a.facilityId).toSet().length ?? 0) > 1;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.selectAttendant,
        actions: [
          if (hasMultipleFacilities)
            IconButton(
              tooltip: context.locale.selectFacility,
              onPressed: attendants == null
                  ? null
                  : () => _pickFacility(attendants),
              icon: Badge(
                isLabelVisible: _facilityId != null,
                smallSize: spacing.s8,
                child: Icon(
                  Icons.filter_list_rounded,
                  color: color.text.primary,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.s16,
              vertical: spacing.s8,
            ),
            child: AppTextField.search(
              controller: _searchController,
              hint: context.locale.search,
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: attendantsState.when(
              loading: () => const _AttendantListShimmer(),
              error: (err, _) => AppErrorWidget(
                message: err.toString(),
                onRetry: () => ref.invalidate(leaveAttendantsProvider),
              ),
              data: (attendants) {
                final filtered = attendants.where((attendant) {
                  if (_facilityId != null &&
                      attendant.facilityId != _facilityId) {
                    return false;
                  }
                  if (searchQuery.isEmpty) return true;
                  return attendant.name.toLowerCase().contains(searchQuery) ||
                      attendant.uid.toLowerCase().contains(searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      context.locale.noAttendantsFound,
                      style: context.textStyle.bodyMedium.copyWith(
                        color: color.text.secondary,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(spacing.s16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => Gap(spacing.s12),
                  itemBuilder: (context, index) {
                    final attendant = filtered[index];
                    return _SelectableAttendantCard(
                      attendant: attendant,
                      index: index,
                      onTap: () => context.pop(attendant),
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
