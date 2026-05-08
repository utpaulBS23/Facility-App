import '../../core/base/base.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/repositories/shift_repository.dart';
import '../extension/shift_mapper.dart';
import '../models/shift_model.dart';
import '../services/network/rest_client.dart';

final class ShiftRepositoryImpl extends ShiftRepository {
  ShiftRepositoryImpl(this.remote);

  final RestClient remote;

  @override
  Future<Result<List<ShiftEntity>, Failure>> getMyShifts({
    required int partnerId,
    required String date,
  }) {
    return asyncGuard(() async {
      final response = await remote.getMyShifts(
        partnerId: partnerId,
        date: date,
      );
      final model = ShiftResponseModel.fromJson(response.data);
      return model.data.map((s) => s.toEntity()).toList();
    });
  }
}
