import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../../core/config/app_env.dart';
import 'app_map.dart';

const _barikoiStyle =
    'https://map.barikoi.com/styles/barikoi-light/style.json?key=';

// Used when there is no Barikoi key.
const _osmStyle =
    '{"version":8,"sources":{"osm":{"type":"raster","tiles":'
    '["https://tile.openstreetmap.org/{z}/{x}/{y}.png"],"tileSize":256}},'
    '"layers":[{"id":"osm","type":"raster","source":"osm"}]}';

String _styleString() {
  final key = AppEnv.barikoiApiKey;
  return key.isEmpty ? _osmStyle : '$_barikoiStyle$key';
}

/// [AppMap] drawn by MapLibre (native GPU rendering) with the Barikoi style.
///
/// The markers are ordinary Flutter widgets, laid over the map and re-placed
/// from their coordinates whenever the camera moves.
class MapLibreAppMap extends StatefulWidget {
  const MapLibreAppMap({
    super.key,
    required this.controller,
    required this.markers,
    this.lines = const [],
  });

  final AppMapController controller;
  final List<MapMarker> markers;
  final List<MapLine> lines;

  @override
  State<MapLibreAppMap> createState() => _MapLibreAppMapState();
}

class _MapLibreAppMapState extends State<MapLibreAppMap>
    implements AppMapDriver {
  // Central Dhaka, shown until the first fit.
  static const _fallbackCenter = LatLng(23.8103, 90.4125);

  MapLibreMapController? _map;
  bool _ready = false;
  List<Offset> _offsets = const [];
  bool _projecting = false;
  bool _projectAgain = false;
  bool _drawingLines = false;
  bool _drawLinesAgain = false;

  @override
  bool get ready => _ready;

  @override
  void initState() {
    super.initState();
    widget.controller.attach(this);
  }

  @override
  void dispose() {
    widget.controller.detach(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(MapLibreAppMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.detach(this);
      widget.controller.attach(this);
    }
    if (!identical(oldWidget.markers, widget.markers)) _project();
    if (!identical(oldWidget.lines, widget.lines)) _drawLines();
  }

  void _onStyleLoaded() {
    _ready = true;
    widget.controller.flushPending();
    _project();
    _drawLines();
  }

  @override
  void setLines(List<MapLine> lines) => _drawLines();

  Future<void> _drawLines() async {
    final map = _map;
    if (map == null || !_ready || !mounted) return;
    if (_drawingLines) {
      _drawLinesAgain = true;
      return;
    }
    _drawingLines = true;
    try {
      do {
        _drawLinesAgain = false;
        await map.clearLines();
        for (final line in widget.lines) {
          if (line.points.length < 2) continue;
          await map.addLine(
            LineOptions(
              geometry: [for (final p in line.points) LatLng(p.lat, p.lng)],
              lineColor:
                  '#${(line.color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}',
              lineWidth: line.width,
              lineJoin: 'round',
            ),
          );
        }
      } while (_drawLinesAgain && mounted);
    } finally {
      _drawingLines = false;
    }
  }

  Future<void> _project() async {
    final map = _map;
    if (map == null || !_ready || !mounted) return;
    if (_projecting) {
      _projectAgain = true;
      return;
    }
    _projecting = true;
    try {
      do {
        _projectAgain = false;
        final markers = widget.markers;
        if (markers.isEmpty) {
          if (mounted) setState(() => _offsets = const []);
          continue;
        }
        final points = await map.toScreenLocationBatch([
          for (final m in markers) LatLng(m.lat, m.lng),
        ]);
        if (!mounted) return;
        // WHY: Android reports physical pixels, iOS reports logical ones.
        final ratio = defaultTargetPlatform == TargetPlatform.android
            ? MediaQuery.devicePixelRatioOf(context)
            : 1.0;
        setState(() {
          _offsets = [for (final p in points) Offset(p.x / ratio, p.y / ratio)];
        });
      } while (_projectAgain);
    } finally {
      _projecting = false;
    }
  }

  @override
  void fit(List<MapPoint> points) {
    final map = _map;
    if (map == null || points.isEmpty) return;
    if (points.length == 1) {
      moveTo(points.first, 15);
      return;
    }
    var south = points.first.lat;
    var north = points.first.lat;
    var west = points.first.lng;
    var east = points.first.lng;
    for (final p in points) {
      if (p.lat < south) south = p.lat;
      if (p.lat > north) north = p.lat;
      if (p.lng < west) west = p.lng;
      if (p.lng > east) east = p.lng;
    }
    map.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(south, west),
          northeast: LatLng(north, east),
        ),
        left: 48,
        top: 64,
        right: 48,
        bottom: 64,
      ),
    );
  }

  @override
  void moveTo(MapPoint point, double zoom) {
    _map?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(point.lat, point.lng), zoom),
    );
  }

  @override
  void zoomBy(double delta) {
    _map?.animateCamera(CameraUpdate.zoomBy(delta));
  }

  @override
  Widget build(BuildContext context) {
    final markers = widget.markers;

    return Stack(
      children: [
        MapLibreMap(
          styleString: _styleString(),
          initialCameraPosition: const CameraPosition(
            target: _fallbackCenter,
            zoom: 10,
          ),
          minMaxZoomPreference: const MinMaxZoomPreference(5, 18),
          compassEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          onMapCreated: (controller) => _map = controller,
          onStyleLoadedCallback: _onStyleLoaded,
          onCameraMove: (_) => _project(),
          onCameraIdle: _project,
        ),
        if (_offsets.length == markers.length)
          for (var i = 0; i < markers.length; i++)
            Positioned(
              left:
                  _offsets[i].dx -
                  markers[i].size.width / 2 * (1 + markers[i].anchor.x),
              top:
                  _offsets[i].dy -
                  markers[i].size.height / 2 * (1 + markers[i].anchor.y),
              width: markers[i].size.width,
              height: markers[i].size.height,
              child: markers[i].child,
            ),
      ],
    );
  }
}
