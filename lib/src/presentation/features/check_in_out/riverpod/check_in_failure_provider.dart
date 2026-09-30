import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import 'check_in_info_provider.dart';
import 'selfie_picker_provider.dart';

part 'check_in_failure_provider.g.dart';

/// Which check-in detector(s) failed — drives the "Request Supervisor"
/// fallback: whether it's reachable, its reason-list, and whether a manual
/// location field is offered.
enum CheckInFailureType {
  none,
  camera,
  location,
  both;

  bool get hasCameraFailure => this == camera || this == both;
  bool get hasLocationFailure => this == location || this == both;
  bool get any => this != none;
}

/// WHY a single derived provider instead of each screen re-deriving
/// `hasCameraError`/`hasLocationError` locally: the reason-list, CTA copy,
/// and manual-location field all need the same classification — one source
/// of truth keeps them from drifting apart.
@riverpod
CheckInFailureType checkInFailureType(Ref ref) {
  final selfieState = ref.watch(selfiePickerProvider);
  final selfieError = selfieState.error;
  final isNoFace = selfieError is Failure && selfieError.code == 'no_face_detected';
  final hasCameraError = selfieState.hasError && !isNoFace;
  final hasLocationError =
      ref.watch(checkInInfoProvider).valueOrNull?.locationFailure != null;

  return switch ((hasCameraError, hasLocationError)) {
    (true, true) => CheckInFailureType.both,
    (true, false) => CheckInFailureType.camera,
    (false, true) => CheckInFailureType.location,
    (false, false) => CheckInFailureType.none,
  };
}
