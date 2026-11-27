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
    final isOpen = json['open'] as bool? ?? false;
    final anomaly = json['anomaly'] as String?;

    return DoorStatusModel(
      door: json['door_id'] as String? ?? json['door'] as String? ?? '',
      name: json['name'] as String? ?? '',
      locked: !isOpen,
      status: anomaly ?? (isOpen ? 'open' : 'closed'),
    );
  }
}
