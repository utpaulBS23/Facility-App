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

      // Authorization. WHY: forbidden's backend message is usually specific
      // and actionable ("not assigned to this occurrence") — same rule as
      // badResponse below, it wins over the generic string when populated.
      FailureType.forbidden =>
        message.isNotEmpty ? message : locale.errorPermissionDenied,
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
