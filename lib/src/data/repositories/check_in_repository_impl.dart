import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/entities/check_in_entity.dart';
import '../../domain/repositories/check_in_repository.dart';
import '../extension/check_in_mapper.dart';
import '../models/check_in_model.dart';
import '../services/network/rest_client.dart';

final class CheckInRepositoryImpl extends CheckInRepository {
  CheckInRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<CheckInEntity, Failure>> checkIn({
    required int partnerId,
    required int shiftSlotId,
    required double lat,
    required double lng,
    required String selfieUrl,
  }) async {
    return asyncGuard(() async {
      final selfie = await MultipartFile.fromFile(
        selfieUrl,
        filename: File(selfieUrl).uri.pathSegments.last,
      );
      final formData = FormData.fromMap({
        'shift_slot_id': shiftSlotId,
        'lat': lat,
        'lng': lng,
        'selfie_url': selfie,
      });
      final response = await remote.checkIn(partnerId, formData);
      return CheckInResponseModel.fromJson(response.data).toEntity();
    });
  }
}
