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
    required int attendanceId,
    required double lat,
    required double lng,
    required String selfieUrl,
    String? reason,
  }) async {
    return asyncGuard(() async {
      final selfie = await MultipartFile.fromFile(
        selfieUrl,
        filename: File(selfieUrl).uri.pathSegments.last,
      );
      final formData = FormData.fromMap({
        'attendance_id': attendanceId,
        'lat': lat,
        'lng': lng,
        'selfie_url': selfie,
        'reason': ?reason,
      });
      final response = await remote.checkOut(partnerId, formData);
      return CheckOutResponseModel.fromJson(response.data).toEntity();
    });
  }
}
