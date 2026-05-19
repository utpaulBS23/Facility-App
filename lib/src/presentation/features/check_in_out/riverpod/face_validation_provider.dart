import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';

part 'face_validation_provider.g.dart';

@riverpod
class FaceValidation extends _$FaceValidation {
  @override
  AsyncValue build() => const AsyncValue.data(null);

  Future<void> validate({
    required int partnerId,
    required String imagePath,
    required double lat,
    required double lng,
    required String address,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    final result = await ref.read(validateFaceUseCaseProvider).call(
      partnerId: partnerId,
      imagePath: imagePath,
      lat: lat,
      lng: lng,
      address: address,
    );

    state = switch (result) {
      Success() => AsyncValue.data(result),
      Error(:final error) => AsyncValue.error(error, StackTrace.current),
      _ => AsyncValue.error('Something went wrong', StackTrace.current),
    };
  }
}
