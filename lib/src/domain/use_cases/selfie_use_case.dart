// Author: Md. Shahin Bashar
// Created: 2026-04-06

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../repositories/selfie_repository.dart';

final class ValidateSelfieUseCase {
  ValidateSelfieUseCase(this._repository);

  final SelfieRepository _repository;

  Future<Result<String?, Failure>> call(String path) async {
    final result = await _repository.validateSelfie(path);

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('validate selfie')),
    };
  }
}
