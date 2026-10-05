import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/accessible_facility_entity.dart';
import '../../../../domain/entities/facility_tracking_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../riverpod/facility_tracking_provider.dart';
import '../widgets/tracking_attendant_sheet.dart';
import '../widgets/tracking_filter_bar.dart';
import '../widgets/tracking_map.dart';
import '../widgets/tracking_pin_sheets.dart';
import '../widgets/tracking_summary_bar.dart';

/// Map of facilities and attendants, filterable by facility and attendant.
class FacilityTrackingPage extends ConsumerStatefulWidget {
  const FacilityTrackingPage({super.key});

  @override
  ConsumerState<FacilityTrackingPage> createState() =>
      _FacilityTrackingPageState();
}

class _FacilityTrackingPageState extends ConsumerState<FacilityTrackingPage> {
  int? _facilityId;
  int? _staffId;

  void _clearFilters() => setState(() {
    _facilityId = null;
    _staffId = null;
  });

  Future<void> _pickFacility(FacilityTrackingEntity data) async {
    final result = await showModalBottomSheet<({int? facilityId})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FacilityPickerSheet(
        facilities: [
          for (final f in data.facilities)
            AccessibleFacilityEntity(
              id: f.id,
              name: f.name,
              nameBn: f.nameBn,
              isPrimary: false,
            ),
        ],
        selectedFacilityId: _facilityId,
        includeAllOption: true,
      ),
    );
    if (result == null || result.facilityId == _facilityId) return;
    setState(() {
      _facilityId = result.facilityId;
      // WHY: a selected attendant from another facility would leave the map
      // with every marker dimmed.
      _staffId = null;
    });
  }

  Future<void> _pickAttendant(List<StaffPinEntity> staff) async {
    final result = await showModalBottomSheet<({int? staffId})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          TrackingAttendantSheet(staff: staff, selectedStaffId: _staffId),
    );
    if (result == null) return;
    setState(() => _staffId = result.staffId);
  }

  void _showSheet(Widget sheet) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => sheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(facilityTrackingProvider);
    final languageCode = context.languageCode;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.facilityTracking,
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(facilityTrackingProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (_, _) => AppErrorWidget(
          message: context.locale.somethingWentWrong,
          onRetry: () => ref.invalidate(facilityTrackingProvider),
        ),
        data: (data) {
          final facilities = [
            for (final f in data.facilities)
              if (_facilityId == null || f.id == _facilityId) f,
          ];
          final staff = [
            for (final s in data.staff)
              if (_facilityId == null || s.facilityId == _facilityId) s,
          ];
          final selectedFacility = data.facilities
              .where((f) => f.id == _facilityId)
              .firstOrNull;
          final selectedStaff = staff
              .where((s) => s.id == _staffId)
              .firstOrNull;

          return Column(
            children: [
              TrackingFilterBar(
                facilityLabel:
                    selectedFacility?.localizedName(languageCode) ??
                    context.locale.allFacilities,
                attendantLabel:
                    selectedStaff?.localizedName(languageCode) ??
                    context.locale.attendant,
                hasFilters: _facilityId != null || _staffId != null,
                onFacilityTap: () => _pickFacility(data),
                onAttendantTap: () => _pickAttendant(staff),
                onClear: _clearFilters,
              ),
              Expanded(
                child: Stack(
                  children: [
                    TrackingMap(
                      facilities: facilities,
                      staff: staff,
                      selectedStaffId: _staffId,
                      onFacilityTap: (f) =>
                          _showSheet(FacilityPinSheet(facility: f)),
                      onStaffTap: (s) => _showSheet(StaffPinSheet(staff: s)),
                    ),
                    if (facilities.isEmpty && staff.isEmpty)
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.dimensions.spacing.s16,
                            vertical: context.dimensions.spacing.s8,
                          ),
                          decoration: BoxDecoration(
                            color: context.color.onPrimary,
                            borderRadius: BorderRadius.circular(
                              context.dimensions.radius.r12,
                            ),
                          ),
                          child: Text(context.locale.noLocationsToShow),
                        ),
                      ),
                  ],
                ),
              ),
              TrackingSummaryBar(staff: staff),
            ],
          );
        },
      ),
    );
  }
}
