// Author: Md. Shahin Bashar
// Created: 2026-04-06

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../repositories/selfie_repository.dart';

final class PickSelfieUseCase {
  PickSelfieUseCase(this._repository);

  final SelfieRepository _repository;

  Future<Result<String?, Failure>> call() => _repository.pickSelfie();
}
