import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/delivery_complaint_entity.dart';
import '../../../../domain/entities/supply/file_delivery_complaint_request.dart';

part 'file_delivery_complaint_provider.g.dart';

@riverpod
class FileDeliveryComplaint extends _$FileDeliveryComplaint {
  @override
  AsyncValue<DeliveryComplaintEntity?> build() => const AsyncValue.data(null);

  Future<void> file({
    required int deliveryId,
    required FileDeliveryComplaintRequest request,
  }) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();

    final result = await ref.read(fileDeliveryComplaintUseCaseProvider).call(
          deliveryId: deliveryId,
          request: request,
        );

    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (error) => AsyncValue.error(error, StackTrace.current),
    );
  }
}
