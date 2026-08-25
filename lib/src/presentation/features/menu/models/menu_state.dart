class MenuState {
  const MenuState({
    required this.name,
    required this.email,
    this.partnerName,
    this.appVersion,
    this.buildNumber,
  });

  final String name;
  final String email;
  final String? partnerName;
  final String? appVersion;
  final String? buildNumber;

  MenuState copyWith({
    String? name,
    String? email,
    String? partnerName,
    String? appVersion,
    String? buildNumber,
  }) {
    return MenuState(
      name: name ?? this.name,
      email: email ?? this.email,
      partnerName: partnerName ?? this.partnerName,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
    );
  }
}
