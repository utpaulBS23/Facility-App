import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/visit_entity.dart';

part 'visit_check_in_provider.g.dart';

class VisitCheckInState {
  const VisitCheckInState({
    this.position,
    this.locationError,
    this.isLoadingLocation = false,
    this.isCheckingIn = false,
    this.checkInError,
    this.checkInSuccess = false,
  });

  final Position? position;
  final String? locationError;
  final bool isLoadingLocation;
  final bool isCheckingIn;
  final String? checkInError;
  final bool checkInSuccess;

  bool get hasLocation => position != null;

  VisitCheckInState copyWith({
    Position? position,
    String? locationError,
    bool? isLoadingLocation,
    bool? isCheckingIn,
    String? checkInError,
    bool? checkInSuccess,
    bool clearLocationError = false,
    bool clearCheckInError = false,
  }) {
    return VisitCheckInState(
      position: position ?? this.position,
      locationError:
          clearLocationError ? null : (locationError ?? this.locationError),
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      isCheckingIn: isCheckingIn ?? this.isCheckingIn,
      checkInError:
          clearCheckInError ? null : (checkInError ?? this.checkInError),
      checkInSuccess: checkInSuccess ?? this.checkInSuccess,
    );
  }
}

@riverpod
class VisitCheckIn extends _$VisitCheckIn {
  @override
  VisitCheckInState build() =>
      const VisitCheckInState(isLoadingLocation: true);

  Future<void> getLocation() async {
    state = state.copyWith(isLoadingLocation: true, clearLocationError: true);

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      state = state.copyWith(
        isLoadingLocation: false,
        locationError: 'permission_denied',
      );
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      state = state.copyWith(isLoadingLocation: false, position: position);
    } catch (e) {
      state = state.copyWith(
        isLoadingLocation: false,
        locationError: e.toString(),
      );
    }
  }

  Future<void> confirmCheckIn({required int visitId}) async {
    final pos = state.position;
    if (pos == null) return;

    final user = ref.read(getCurrentUserUseCaseProvider).call();
    final partnerId = user?.partnerId;
    if (partnerId == null) return;

    state = state.copyWith(isCheckingIn: true, clearCheckInError: true);

    final Result<void, String> result = await ref
        .read(checkInVisitUseCaseProvider)
        .call(
          partnerId: partnerId,
          visitId: visitId,
          request: VisitCheckInRequestEntity(
            latitude: pos.latitude,
            longitude: pos.longitude,
          ),
        );

    state = result.when(
      success: (_) => state.copyWith(
        isCheckingIn: false,
        checkInSuccess: true,
      ),
      error: (err) => state.copyWith(
        isCheckingIn: false,
        checkInError: err,
      ),
    );
  }
}
