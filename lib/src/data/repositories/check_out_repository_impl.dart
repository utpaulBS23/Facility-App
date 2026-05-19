import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/check_out_entity.dart';
import '../../domain/repositories/check_out_repository.dart';
import '../extension/check_out_mapper.dart';
import '../models/check_out_model.dart';
import '../services/network/rest_client.dart';

final class CheckOutRepositoryImpl extends CheckOutRepository {
  CheckOutRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<CheckOutEntity, Failure>> checkOut({
    required int partnerId,
    required int shiftId,
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
        'shift_id': shiftId,
        'lat': lat,
        'lng': lng,
        'address': address,
      });
      final response = await remote.checkOut(partnerId, formData);
      return CheckOutResponseModel.fromJson(response.data).toEntity();
    });
  }
}
