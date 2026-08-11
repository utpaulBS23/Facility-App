/// A facility as needed by the door-control screen (icon, name, address).
class FacilityEntity {
  const FacilityEntity({
    required this.id,
    required this.name,
    required this.address,
  });

  final int id;
  final String name;
  final String address;
}
