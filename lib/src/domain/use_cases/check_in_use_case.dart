import '../../core/base/result.dart';
import '../entities/check_in_entity.dart';
import '../repositories/check_in_repository.dart';

final class CheckInUseCase {
  CheckInUseCase(this.repository);

  final CheckInRepository repository;

  Future<Result<CheckInEntity, String>> call({
    required int partnerId,
    required int shiftSlotId,
    required double lat,
    required double lng,
    required String selfieUrl,
  }) async {
    final result = await repository.checkIn(
      partnerId: partnerId,
      shiftSlotId: shiftSlotId,
      lat: lat,
      lng: lng,
      selfieUrl: selfieUrl,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Something went wrong'),
    };
  }
}
