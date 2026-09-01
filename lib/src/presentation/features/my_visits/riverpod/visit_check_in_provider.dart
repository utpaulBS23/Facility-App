import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/travel_route_entity.dart';
import '../../../../domain/entities/visit_entity.dart';

part 'visit_check_in_provider.g.dart';

class VisitCheckInState {
  const VisitCheckInState({
    this.isStartingShare = false,
    this.isSharingLocation = false,
    this.activeTaskId,
    this.shareError,
    this.isCheckingIn = false,
    this.checkInError,
    this.checkInSuccess = false,
  });

  final bool isStartingShare;
  final bool isSharingLocation;

  /// The visit [isSharingLocation] applies to — background tracking covers
  /// one visit at a time, so a page for a different visit must not show the
  /// confirm-check-in phase just because tracking happens to be running.
  final int? activeTaskId;
  final Failure? shareError;
  final bool isCheckingIn;
  final Failure? checkInError;
  final bool checkInSuccess;

  bool get isBusy => isStartingShare || isCheckingIn;

  bool isSharingLocationFor(int taskId) =>
      isSharingLocation && activeTaskId == taskId;

  VisitCheckInState copyWith({
    bool? isStartingShare,
    bool? isSharingLocation,
    int? activeTaskId,
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
      activeTaskId: activeTaskId ?? this.activeTaskId,
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
  VisitCheckInState build() {
    // WHY seed from the repository, not always false: tracking survives
    // navigation (and app backgrounding) — reopening a visit that is
    // already being tracked must show the confirm-check-in phase
    // immediately, not reset to "Check In to Visit".
    final status = ref.read(getLocationSharingStatusUseCaseProvider).call();
    return VisitCheckInState(
      isSharingLocation: status.isSharing,
      activeTaskId: status.taskId,
    );
  }

  Future<void> startLocationSharing({
    required int visitId,
    required int facilityId,
    String? travelOriginType,
    int? travelOriginId,
  }) async {
    state = state.copyWith(isStartingShare: true, clearShareError: true);

    final Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isStartingShare: false,
        shareError: Failure.mapExceptionToFailure(e),
      );
      return;
    }

    final travelRouteResult = await ref
        .read(travelRouteCheckInUseCaseProvider)
        .call(
          request: TravelRouteCheckInRequestEntity(
            taskId: visitId,
            facilityId: facilityId,
            latitude: position.latitude,
            longitude: position.longitude,
            startType: travelOriginType,
            startId: travelOriginId,
          ),
        );

    switch (travelRouteResult) {
      case Success(:final data):
        // WHY: `travel_tracking_excluded` true means this visit has no
        // travel leg to calculate (e.g. first visit of the day) — skip
        // ping tracking entirely. Otherwise start continuous ping tracking
        // as the fallback since the Barikoi route calc doesn't cover it.
        final result = data!.travelTrackingExcluded
            ? const Success<void, Failure>()
            : await ref
                  .read(startLocationPingTrackingUseCaseProvider)
                  .call(taskId: visitId);

        state = result.when(
          success: (_) => state.copyWith(
            isStartingShare: false,
            isSharingLocation: true,
            activeTaskId: visitId,
          ),
          error: (err) =>
              state.copyWith(isStartingShare: false, shareError: err),
        );
      case Error(:final error):
        state = state.copyWith(isStartingShare: false, shareError: error);
    }
  }

  // WHY needed: travel_started_at set + not excluded + not currently
  // sharing means tracking should be running but isn't — most likely the
  // app process was killed and background tracking never survived the
  // restart. A fresh travel-routes/check-in call would re-derive a new
  // origin/distance for a leg that already started, so this instead does
  // one immediate sync ping (so the gap isn't silent) and resumes the same
  // background tracking loop, picking the in-progress leg back up.
  Future<void> resumeLocationSharing({required int visitId}) async {
    state = state.copyWith(isStartingShare: true, clearShareError: true);

    final syncResult = await ref
        .read(syncCurrentLocationPingUseCaseProvider)
        .call(taskId: visitId);

    switch (syncResult) {
      case Error(:final error):
        state = state.copyWith(isStartingShare: false, shareError: error);
        return;
      case Success():
        break;
    }

    final trackResult = await ref
        .read(startLocationPingTrackingUseCaseProvider)
        .call(taskId: visitId);

    state = trackResult.when(
      success: (_) => state.copyWith(
        isStartingShare: false,
        isSharingLocation: true,
        activeTaskId: visitId,
      ),
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
