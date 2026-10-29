
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../../../core/logger/log.dart';

/// Downloads a profile image and shrinks it to a tiny JPEG.
///
/// WHY: the login screen is pre-auth, so a network avatar there is slow and
/// flaky. A <= 2 KB local thumbnail renders instantly and offline.
class ThumbnailService {
  ThumbnailService(this._dio);

  /// Plain Dio, no auth interceptors: the image is a public CDN URL.
  final Dio _dio;

  static const int maxBytes = 2048;
  // WHY generous: a photo straight from a phone camera is several MB, and it
  // is decoded in an isolate, so size only costs memory and time off-screen.
  static const int _maxDownloadBytes = 15 * 1024 * 1024;

  /// Null on any failure; callers fall back to the initials avatar.
  Future<Uint8List?> fromUrl(String url) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      final data = response.data;
      if (data == null || data.isEmpty || data.length > _maxDownloadBytes) {
        Log.error('Thumbnail skipped: ${data?.length ?? 0} bytes from $url');
        return null;
      }

      final thumbnail = await compute(shrink, Uint8List.fromList(data));
      if (thumbnail == null) {
        Log.error('Thumbnail skipped: could not decode or fit the image');
      }

      return thumbnail;
      // WHY Object: decoding a corrupt image can throw an Error, not only an
      // Exception, and a cosmetic thumbnail must never surface either.
    } on Object catch (e) {
      Log.error('Thumbnail failed: $e');
      return null;
    }
  }

  /// Center-crops to a square and encodes JPEG, lowering quality, then size,
  /// until the result fits [maxBytes]. Top-level-callable for [compute].
  @visibleForTesting
  static Uint8List? shrink(Uint8List source) {
    final decoded = img.decodeImage(source);
    if (decoded == null) return null;

    for (final side in const [48, 40]) {
      final square = img.copyResizeCropSquare(decoded, size: side)
        // WHY stripped: the encoder copies the source's embedded color profile
        // and metadata into the output. A phone photo's ICC profile alone is
        // ~3 KB, more than the whole thumbnail budget.
        ..iccProfile = null
        ..exif.clear();
      for (var quality = 60; quality >= 30; quality -= 10) {
        final bytes = Uint8List.fromList(img.encodeJpg(square, quality: quality));
        if (bytes.length <= maxBytes) return bytes;
      }
    }

    return null;
  }
}
