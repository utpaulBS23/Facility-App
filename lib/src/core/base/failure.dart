import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../logger/log.dart';
import 'exceptions.dart';

part 'failure.freezed.dart';

enum FailureType {
  timeout,
  badResponse,
  badCertificate,
  network,
  parsing,
  validation,
  illegalOperation,
  notFound,
  unauthorized,
  forbidden,
  typeError,
  unknown,

  // WHY: the four below never reach the network — they are decided by the
  // session before a request is built. They are `Failure`s rather than a
  // separate error channel so a caller has exactly one thing to switch on,
  // and so presentation can localize them by [type] like any other failure.
  /// Session carries no active partner (platform/system account).
  partnerUnavailable,

  /// Session is entitled to neither shift experience.
  shiftsUnavailable,

  /// Session carries no facility to scope a facility-nested query to.
  noAccessibleFacility,

  /// Transport succeeded but the payload was absent where one was required.
  emptyResponse,
}

@freezed
abstract class Failure with _$Failure {
  const factory Failure({
    required FailureType type,
    required String message,
    String? code,
    StackTrace? stackTrace,
  }) = _Failure;

  const Failure._();

  // WHY: the `message` on these is a developer/log string, not UI copy —
  // presentation renders them by [type] through `Failure.localized(context)`.
  // It stays English on purpose so logs and crash reports read consistently
  // regardless of the user's locale.
  static const Failure partnerUnavailable = Failure(
    type: FailureType.partnerUnavailable,
    message: 'Session carries no active partner.',
  );

  static const Failure shiftsUnavailable = Failure(
    type: FailureType.shiftsUnavailable,
    message: 'Session is entitled to neither shift experience.',
  );

  static const Failure noAccessibleFacility = Failure(
    type: FailureType.noAccessibleFacility,
    message: 'Session carries no accessible facility.',
  );

  /// Client-side permission gate rejected the action before calling a use case.
  ///
  /// WHY: shares [FailureType.forbidden] with the server's 403 — the user sees
  /// the same sentence either way, and the distinction (we blocked it vs the
  /// server blocked it) only matters in logs, where [message] carries it.
  static const Failure permissionDenied = Failure(
    type: FailureType.forbidden,
    message: 'Client-side permission gate rejected the action.',
  );

  /// [operation] is a developer hint (e.g. `'get rosters'`) — logged, never shown.
  factory Failure.emptyResponse(String operation) => Failure(
    type: FailureType.emptyResponse,
    message: 'Empty payload while trying to $operation.',
  );

  factory Failure.mapExceptionToFailure(Object e) {
    if (e is DioException) {
      ({String message, String? code})? error = _parseError(e.response);

      return switch (e.type) {
        DioExceptionType.connectionTimeout => Failure(
          type: FailureType.timeout,
          message:
              error?.message ??
              'Unable to connect.'
                  'Please check your internet connection and try again.',
          code: error?.code,
          stackTrace: e.stackTrace,
        ),
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout => Failure(
          type: FailureType.timeout,
          message:
              error?.message ??
              'The request took too long to complete.'
                  'Please try again or check your network connection.',
          code: error?.code,
          stackTrace: e.stackTrace,
        ),
        // WHY: 403 = server rejected the action on authorization grounds.
        // Client gating is cosmetic; this typed failure gives every feature
        // a uniform "no permission" message when the server says no.
        DioExceptionType.badResponse when e.response?.statusCode == 403 =>
          Failure(
            type: FailureType.forbidden,
            message:
                error?.message ??
                'You do not have permission to perform this action.',
            code: error?.code,
            stackTrace: e.stackTrace,
          ),
        DioExceptionType.badResponse => Failure(
          type: FailureType.badResponse,
          message: error?.message ?? e.toString(),
          code: error?.code,
          stackTrace: e.stackTrace,
        ),
        DioExceptionType.badCertificate => Failure(
          type: FailureType.badCertificate,
          message: error?.message ?? e.toString(),
          code: error?.code,
          stackTrace: e.stackTrace,
        ),
        DioExceptionType.connectionError => Failure(
          type: FailureType.network,
          message:
              error?.message ??
              'Unable to connect to the server.'
                  'Please check your internet connection or try again later.',
          code: error?.code,
          stackTrace: e.stackTrace,
        ),
        _ => Failure(
          type: FailureType.unknown,
          message: error?.message ?? 'Something went wrong.',
          code: error?.code,
          stackTrace: e.stackTrace,
        ),
      };
    }

    if (e is CustomException) {
      return switch (e) {
        ParsingException() => Failure(
          type: FailureType.parsing,
          message: e.message,
          stackTrace: e.stackTrace,
        ),
        ValidationException() => Failure(
          type: FailureType.validation,
          message: e.message,
          stackTrace: e.stackTrace,
        ),
        IllegalOperationException() => Failure(
          type: FailureType.illegalOperation,
          message: e.message,
          stackTrace: e.stackTrace,
        ),
        NotFoundException() => Failure(
          type: FailureType.notFound,
          message: e.message,
          stackTrace: e.stackTrace,
        ),
        UnauthorizedException() => Failure(
          type: FailureType.unauthorized,
          message: e.message,
          stackTrace: e.stackTrace,
        ),
        _ => Failure(
          type: FailureType.unknown,
          message: e.toString(),
          stackTrace: e.stackTrace,
        ),
      };
    }

    if (e is Error) {
      return switch (e) {
        TypeError() => Failure(
          type: FailureType.typeError,
          message: 'Type mismatch: ${e.toString()}',
          stackTrace: e.stackTrace,
        ),
        _ => Failure(
          type: FailureType.unknown,
          message: e.toString(),
          stackTrace: e.stackTrace,
        ),
      };
    }

    return Failure(type: FailureType.unknown, message: e.toString());
  }

  static ({String message, String? code})? _parseError(Response? response) {
    if (response == null) return null;

    try {
      if (response.data is Map<String, dynamic>) {
        String message;
        final errorMap = response.data;

        if (errorMap['message'] is Map<String, dynamic>) {
          final messageMap = errorMap['message'] as Map<String, dynamic>;
          message = messageMap.values.join(' ');
        } else {
          message = errorMap['message']?.toString() ?? 'Something went wrong';
        }

        return (message: message, code: errorMap['statusCode']?.toString());
      }
    } catch (e, stackTrace) {
      Log.error(e.toString());
      Log.error(stackTrace.toString());

      return null;
    }

    return null;
  }
}
