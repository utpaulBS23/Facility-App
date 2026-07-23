import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/check_in_entity.dart';

abstract base class CheckInRepository extends Repository {
  Future<Result<CheckInEntity, Failure>> checkIn({
    required int partnerId,
    required int shiftSlotId,
    required double lat,
    required double lng,
    required String selfieUrl,
  });
}
