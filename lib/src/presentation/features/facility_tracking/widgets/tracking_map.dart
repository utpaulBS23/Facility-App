import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../domain/entities/facility_tracking_entity.dart';
import '../../../core/theme/theme.dart';
import 'tracking_legend.dart';
import 'tracking_markers.dart';

/// The map with facility pins, attendant markers, zoom/recenter controls and
/// the legend.
///
/// The camera fits every visible pin whenever the set of pins changes (first
/// load, a filter change, a refresh).
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

  /// When set, every other attendant is dimmed.
  final int? selectedStaffId;

  @override
  State<TrackingMap> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  // Central Dhaka, shown until the first fit.
  static const _fallbackCenter = LatLng(23.8103, 90.4125);

  final _controller = MapController();
  bool _ready = false;

  List<LatLng> get _points => [
    for (final f in widget.facilities) LatLng(f.lat, f.lng),
    for (final s in widget.staff) LatLng(s.lat, s.lng),
  ];

  @override
  void didUpdateWidget(TrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_samePins(oldWidget)) _fit();
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

  void _fit() {
    if (!_ready) return;
    final points = _points;
    if (points.isEmpty) return;

    if (points.length == 1) {
      _controller.move(points.first, 15);
      return;
    }
    _controller.fitCamera(
      CameraFit.coordinates(
        coordinates: points,
        padding: const EdgeInsets.fromLTRB(48, 64, 48, 64),
        maxZoom: 16,
      ),
    );
  }

  void _zoomBy(double delta) {
    final camera = _controller.camera;
    _controller.move(camera.center, camera.zoom + delta);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter: _fallbackCenter,
            initialZoom: 10,
            minZoom: 3,
            maxZoom: 19,
            onMapReady: () {
              _ready = true;
              _fit();
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.bhumijo.facilityapp',
            ),
            MarkerLayer(
              alignment: Alignment.topCenter,
              markers: [
                for (final facility in widget.facilities)
                  Marker(
                    point: LatLng(facility.lat, facility.lng),
                    width: 44,
                    height: 44,
                    child: FacilityMarker(
                      facility: facility,
                      onTap: () => widget.onFacilityTap(facility),
                    ),
                  ),
              ],
            ),
            MarkerLayer(
              markers: [
                for (final staff in widget.staff)
                  Marker(
                    point: LatLng(staff.lat, staff.lng),
                    width: 40,
                    height: 40,
                    child: StaffMarker(
                      staff: staff,
                      dimmed:
                          widget.selectedStaffId != null &&
                          widget.selectedStaffId != staff.id,
                      onTap: () => widget.onStaffTap(staff),
                    ),
                  ),
              ],
            ),
            const SimpleAttributionWidget(
              source: Text('OpenStreetMap contributors'),
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
              _MapButton(icon: Icons.add_rounded, onTap: () => _zoomBy(1)),
              SizedBox(height: spacing.s8),
              _MapButton(icon: Icons.remove_rounded, onTap: () => _zoomBy(-1)),
              SizedBox(height: spacing.s8),
              _MapButton(icon: Icons.my_location_rounded, onTap: _fit),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.color.onPrimary,
      shape: CircleBorder(side: BorderSide(color: context.color.borderSubtle)),
      elevation: 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(context.dimensions.spacing.s8),
          child: Icon(icon, size: 20, color: context.color.text.primary),
        ),
      ),
    );
  }
}
