import '../../../core/base/failure.dart';

extension CredentialRejection on Failure {
  /// True when the server looked at the credentials and said no, or there was
  /// nothing stored to send. A timeout or a dropped connection says nothing
  /// about the credentials, so those are not rejections.
  bool get isCredentialRejection {
    return switch (type) {
      FailureType.badResponse ||
      FailureType.unauthorized ||
      FailureType.validation ||
      FailureType.notFound => true,
      _ => false,
    };
  }
}
