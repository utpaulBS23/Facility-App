import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/visit_entity.dart';

part 'visit_check_in_provider.g.dart';

class VisitCheckInState {
  const VisitCheckInState({
    this.position,
    this.locationError,
    this.isLoadingLocation = false,
    this.captureResult,
    this.isCapturing = false,
    this.captureError,
    this.isCheckingIn = false,
    this.checkInError,
    this.checkInSuccess = false,
  });

  final Position? position;
  final String? locationError;
  final bool isLoadingLocation;
  final VisitCheckInCaptureEntity? captureResult;
  final bool isCapturing;
  final Failure? captureError;
  final bool isCheckingIn;
  final Failure? checkInError;
  final bool checkInSuccess;

  bool get hasLocation => position != null;
  bool get hasCaptureResult => captureResult != null;
  bool get isBusy => isLoadingLocation || isCapturing || isCheckingIn;

  VisitCheckInState copyWith({
    Position? position,
    String? locationError,
    bool? isLoadingLocation,
    VisitCheckInCaptureEntity? captureResult,
    bool? isCapturing,
    Failure? captureError,
    bool? isCheckingIn,
    Failure? checkInError,
    bool? checkInSuccess,
    bool clearLocationError = false,
    bool clearCaptureError = false,
    bool clearCheckInError = false,
  }) {
    return VisitCheckInState(
      position: position ?? this.position,
      locationError: clearLocationError
          ? null
          : (locationError ?? this.locationError),
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      captureResult: captureResult ?? this.captureResult,
      isCapturing: isCapturing ?? this.isCapturing,
      captureError: clearCaptureError
          ? null
          : (captureError ?? this.captureError),
      isCheckingIn: isCheckingIn ?? this.isCheckingIn,
      checkInError: clearCheckInError
          ? null
          : (checkInError ?? this.checkInError),
      checkInSuccess: checkInSuccess ?? this.checkInSuccess,
    );
  }
}

@riverpod
class VisitCheckIn extends _$VisitCheckIn {
  @override
  VisitCheckInState build() => const VisitCheckInState();

  Future<void> _fetchLocation() async {
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

  Future<void> captureCheckIn({required int visitId}) async {
    await _fetchLocation();

    final pos = state.position;
    if (pos == null) return;

    state = state.copyWith(isCapturing: true, clearCaptureError: true);

    final result = await ref
        .read(captureCheckInUseCaseProvider)
        .call(
          visitId: visitId,
          request: VisitCheckInRequestEntity(
            latitude: pos.latitude,
            longitude: pos.longitude,
          ),
        );

    state = result.when(
      success: (data) {
        ref
            .read(startLocationPingTrackingUseCaseProvider)
            .call(taskId: visitId);

        return state.copyWith(isCapturing: false, captureResult: data);
      },
      error: (err) => state.copyWith(isCapturing: false, captureError: err),
    );
  }

  Future<void> retryCapture({required int visitId}) async {
    state = const VisitCheckInState();
    await captureCheckIn(visitId: visitId);
  }

  Future<void> confirmCheckIn({required int visitId}) async {
    // WHY: use coords already validated by server during capture, not raw GPS
    // which may return (0.0, 0.0) on emulators without mock location set.
    final capture = state.captureResult;
    if (capture == null) return;

    state = state.copyWith(isCheckingIn: true, clearCheckInError: true);

    final Result<void, Failure> result = await ref
        .read(checkInVisitUseCaseProvider)
        .call(
          visitId: visitId,
          request: VisitCheckInRequestEntity(
            latitude: capture.yourLat,
            longitude: capture.yourLng,
          ),
        );

    state = result.when(
      success: (_) => state.copyWith(isCheckingIn: false, checkInSuccess: true),
      error: (err) => state.copyWith(isCheckingIn: false, checkInError: err),
    );
  }
}
