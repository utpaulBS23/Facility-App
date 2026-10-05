import 'package:flutter/material.dart';

import '../../../../domain/entities/facility_map_entity.dart';
import '../../../core/map/app_map.dart';
import '../../../core/map/map_control_button.dart';
import '../../../core/theme/theme.dart';
import 'tracking_legend.dart';
import 'tracking_markers.dart';

/// The map with facility pins, attendant markers, zoom/recenter controls and
/// the legend.
///
/// The camera fits every pin whenever the set of pins changes (first load, a
/// filter change, a refresh), and moves to the selected attendant when one is
/// picked.
class TrackingMap extends StatefulWidget {
  const TrackingMap({
    super.key,
    required this.facilities,
    required this.staff,
    required this.onFacilityTap,
    required this.onStaffTap,
    this.selectedStaffId,
  });

  final List<FacilityPinEntity> facilities;
  final List<StaffPinEntity> staff;
  final ValueChanged<FacilityPinEntity> onFacilityTap;
  final ValueChanged<StaffPinEntity> onStaffTap;

  /// When set, the camera moves to this attendant's pin.
  final int? selectedStaffId;

  @override
  State<TrackingMap> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  final _controller = AppMapController();

  List<MapPoint> get _points => [
    for (final f in widget.facilities) (lat: f.lat, lng: f.lng),
    for (final s in widget.staff) (lat: s.lat, lng: s.lng),
  ];

  @override
  void initState() {
    super.initState();
    widget.selectedStaffId == null ? _fit() : _focusSelected();
  }

  @override
  void didUpdateWidget(TrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedStaffId != null &&
        widget.selectedStaffId != oldWidget.selectedStaffId) {
      _focusSelected();
    } else if (!_samePins(oldWidget)) {
      _fit();
    }
  }

  bool _samePins(TrackingMap other) {
    final oldIds = {
      for (final f in other.facilities) 'f${f.id}',
      for (final s in other.staff) 's${s.id}',
    };
    final newIds = {
      for (final f in widget.facilities) 'f${f.id}',
      for (final s in widget.staff) 's${s.id}',
    };
    return oldIds.length == newIds.length && oldIds.containsAll(newIds);
  }

  void _focusSelected() {
    final staff = widget.staff
        .where((s) => s.id == widget.selectedStaffId)
        .firstOrNull;
    if (staff == null) {
      _fit();
      return;
    }
    _controller.moveTo((lat: staff.lat, lng: staff.lng));
  }

  void _fit() => _controller.fit(_points);

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Stack(
      children: [
        AppMap(
          controller: _controller,
          markers: [
            for (final facility in widget.facilities)
              MapMarker(
                id: 'f${facility.id}',
                lat: facility.lat,
                lng: facility.lng,
                size: const Size(44, 44),
                // The pin's tip marks the spot.
                anchor: Alignment.bottomCenter,
                child: FacilityMarker(
                  facility: facility,
                  onTap: () => widget.onFacilityTap(facility),
                ),
              ),
            for (final staff in widget.staff)
              MapMarker(
                id: 's${staff.id}',
                lat: staff.lat,
                lng: staff.lng,
                child: StaffMarker(
                  staff: staff,
                  onTap: () => widget.onStaffTap(staff),
                ),
              ),
          ],
        ),
        Positioned(
          left: spacing.s12,
          top: spacing.s12,
          child: const TrackingLegend(),
        ),
        Positioned(
          right: spacing.s12,
          bottom: spacing.s32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MapControlButton(
                icon: Icons.add_rounded,
                onTap: () => _controller.zoomBy(1),
              ),
              SizedBox(height: spacing.s8),
              MapControlButton(
                icon: Icons.remove_rounded,
                onTap: () => _controller.zoomBy(-1),
              ),
              SizedBox(height: spacing.s8),
              MapControlButton(icon: Icons.my_location_rounded, onTap: _fit),
            ],
          ),
        ),
      ],
    );
  }
}
