import '../../core/base/failure.dart';
import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/check_out_entity.dart';

abstract base class CheckOutRepository extends Repository {
  Future<Result<CheckOutEntity, Failure>> checkOut({
    required int partnerId,
    required int attendanceId,
    required double lat,
    required double lng,
    required String selfieUrl,
    String? reason,
  });
}
