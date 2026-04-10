// Author: Md. Shahin Bashar
// Created: 2026-04-06

import '../../core/base/result.dart';
import '../repositories/selfie_repository.dart';

final class PickSelfieUseCase {
  PickSelfieUseCase(this._repository);

  final SelfieRepository _repository;

  Future<Result<String?, String>> call() async {
    final result = await _repository.pickSelfie();

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Failed to pick selfie'),
    };
  }
}
