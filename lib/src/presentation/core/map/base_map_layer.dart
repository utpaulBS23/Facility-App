import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import 'map_style_provider.dart';

/// Base tiles for every map screen: Barikoi vector tiles, with OpenStreetMap
/// raster tiles when the style cannot be loaded (no key, offline, bad key).
class BaseMapLayer extends ConsumerWidget {
  const BaseMapLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final styleState = ref.watch(barikoiStyleProvider);
    // WHY: no tiles while the style loads, so the OpenStreetMap fallback (and
    // its usage warning) only appears when Barikoi is really unavailable.
    if (styleState.isLoading) return const SizedBox.shrink();

    final style = styleState.valueOrNull;
    if (style == null) {
      return TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.bhumijo.facilityapp',
      );
    }

    return VectorTileLayer(
      theme: style.theme,
      sprites: style.sprites,
      tileProviders: style.providers,
      // WHY: the map allows zoom past the tiles' native maximum; the renderer
      // scales the last level instead of showing blanks.
      maximumZoom: 18,
      // WHY: fewer parallel tile renders and a short delay before loading keep
      // the main thread responsive while zooming on low-end phones.
      concurrency: 2,
      tileDelay: const Duration(milliseconds: 100),
    );
  }
}
