class NavigationDrawerState {
  const NavigationDrawerState({
    required this.name,
    required this.email,
    this.partnerName,
  });

  final String name;
  final String email;
  final String? partnerName;
}
