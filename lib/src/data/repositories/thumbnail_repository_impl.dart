import 'dart:typed_data';

import '../../core/base/base.dart';
import '../../domain/repositories/thumbnail_repository.dart';
import '../services/image/thumbnail_service.dart';

final class ThumbnailRepositoryImpl extends ThumbnailRepository {
  ThumbnailRepositoryImpl(this.service);

  final ThumbnailService service;

  @override
  Future<Result<Uint8List, Failure>> fromUrl(String imageUrl) async {
    final bytes = await service.fromUrl(imageUrl);

    // WHY not asyncGuard: the service reports every fetch/decode problem as
    // null, so there is no exception to map.
    return bytes == null
        ? Error(Failure.emptyResponse('build the thumbnail'))
        : Success(data: bytes);
  }
}
