import 'package:flutter/material.dart';

import '../../../../domain/entities/user_route_entity.dart';
import '../../../core/map/app_map.dart';
import '../../../core/map/map_control_button.dart';
import '../../../core/theme/theme.dart';
import 'route_leg_card.dart';

/// Map with every leg of a route drawn as a line, numbered at its end.
///
/// The camera fits the whole route when the legs change, and the selected leg
/// when one is picked.
class RouteMap extends StatefulWidget {
  const RouteMap({super.key, required this.legs, required this.selectedLegId});

  final List<RouteLegEntity> legs;
  final int? selectedLegId;

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  final _controller = AppMapController();

  @override
  void initState() {
    super.initState();
    _fit();
  }

  @override
  void didUpdateWidget(RouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedLegId != oldWidget.selectedLegId ||
        !_sameLegs(oldWidget.legs)) {
      _fit();
    }
  }

  bool _sameLegs(List<RouteLegEntity> other) {
    if (other.length != widget.legs.length) return false;
    for (var i = 0; i < other.length; i++) {
      if (other[i].id != widget.legs[i].id) return false;
    }
    return true;
  }

  void _fit() {
    final selected = widget.legs
        .where((l) => l.id == widget.selectedLegId)
        .firstOrNull;
    final legs = selected == null ? widget.legs : [selected];
    _controller.fit([
      for (final leg in legs)
        for (final p in leg.trail) (lat: p.lat, lng: p.lng),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final lines = <MapLine>[];
    final markers = <MapMarker>[];

    for (var i = 0; i < widget.legs.length; i++) {
      final leg = widget.legs[i];
      if (leg.trail.isEmpty) continue;
      final color = routeLegColor(i);
      lines.add(
        MapLine(
          id: 'l${leg.id}',
          points: [for (final p in leg.trail) (lat: p.lat, lng: p.lng)],
          color: color,
          width: leg.id == widget.selectedLegId ? 6 : 4,
        ),
      );
      final end = leg.trail.last;
      markers.add(
        MapMarker(
          id: 'e${leg.id}',
          lat: end.lat,
          lng: end.lng,
          size: const Size(24, 24),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              '${i + 1}',
              style: context.textStyle.labelSmall.copyWith(color: Colors.white),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        AppMap(controller: _controller, markers: markers, lines: lines),
        Positioned(
          right: spacing.s12,
          bottom: spacing.s12,
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
