import '../../core/base/result.dart';
import '../entities/check_out_entity.dart';
import '../repositories/check_out_repository.dart';

final class CheckOutUseCase {
  CheckOutUseCase(this.repository);

  final CheckOutRepository repository;

  Future<Result<CheckOutEntity, String>> call({
    required int partnerId,
    required int shiftId,
    required String imagePath,
  }) async {
    final result = await repository.checkOut(
      partnerId: partnerId,
      shiftId: shiftId,
      imagePath: imagePath,
    );

    return switch (result) {
      Success(:final data) => Success(data: data),
      Error(:final error) => Error(error.message),
      _ => const Error('Something went wrong'),
    };
  }
}
