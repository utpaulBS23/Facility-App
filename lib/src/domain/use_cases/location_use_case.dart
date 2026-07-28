// Created: 2026-04-08

import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

/// Use case for getting the current device location.
final class GetCurrentLocationUseCase {
  GetCurrentLocationUseCase(this._repository);

  final LocationRepository _repository;

  Future<Result<LocationResponseEntity, Failure>> call() async {
    final result = await _repository.getCurrentLocation();
    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('get current location')),
    };
  }
}
