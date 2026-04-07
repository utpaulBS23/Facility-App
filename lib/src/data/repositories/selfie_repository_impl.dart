// Author: Md. Shahin Bashar
// Created: 2026-04-06

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/repositories/selfie_repository.dart';
import '../services/media/image_picker_service.dart';

final class SelfieRepositoryImpl extends SelfieRepository {
  SelfieRepositoryImpl(this._service);

  final ImagePickerService _service;

  @override
  Future<Result<String?, Failure>> pickSelfie() {
    return asyncGuard(() => _service.pickSelfieFromCamera());
  }
}
