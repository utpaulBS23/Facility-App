import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/check_out_entity.dart';
import '../../domain/repositories/check_out_repository.dart';
import '../extension/check_out_mapper.dart';
import '../models/check_out_model.dart';
import '../services/network/rest_client.dart';
import '../../core/utils/api_date.dart';

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
    DateTime? checkOutTime,
    int? batteryLevel,
  }) async {
    return asyncGuard(() async {
      final selfie = await MultipartFile.fromFile(
        selfieUrl,
        filename: File(selfieUrl).uri.pathSegments.last,
      );
      final checkOutTimeRaw = checkOutTime == null
          ? null
          : ApiDate.dateTime(checkOutTime);
      final formData = FormData.fromMap({
        'attendance_id': attendanceId,
        'lat': lat,
        'lng': lng,
        'selfie_url': selfie,
        'reason': ?reason,
        'check_out_time': ?checkOutTimeRaw,
        'battery_level': ?batteryLevel,
      });
      final response = await remote.checkOut(partnerId, formData);
      return CheckOutResponseModel.fromJson(response.data).toEntity();
    });
  }
}
