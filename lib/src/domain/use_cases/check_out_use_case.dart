import '../../core/base/result.dart';
import '../entities/check_out_entity.dart';
import '../repositories/check_out_repository.dart';

final class CheckOutUseCase {
  CheckOutUseCase(this.repository);

  final CheckOutRepository repository;

  Future<Result<CheckOutEntity, String>> call({
    required int partnerId,
    required int attendanceId,
    required double lat,
    required double lng,
    required String selfieUrl,
    String? reason,
  }) async {
    final result = await repository.checkOut(
      partnerId: partnerId,
      attendanceId: attendanceId,
      lat: lat,
      lng: lng,
      selfieUrl: selfieUrl,
      reason: reason,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Something went wrong'),
    };
  }
}
