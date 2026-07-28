class ShiftTemplateEntity {
  const ShiftTemplateEntity({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    this.durationHours,
    this.isActive = true,
    this.notes,
  });

  final int id;
  final String name;
  final String startTime;
  final String endTime;
  final String? durationHours;
  final bool isActive;
  final String? notes;
}
