import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'maplibre_app_map.dart';

/// A geographic point.
typedef MapPoint = ({double lat, double lng});

/// A Flutter widget pinned to a point on the map.
class MapMarker {
  const MapMarker({
    required this.id,
    required this.lat,
    required this.lng,
    required this.child,
    this.size = const Size(40, 40),
    this.anchor = Alignment.center,
  });

  final String id;
  final double lat;
  final double lng;
  final Widget child;
  final Size size;

  /// Which point of [child] sits on the coordinate: [Alignment.center] for a
  /// dot, [Alignment.bottomCenter] for a pin whose tip marks the spot.
  final Alignment anchor;
}

/// What the map implementation offers the screen that owns it.
abstract interface class AppMapDriver {
  bool get ready;
  void fit(List<MapPoint> points);
  void moveTo(MapPoint point, double zoom);
  void zoomBy(double delta);
}

/// Moves the camera of an [AppMap].
///
/// Calls made before the map has loaded are not lost: the latest one runs as
/// soon as the map is ready.
class AppMapController {
  AppMapDriver? _driver;
  void Function(AppMapDriver driver)? _pending;

  /// Fits the camera around [points].
  void fit(List<MapPoint> points) => _run((d) => d.fit(points));

  /// Centers the camera on [point] at [zoom].
  void moveTo(MapPoint point, {double zoom = 16}) =>
      _run((d) => d.moveTo(point, zoom));

  /// Zooms by [delta] levels around the current center.
  void zoomBy(double delta) => _run((d) => d.zoomBy(delta));

  void _run(void Function(AppMapDriver driver) action) {
    final driver = _driver;
    if (driver != null && driver.ready) {
      action(driver);
    } else {
      _pending = action;
    }
  }

  /// Called by the map implementation.
  void attach(AppMapDriver driver) => _driver = driver;

  /// Called by the map implementation.
  void detach(AppMapDriver driver) {
    if (_driver == driver) _driver = null;
  }

  /// Called by the map implementation once it is ready for camera moves.
  void flushPending() {
    final driver = _driver;
    final pending = _pending;
    if (driver == null || !driver.ready || pending == null) return;
    _pending = null;
    pending(driver);
  }
}

typedef AppMapBuilder =
    Widget Function(
      BuildContext context,
      AppMapController controller,
      List<MapMarker> markers,
    );

/// WHY a provider: the real map is a native platform view, which widget tests
/// cannot build. Tests override this with a plain widget.
final appMapBuilderProvider = Provider<AppMapBuilder>(
  (ref) =>
      (context, controller, markers) =>
          MapLibreAppMap(controller: controller, markers: markers),
);

/// The base map for every map screen, with [markers] drawn on top.
class AppMap extends ConsumerWidget {
  const AppMap({super.key, required this.controller, required this.markers});

  final AppMapController controller;
  final List<MapMarker> markers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(appMapBuilderProvider)(context, controller, markers);
  }
}
