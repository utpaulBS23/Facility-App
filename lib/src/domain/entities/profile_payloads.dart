class UpdateProfileEntity {
  const UpdateProfileEntity({
    this.name,
    this.email,
    this.phoneNumber,
    this.currentPassword,
    this.newPassword,
    this.newPasswordConfirmation,
  });

  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? currentPassword;
  final String? newPassword;
  final String? newPasswordConfirmation;
}
