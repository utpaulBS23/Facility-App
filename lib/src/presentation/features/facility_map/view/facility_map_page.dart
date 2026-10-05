import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/facility_map_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../riverpod/facility_map_provider.dart';
import '../widgets/tracking_attendant_sheet.dart';
import '../widgets/tracking_filter_bar.dart';
import '../widgets/tracking_map.dart';
import '../widgets/tracking_pin_sheets.dart';
import '../widgets/tracking_summary_bar.dart';

/// Map of active facilities and attendants, filterable by facility and
/// attendant.
class FacilityMapPage extends ConsumerStatefulWidget {
  const FacilityMapPage({super.key});

  @override
  ConsumerState<FacilityMapPage> createState() => _FacilityMapPageState();
}

class _FacilityMapPageState extends ConsumerState<FacilityMapPage>
    with WidgetsBindingObserver {
  int? _facilityId;
  int? _staffId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // WHY: attendant photo URLs expire after about 24 hours, and positions go
    // stale while the app is in the background.
    if (state == AppLifecycleState.resumed) _refresh();
  }

  void _refresh() => ref.invalidate(facilityMapProvider);

  void _clearFilters() => setState(() {
    _facilityId = null;
    _staffId = null;
  });

  Future<void> _pickFacility() async {
    final facilities =
        ref.read(userSessionProvider)?.accessibleFacilities ?? const [];
    final result = await showModalBottomSheet<({int? facilityId})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FacilityPickerSheet(
        facilities: facilities,
        selectedFacilityId: _facilityId,
        includeAllOption: true,
      ),
    );
    if (result == null || result.facilityId == _facilityId) return;
    setState(() {
      _facilityId = result.facilityId;
      // WHY: attendants are listed per facility, so a selection from another
      // facility no longer applies.
      _staffId = null;
    });
  }

  Future<void> _pickAttendant(FacilityMapEntity? data) async {
    final staff =
        ref
            .read(facilityMapAttendantsProvider(facilityId: _facilityId))
            .valueOrNull ??
        const [];
    final result = await showModalBottomSheet<({int? staffId})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          TrackingAttendantSheet(staff: staff, selectedStaffId: _staffId),
    );
    if (result == null || !mounted) return;
    setState(() => _staffId = result.staffId);

    final id = result.staffId;
    if (id == null || data == null) return;
    final pin = data.staff.where((s) => s.id == id).firstOrNull;
    if (pin == null) {
      // WHY: the server leaves attendants without a position out of the map.
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.locale.noLocationAvailable)),
        );
      return;
    }
    _showSheet(StaffPinSheet(staff: pin));
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
    final state = ref.watch(facilityMapProvider(facilityId: _facilityId));
    final languageCode = context.languageCode;
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ?? const [];
    final attendants =
        ref
            .watch(facilityMapAttendantsProvider(facilityId: _facilityId))
            .valueOrNull ??
        const [];
    final selectedFacility = facilities
        .where((f) => f.id == _facilityId)
        .firstOrNull;
    final selectedAttendant = attendants
        .where((s) => s.id == _staffId)
        .firstOrNull;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.facilityLocations,
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          TrackingFilterBar(
            facilityLabel:
                selectedFacility?.localizedName(languageCode) ??
                context.locale.allFacilities,
            attendantLabel:
                selectedAttendant?.localizedName(languageCode) ??
                context.locale.attendant,
            hasFilters: _facilityId != null || _staffId != null,
            onFacilityTap: _pickFacility,
            onAttendantTap: () => _pickAttendant(state.valueOrNull),
            onClear: _clearFilters,
          ),
          Expanded(
            child: state.when(
              loading: () => const Center(child: LoadingIndicator()),
              error: (_, _) => AppErrorWidget(
                message: context.locale.somethingWentWrong,
                onRetry: _refresh,
              ),
              data: (data) => _MapBody(
                data: data,
                selectedStaffId: _staffId,
                onFacilityTap: (f) => _showSheet(FacilityPinSheet(facility: f)),
                onStaffTap: (s) => _showSheet(StaffPinSheet(staff: s)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapBody extends StatelessWidget {
  const _MapBody({
    required this.data,
    required this.selectedStaffId,
    required this.onFacilityTap,
    required this.onStaffTap,
  });

  final FacilityMapEntity data;
  final int? selectedStaffId;
  final ValueChanged<FacilityPinEntity> onFacilityTap;
  final ValueChanged<StaffPinEntity> onStaffTap;

  @override
  Widget build(BuildContext context) {
    final isEmpty = data.facilities.isEmpty && data.staff.isEmpty;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              TrackingMap(
                facilities: data.facilities,
                staff: data.staff,
                selectedStaffId: selectedStaffId,
                onFacilityTap: onFacilityTap,
                onStaffTap: onStaffTap,
              ),
              if (isEmpty)
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
        TrackingSummaryBar(summary: data.summary),
      ],
    );
  }
}
