import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../repositories/authentication_repository.dart';

abstract base class PartnerUseCase {
  PartnerUseCase({required this.authRepository});

  final AuthenticationRepository authRepository;

  int getPartnerId() {
    final partnerId = authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      throw Exception('Active partner unavailable');
    }
    return partnerId;
  }

  Future<Result<T, Failure>> withPartnerId<T>(
    Future<Result<T, Failure>> Function(int partnerId) action,
  ) async {
    final partnerId = authRepository.currentSession?.activePartnerId;
    if (partnerId == null) {
      return const Error(Failure.partnerUnavailable);
    }

    return action(partnerId);
  }
}
