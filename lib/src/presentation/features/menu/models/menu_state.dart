class MenuState {
  const MenuState({
    required this.name,
    this.nameBn = '',
    required this.email,
    this.partnerName,
    this.partnerNameBn = '',
    this.avatarUrl,
    this.appVersion,
    this.buildNumber,
  });

  final String name;
  final String nameBn;
  final String email;
  final String? partnerName;
  final String partnerNameBn;
  final String? avatarUrl;
  final String? appVersion;
  final String? buildNumber;

  MenuState copyWith({
    String? name,
    String? nameBn,
    String? email,
    String? partnerName,
    String? partnerNameBn,
    String? avatarUrl,
    String? appVersion,
    String? buildNumber,
  }) {
    return MenuState(
      name: name ?? this.name,
      nameBn: nameBn ?? this.nameBn,
      email: email ?? this.email,
      partnerName: partnerName ?? this.partnerName,
      partnerNameBn: partnerNameBn ?? this.partnerNameBn,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
    );
  }
}
