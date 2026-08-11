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
}
