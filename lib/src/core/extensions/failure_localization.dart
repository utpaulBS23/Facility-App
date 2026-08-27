import 'package:flutter/widgets.dart';

import '../base/failure.dart';
import 'app_localization.dart';

/// Turns a [Failure] into copy the user can read, in their own locale.
///
/// WHY: `Failure.message` is a **developer** string — an English fallback or a
/// raw server payload. It is right for logs and wrong for the UI. Presentation
/// owns copy, so the mapping from a typed failure to localized text lives here
/// and nowhere else; the domain layer never names a user-facing string.
extension FailureLocalization on Failure {
  String localized(BuildContext context) {
    final locale = context.locale;

    return switch (type) {
      // Session cannot address the data — decided before any request.
      FailureType.partnerUnavailable => locale.errorPartnerUnavailable,
      FailureType.shiftsUnavailable => locale.shiftsUnavailable,
      FailureType.noAccessibleFacility => locale.errorNoAccessibleFacility,

      // Authorization. WHY: `Failure.permissionDenied` (the client-side gate)
      // carries a hardcoded dev string here on purpose — same sentence either
      // way, the distinction only matters in logs. See failure.dart.
      FailureType.forbidden => locale.errorPermissionDenied,
      FailureType.unauthorized => locale.errorSessionExpired,

      // Transport.
      FailureType.network || FailureType.badCertificate =>
        locale.errorNoConnection,
      FailureType.timeout => locale.errorTimeout,
      FailureType.notFound => locale.errorNotFound,

      // WHY: on a 4xx/5xx the backend's own `message` is the most specific
      // thing available and is already user-facing, so it wins over a generic
      // string — but only when it is actually populated.
      FailureType.badResponse => message.isNotEmpty ? message : locale.errorGeneric,

      // Bugs and empty payloads: never show the internal text.
      FailureType.parsing ||
      FailureType.typeError ||
      FailureType.emptyResponse ||
      FailureType.illegalOperation ||
      FailureType.validation ||
      FailureType.unknown => locale.errorGeneric,
    };
  }
}

/// Convenience for the many places holding an `Object` error out of
/// `AsyncValue.error` — localizes a [Failure], falls back for anything else.
extension ObjectFailureLocalization on Object {
  String localizedMessage(BuildContext context) => switch (this) {
    Failure failure => failure.localized(context),
    _ => context.locale.errorGeneric,
  };
}
