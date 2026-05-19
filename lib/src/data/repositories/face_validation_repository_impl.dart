import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/face_validation_entity.dart';
import '../../domain/repositories/face_validation_repository.dart';
import '../extension/face_validation_mapper.dart';
import '../models/face_validation_model.dart';
import '../services/network/rest_client.dart';

final class FaceValidationRepositoryImpl extends FaceValidationRepository {
  FaceValidationRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<FaceValidationEntity, Failure>> validateFace({
    required int partnerId,
    required String imagePath,
    required double lat,
    required double lng,
    required String address,
  }) async {
    return asyncGuard(() async {
      final image = await MultipartFile.fromFile(
        imagePath,
        filename: File(imagePath).uri.pathSegments.last,
      );
      final date = DateTime.now();
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final formData = FormData.fromMap({
        'image': image,
        'date': dateStr,
        'lat': lat,
        'lng': lng,
        'address': address,
      });
      final response = await remote.validateFace(partnerId, formData);
      return FaceValidationResponseModel.fromJson(response.data).toEntity();
    });
  }
}
