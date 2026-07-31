import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/visit_entity.dart';

part 'visit_check_in_provider.g.dart';

class VisitCheckInState {
  const VisitCheckInState({
    this.isStartingShare = false,
    this.isSharingLocation = false,
    this.shareError,
    this.isCheckingIn = false,
    this.checkInError,
    this.checkInSuccess = false,
  });

  final bool isStartingShare;
  final bool isSharingLocation;
  final Failure? shareError;
  final bool isCheckingIn;
  final Failure? checkInError;
  final bool checkInSuccess;

  bool get isBusy => isStartingShare || isCheckingIn;

  VisitCheckInState copyWith({
    bool? isStartingShare,
    bool? isSharingLocation,
    Failure? shareError,
    bool? isCheckingIn,
    Failure? checkInError,
    bool? checkInSuccess,
    bool clearShareError = false,
    bool clearCheckInError = false,
  }) {
    return VisitCheckInState(
      isStartingShare: isStartingShare ?? this.isStartingShare,
      isSharingLocation: isSharingLocation ?? this.isSharingLocation,
      shareError: clearShareError ? null : (shareError ?? this.shareError),
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

  Future<void> startLocationSharing({required int visitId}) async {
    state = state.copyWith(isStartingShare: true, clearShareError: true);

    final result = await ref
        .read(startLocationPingTrackingUseCaseProvider)
        .call(taskId: visitId);

    state = result.when(
      success: (_) =>
          state.copyWith(isStartingShare: false, isSharingLocation: true),
      error: (err) =>
          state.copyWith(isStartingShare: false, shareError: err),
    );
  }

  Future<void> confirmCheckIn({required int visitId}) async {
    state = state.copyWith(isCheckingIn: true, clearCheckInError: true);

    await ref.read(stopLocationPingTrackingUseCaseProvider).call();

    final Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isCheckingIn: false,
        checkInError: Failure.mapExceptionToFailure(e),
      );
      return;
    }

    final Result<void, Failure> result = await ref
        .read(checkInVisitUseCaseProvider)
        .call(
          visitId: visitId,
          request: VisitCheckInRequestEntity(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );

    state = result.when(
      success: (_) =>
          state.copyWith(isCheckingIn: false, checkInSuccess: true),
      error: (err) => state.copyWith(isCheckingIn: false, checkInError: err),
    );
  }
}
