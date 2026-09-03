class UpdateProfileEntity {
  const UpdateProfileEntity({
    this.name,
    this.email,
    this.phoneNumber,
  });

  final String? name;
  final String? email;
  final String? phoneNumber;
}

class ChangePasswordEntity {
  const ChangePasswordEntity({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;
}
