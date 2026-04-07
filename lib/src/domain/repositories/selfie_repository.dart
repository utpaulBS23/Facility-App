// Author: Md. Shahin Bashar
// Created: 2026-04-06

import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';

abstract base class SelfieRepository extends Repository {
  Future<Result<String?, Failure>> pickSelfie();
}
