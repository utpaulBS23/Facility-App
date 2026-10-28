import 'dart:typed_data';

import '../../core/base/base.dart';

abstract base class ThumbnailRepository extends Repository {
  /// Fetches [imageUrl] and shrinks it to a tiny JPEG.
  Future<Result<Uint8List, Failure>> fromUrl(String imageUrl);
}
