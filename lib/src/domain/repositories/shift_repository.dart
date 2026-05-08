import '../../core/base/base.dart';
import '../entities/shift_entity.dart';

abstract base class ShiftRepository extends Repository {
  Future<Result<List<ShiftEntity>, Failure>> getMyShifts({
    required int partnerId,
    required String date,
  });
}
