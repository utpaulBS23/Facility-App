class DoorStatusModel {
  const DoorStatusModel({
    required this.door,
    required this.name,
    required this.locked,
    required this.status,
  });

  final String door;
  final String name;
  final bool locked;
  final String status;

  bool get isClosed => locked || status == 'closed';
  bool get isOpen => !locked || status == 'open';

  factory DoorStatusModel.fromJson(Map<String, dynamic> json) {
    return DoorStatusModel(
      door: json['door'] as String? ?? '',
      name: json['name'] as String? ?? '',
      locked: json['locked'] as bool? ?? true,
      status: json['status'] as String? ?? 'closed',
    );
  }
}
