class MenuState {
  const MenuState({
    required this.name,
    required this.email,
    this.partnerName,
    this.avatarUrl,
    this.appVersion,
    this.buildNumber,
  });

  final String name;
  final String email;
  final String? partnerName;
  final String? avatarUrl;
  final String? appVersion;
  final String? buildNumber;

  MenuState copyWith({
    String? name,
    String? email,
    String? partnerName,
    String? avatarUrl,
    String? appVersion,
    String? buildNumber,
  }) {
    return MenuState(
      name: name ?? this.name,
      email: email ?? this.email,
      partnerName: partnerName ?? this.partnerName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
    );
  }
}
