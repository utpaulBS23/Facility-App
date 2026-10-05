import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../../core/config/app_env.dart';

const _barikoiStyleUrl =
    'https://map.barikoi.com/styles/barikoi-light/style.json?key={key}';

/// The Barikoi vector style, or null when there is no API key.
///
/// Errors (offline, bad key) surface as an error state so the map can fall
/// back to plain OpenStreetMap tiles.
final barikoiStyleProvider = FutureProvider<Style?>((ref) async {
  final key = AppEnv.barikoiApiKey;
  if (key.isEmpty) return null;
  return StyleReader(uri: _barikoiStyleUrl, apiKey: key).read();
});
